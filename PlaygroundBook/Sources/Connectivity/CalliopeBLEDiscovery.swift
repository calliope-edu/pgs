//
//  CalliopeBLEDiscovery.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 08.12.18.
//

import UIKit
import CoreBluetooth
import PlaygroundSupport

public class CalliopeBLEDiscovery: NSObject, CBCentralManagerDelegate {

	private let lastConnectedKey = "cc.calliope.latestDeviceKey"

	public enum CalliopeDiscoveryState {
		case initialized //no discovered calliopes, doing nothing
		case discoveryStarted //invoked discovery but waiting for the system bluetooth (might be off)
		case discovering //running the discovery process now, but not discovered anything yet
		case discovered //discovery list is not empty, still searching
		case discoveredAll //discovery has finished with discovered calliopes
		case connecting //connecting to some calliope
		case connected //connected to some calliope
	}

	public var updateBlock: () -> () = {}

	public private(set) var state : CalliopeDiscoveryState = .initialized {
		didSet {
			LogNotify.log("discovery state: \(state)")
			updateBlock()
		}
	}

	public private(set) var discoveredCalliopes : [String : CalliopeBLEDevice] = [:] {
		didSet {
			LogNotify.log("discovered: \(discoveredCalliopes)")
			redetermineState()
		}
	}

	public private(set) var connectingCalliope: CalliopeBLEDevice? {
		didSet {
			LogNotify.log("connecting: \(String(describing: connectingCalliope))")
			if let connectingCalliope = self.connectingCalliope {
				connectedCalliope = nil
				self.centralManager.connect(connectingCalliope.peripheral, options: nil)
				//manual timeout (system timeout is too long)
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
					if self.connectedCalliope == nil {
						self.centralManager.cancelPeripheralConnection(connectingCalliope.peripheral)
					}
				}
			}
			redetermineState()
		}
	}

	public private(set) var connectedCalliope: CalliopeBLEDevice? {
		willSet {
			connectedCalliope?.state = .discovered
			newValue?.state = .connected
		}
		didSet {
			LogNotify.log("connected: \(String(describing: connectedCalliope))")
			if connectedCalliope != nil {
				connectingCalliope = nil
			}
			lastConnected = connectedCalliope?.peripheral.identifier
			redetermineState()
		}
	}

	private let centralManager = CBCentralManager()

	private var lastConnected: UUID? {
		get {
			let store = PlaygroundKeyValueStore.current
			guard case let .string(uuidString)? = store[lastConnectedKey] else { return nil }
			return UUID(uuidString: uuidString)
		}
		set {
			let store = PlaygroundKeyValueStore.current
			guard let newUUIDString = newValue?.uuidString else {
				store[lastConnectedKey] = nil
				return
			}
			store[lastConnectedKey] = .string(newUUIDString)
		}
	}

	override init() {
		super.init()
		centralManager.delegate = self
	}

	private func redetermineState() {
		if connectedCalliope != nil {
			state = .connected
		} else if connectingCalliope != nil {
			state = .connecting
		} else if centralManager.isScanning {
			state = discoveredCalliopes.isEmpty ? .discovering : .discovered
		} else {
			state = discoveredCalliopes.isEmpty ? .initialized : .discoveredAll
		}
	}

	private func attemptReconnect() {
		LogNotify.log("attempt reconnect")
		guard let lastConnected = self.lastConnected,
		let lastCalliope = centralManager.retrievePeripherals(withIdentifiers: [lastConnected]).first,
		let name = lastCalliope.name,
		let friendlyName = Matrix.full2Friendly(fullName: name)
		else { return }

		let calliope = CalliopeBLEDevice(peripheral: lastCalliope)
		self.discoveredCalliopes.updateValue(calliope, forKey: friendlyName)
		//auto-reconnect
		LogNotify.log("reconnect to: \(calliope)")
		connectingCalliope = calliope
	}

	// MARK: discovery

	public func startCalliopeDiscovery() {
		disconnectFromCalliope()

		//start scan only if central manger already connected to bluetooth system service (=poweredOn)
		//alternatively, this is invoked after the state of the central mananger changed to poweredOn.
		if centralManager.state != .poweredOn {
			state = .discoveryStarted
		} else if !centralManager.isScanning {
			centralManager.scanForPeripherals(withServices: nil, options: nil)
			redetermineState()
			//stop the search after some time. The user can invoke it again later.
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20.0) {
				self.stopCalliopeDiscovery()
			}
		}
	}

	public func stopCalliopeDiscovery() {
		if centralManager.isScanning {
			self.centralManager.stopScan()
		}
		redetermineState()
	}

	public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		//TODO: This currently only considers calliopes, so it is not compatible to the microbit
		if let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber, connectable.boolValue == true,
			let name = peripheral.name?.lowercased(), name.contains("calliope"),
			let friendlyName = Matrix.full2Friendly(fullName: name) {
			//never create a calliope twice, since this would clear its state
			if discoveredCalliopes[friendlyName] == nil {
				//we found a calliope device (or one that pretends to be a calliope at least)
				discoveredCalliopes.updateValue(CalliopeBLEDevice(peripheral: peripheral),
												forKey: friendlyName)
			}
		}
	}

	// MARK: connection

	public func connectToCalliope(_ calliope: CalliopeBLEDevice) {
		//when we first connect, we stop searching further
		stopCalliopeDiscovery()
		//do not connect twice
		guard calliope != connectedCalliope else { return }
		connectingCalliope = calliope
	}

	public func disconnectFromCalliope() {
		if let connectedCalliope = self.connectedCalliope {
			self.centralManager.cancelPeripheralConnection(connectedCalliope.peripheral)
		}
	}

	public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		guard let name = peripheral.name,
			let parsed = Matrix.full2Friendly(fullName: name),
			let calliope = discoveredCalliopes[parsed] else {
				//TODO: log that we encountered unexpected behavior
				return
		}
		connectedCalliope = calliope
	}

	public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		connectingCalliope = nil
		connectedCalliope = nil
		lastConnected = nil
	}

	public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		//TODO: remove calliope from discovered list depending on error
		connectingCalliope = nil
	}

	// MARK: state of the bluetooth manager

	public func centralManagerDidUpdateState(_ central: CBCentralManager) {
		switch central.state {
		case .poweredOn:
			if state == .discoveryStarted {
				startCalliopeDiscovery()
			}
			if lastConnected != nil {
				attemptReconnect()
			}
		case .unknown, .resetting, .unsupported, .unauthorized, .poweredOff:
			//bluetooth is in a state where we cannot do anything
			discoveredCalliopes = [:]
			state = .initialized
		}
	}
}
