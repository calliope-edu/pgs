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

	public enum CalliopeDiscoveryState {
		case initialized //no discovered calliopes, doing nothing
		case discoveryWaitingForBluetooth //invoked discovery but waiting for the system bluetooth (might be off)
		case discovering //running the discovery process now, but not discovered anything yet
		case discovered //discovery list is not empty, still searching
		case discoveredAll //discovery has finished with discovered calliopes
		case connecting //connecting to some calliope
		case connected //connected to some calliope
	}

	public var updateQueue = DispatchQueue.main
	public var updateBlock: () -> () = {}

	public private(set) var state : CalliopeDiscoveryState = .initialized {
		didSet {
			LogNotify.log("discovery state: \(state)")
			updateQueue.async { self.updateBlock() }
		}
	}

	public private(set) var discoveredCalliopes : [String : CalliopeBLEDevice] = [:] {
		didSet {
			LogNotify.log("discovered: \(discoveredCalliopes)")
			redetermineState()
		}
	}

	private var discoveredCalliopeUUIDNameMap : [UUID : String] = [:]

	public private(set) var connectingCalliope: CalliopeBLEDevice? {
		didSet {
			LogNotify.log("connecting: \(String(describing: connectingCalliope))")
			if let connectingCalliope = self.connectingCalliope {
				connectedCalliope = nil
				self.centralManager.connect(connectingCalliope.peripheral, options: nil)
				//manual timeout (system timeout is too long)
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + BLE.connectTimeout) {
					if self.connectedCalliope == nil {
						self.centralManager.cancelPeripheralConnection(connectingCalliope.peripheral)
					}
				}
			}
			redetermineState()
		}
	}

	public private(set) var connectedCalliope: CalliopeBLEDevice? {
		didSet {
			LogNotify.log("connected: \(String(describing: connectedCalliope))")
			if connectedCalliope != nil {
				connectingCalliope = nil
			}
			if let uuid = connectedCalliope?.peripheral.identifier,
				let name = discoveredCalliopeUUIDNameMap[uuid] {
				lastConnected = (uuid, name)
			}
			redetermineState()
			oldValue?.state = .discovered
			connectedCalliope?.state = .connected
		}
	}

	private let bluetoothQueue = DispatchQueue(label: "bluetoothQueue", qos: .userInitiated, attributes: .concurrent)
	private lazy var centralManager: CBCentralManager = {
		return CBCentralManager(delegate: nil, queue: bluetoothQueue)
	}()

	private var lastConnected: (UUID, String)? {
		get {
			let store = PlaygroundKeyValueStore.current
			guard case let .dictionary(dict)? = store[BLE.lastConnectedKey],
				case let .string(name)? = dict[BLE.lastConnectedNameKey],
				case let .string(uuidString)? = dict[BLE.lastConnectedUUIDKey],
				let uuid = UUID(uuidString: uuidString)
			else { return nil }
			return (uuid, name)
		}
		set {
			let store = PlaygroundKeyValueStore.current
			guard let newUUIDString = newValue?.0.uuidString,
				let newName = newValue?.1
			else {
				store[BLE.lastConnectedKey] = nil
				return
			}
			store[BLE.lastConnectedKey] = .dictionary([BLE.lastConnectedNameKey: .string(newName),
													   BLE.lastConnectedUUIDKey: .string(newUUIDString)])
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
		guard let (lastConnectedUUID, lastConnectedName) = self.lastConnected,
		let lastCalliope = centralManager.retrievePeripherals(withIdentifiers: [lastConnectedUUID]).first
		else { return }

		let calliope = CalliopeBLEDevice(peripheral: lastCalliope, name: lastConnectedName)
		self.discoveredCalliopes.updateValue(calliope, forKey: lastConnectedName)
		self.discoveredCalliopeUUIDNameMap.updateValue(lastConnectedName, forKey: lastCalliope.identifier)
		//auto-reconnect
		LogNotify.log("reconnect to: \(calliope)")
		connectingCalliope = calliope
	}

	// MARK: discovery

	public func startCalliopeDiscovery() {
		//start scan only if central manger already connected to bluetooth system service (=poweredOn)
		//alternatively, this is invoked after the state of the central mananger changed to poweredOn.
		if centralManager.state != .poweredOn {
			state = .discoveryWaitingForBluetooth
		} else if !centralManager.isScanning {
			centralManager.scanForPeripherals(withServices: nil, options: nil)
			//stop the search after some time. The user can invoke it again later.
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + BLE.discoveryTimeout) {
				self.stopCalliopeDiscovery()
			}
			redetermineState()
		}
	}

	public func stopCalliopeDiscovery() {
		if centralManager.isScanning {
			self.centralManager.stopScan()
		}
		redetermineState()
	}

	public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		if let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber,
			connectable.boolValue == true,
			let localName = advertisementData[CBAdvertisementDataLocalNameKey],
			let lowerName = (localName as? String)?.lowercased(),
			BLE.deviceNames.map({ lowerName.contains($0) }).contains(true),
			let friendlyName = Matrix.full2Friendly(fullName: lowerName) {
			//never create a calliope twice, since this would clear its state
			if discoveredCalliopes[friendlyName] == nil {
				//we found a calliope device (or one that pretends to be a calliope at least)
				discoveredCalliopes.updateValue(CalliopeBLEDevice(peripheral: peripheral, name: friendlyName),
												forKey: friendlyName)
				discoveredCalliopeUUIDNameMap.updateValue(friendlyName, forKey: peripheral.identifier)
			}
		}
	}

	// MARK: connection

	public func connectToCalliope(_ calliope: CalliopeBLEDevice) {
		//when we first connect, we stop searching further
		stopCalliopeDiscovery()
		//do not connect twice
		guard calliope != connectedCalliope else { return }
		//reset last connected, we attempt to connect to a new callipoe now
		lastConnected = nil
		connectingCalliope = calliope
	}

	public func disconnectFromCalliope() {
		//preemptively update connected calliope, in case delegate call does not happen
		self.connectedCalliope = nil
		if let connectedCalliope = self.connectedCalliope {
			self.centralManager.cancelPeripheralConnection(connectedCalliope.peripheral)
		}
	}

	public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		guard let name = discoveredCalliopeUUIDNameMap[peripheral.identifier],
			let calliope = discoveredCalliopes[name] else {
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
			startCalliopeDiscovery()
			if lastConnected != nil {
				attemptReconnect()
			}
		case .unknown, .resetting, .unsupported, .unauthorized, .poweredOff:
			//bluetooth is in a state where we cannot do anything
			discoveredCalliopes = [:]
			discoveredCalliopeUUIDNameMap = [:]
			state = .initialized
		}
	}
}
