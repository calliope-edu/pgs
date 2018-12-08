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
		case discovered //discovery list is not empty, may be still discovering
	}

	public var state : CalliopeDiscoveryState = .initialized {
		didSet {
			switch (oldValue, state) {
			case (_, .initialized):
				//TODO: notify the listener that our discoveries are gone (might be due to bluetooth off)
				return
			case (_, .discoveryStarted):
				//TODO: notify the listener that we are waiting for bluetooth to be on
				return
			case (_, .discovering):
				//TODO: notify listener that discovery is actually starting now (bluetooth is on)
				return
			case (_, .discovered):
				//TODO: notify listener that some discovery has been made or some device vanished
				return
			default:
				return
			}
		}
	}

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
		if centralManager.state == .poweredOn && !centralManager.isScanning {
			state = .discoveryStarted
			centralManager.scanForPeripherals(withServices: nil, options: nil)
			//stop the search after some time. The user can invoke it again later.
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20.0) {
				self.centralManager.stopScan()
				//no discovered devices, so we are as fresh as a newborn discoverer
				if self.state != .discovered {
					self.state = .initialized
				}
			}
		}
		//remember that the user started scan
		state = .discoveryStarted
	}

	public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		//TODO: This currently only considers calliopes, so it is not compatible to the microbit
		if let name = peripheral.name?.lowercased(), name.contains("calliope") {
			//we found a calliope device (or one that pretends to be a calliope at least)
			discoveredCalliopes.updateValue(CalliopeBLEDevice(peripheral: peripheral), forKey: name)
		}
		//TODO: how do we recognize that some devices have vanished from our view?
	}

	// MARK: connection

	public func connectToCalliope(_ calliope: CalliopeBLEDevice) {
		self.centralManager.connect(calliope.peripheral, options: nil)
	}

	public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		changeCalliopeState(of: peripheral, to: .connected)
	}

	public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		changeCalliopeState(of: peripheral, to: .discovered)
	}

	public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		changeCalliopeState(of: peripheral, to: .discovered)
	}

	public func changeCalliopeState(of peripheral: CBPeripheral, to state: CalliopeBLEDevice.CalliopeBLEDeviceState) {
		//the guards cannot happen if we connect only to discovered named calliopes
		guard let name = peripheral.name, let calliope = discoveredCalliopes[name] else {
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
