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
	}

	public var state : CalliopeDiscoveryState = .initialized {
		didSet {
			updateBlock()
		}
	}

	public var updateBlock: () -> () = {}

	public var discoveredCalliopes : [String : CalliopeBLEDevice] = [:]

	private let centralManager = CBCentralManager()

	override init() {
		super.init()
		centralManager.delegate = self
	}

	// MARK: discovery

	public func startCalliopeDiscovery() {
		//start scan only if central manger already connected to bluetooth system service (=poweredOn)
		//alternatively, this is invoked after the state of the central mananger changed to poweredOn.
		if state != .discoveryStarted {
			state = .discoveryStarted
		}

		if centralManager.state == .poweredOn && !centralManager.isScanning {
			state = .discovering
			centralManager.scanForPeripherals(withServices: nil, options: nil)
			//stop the search after some time. The user can invoke it again later.
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20.0) {
				self.stopCalliopeDiscovery()
			}
		}
	}

	public func stopCalliopeDiscovery() {
		self.centralManager.stopScan()
		if self.state == .discovered {
			self.state = .discoveredAll
		} else if self.state == .discovering {
			//no discovered devices, so we are as fresh as a newborn discoverer
			self.state = .initialized
		}
	}

	public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		//TODO: This currently only considers calliopes, so it is not compatible to the microbit
		if let name = peripheral.name?.lowercased(), name.contains("calliope") {
			//we found a calliope device (or one that pretends to be a calliope at least)
			discoveredCalliopes.updateValue(CalliopeBLEDevice(peripheral: peripheral),
											forKey: Matrix.full2Friendly(fullName: name) ?? "")
			state = .discovered
		}
		//TODO: how do we recognize that some devices have vanished from our view?
	}

	// MARK: connection

	public func connectToCalliope(_ calliope: CalliopeBLEDevice) {
		//do not connect twice
		guard calliope.state == .discovered else { return }
		calliope.state = .connecting
		self.centralManager.connect(calliope.peripheral, options: nil)
	}

	public func disconnectCalliope(_ calliope: CalliopeBLEDevice) {
		self.centralManager.cancelPeripheralConnection(calliope.peripheral)
		calliope.state = .discovered
	}

	public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		changeCalliopeState(of: peripheral, to: .connected)
	}

	public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		//TODO: remove calliope from list of discoveries / check if it is still available
		changeCalliopeState(of: peripheral, to: .discovered)
	}

	public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		//TODO: remove calliope from discovered list depending on error
		changeCalliopeState(of: peripheral, to: .discovered)
	}

	public func changeCalliopeState(of peripheral: CBPeripheral, to state: CalliopeBLEDevice.CalliopeBLEDeviceState) {
		//the guards cannot happen if we connect only to discovered named calliopes
		guard let name = peripheral.name,
			let parsed = Matrix.full2Friendly(fullName: name),
			let calliope = discoveredCalliopes[parsed] else {
			//TODO: log that we encountered unexpected behavior
			return
		}
		calliope.state = state
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
