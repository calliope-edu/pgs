//
//  CalliopeBLEDiscovery.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 08.12.18.
//

import UIKit
import CoreBluetooth

public class CalliopeBLEDiscovery: NSObject, CBCentralManagerDelegate {

	public enum CalliopeDiscoveryState {
		case initialized //no discovered calliopes, doing nothing
		case discoveryStarted //invoked discovery but waiting for the system bluetooth (might be off)
		case discovering //running the discovery process now, but not discovered anything yet
		case discovered //discovery list is not empty, still searching
		case discoveredAll //discovery has finished with discovered calliopes
		case connecting //connecting to some calliope
		case connected //connected to some calliope
	}

	public var state : CalliopeDiscoveryState = .initialized {
		didSet {
			updateBlock()
		}
	}

	public var updateBlock: () -> () = {}

	public var discoveredCalliopes : [String : CalliopeBLEDevice] = [:]

	public var connectedCalliope: CalliopeBLEDevice?

	private let centralManager = CBCentralManager()

	override init() {
		super.init()
		centralManager.delegate = self
	}

	// MARK: discovery

	public func startCalliopeDiscovery() {
		disconnectOldCalliope()

		//start scan only if central manger already connected to bluetooth system service (=poweredOn)
		//alternatively, this is invoked after the state of the central mananger changed to poweredOn.
		if state != .discoveryStarted {
			state = .discoveryStarted
		}

		if centralManager.state == .poweredOn && !centralManager.isScanning {
			if !(self.state == .connected || state == .connecting) {
				state = .discovering
			}
			centralManager.scanForPeripherals(withServices: nil, options: nil)
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
		if self.discoveredCalliopes.isEmpty {
			//no discovered devices, so we are as fresh as a newborn discoverer
			disconnectOldCalliope()
			self.state = .initialized
		} else if !(self.state == .connected || state == .connecting) {
			self.state = .discoveredAll
		}
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
			if !(self.state == .connected || state == .connecting) {
				state = .discovered
			}
		}
	}

	// MARK: connection

	public func connectToCalliope(_ calliope: CalliopeBLEDevice) {
		//when we first connect, we stop searching further
		stopCalliopeDiscovery()
		//do not connect twice
		guard calliope != connectedCalliope else { return }
		disconnectOldCalliope()
		state = .connecting
		self.centralManager.connect(calliope.peripheral, options: nil)
		//manual timeout (system timeout is too long)
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 7) {
			if self.connectedCalliope == nil {
				self.centralManager.cancelPeripheralConnection(calliope.peripheral)
			}
		}
	}

	public func disconnectOldCalliope() {
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
		state = .connected
		calliope.state = .connected
	}

	public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		let previouslyConnected = connectedCalliope
		connectedCalliope = nil
		previouslyConnected?.state = .discovered
		state = .discoveredAll
	}

	public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		//TODO: remove calliope from discovered list depending on error
		state = .discoveredAll
	}

	// MARK: state of the bluetooth manager

	public func centralManagerDidUpdateState(_ central: CBCentralManager) {
		switch central.state {
		case .poweredOn:
			if self.state == .discoveryStarted {
				startCalliopeDiscovery()
			}
		case .unknown, .resetting, .unsupported, .unauthorized, .poweredOff:
			//bluetooth is in a state where we cannot do anything
			discoveredCalliopes = [:]
			state = .initialized
		}
	}
}
