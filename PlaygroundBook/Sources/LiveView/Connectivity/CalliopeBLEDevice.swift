//
//  CalliopeBLEDevice.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 08.12.18.
//

import UIKit
import CoreBluetooth

public class CalliopeBLEDevice: NSObject, CBPeripheralDelegate {

	//Bluetooth profile of the Calliope

	public enum CalliopeService: String {
		case debug = "FF44DDEE-251D-470A-A062-FA1922DFA9A8"
		case notify = "FF55DDEE-251D-470A-A062-FA1922DFA9A8"
		case program = "FF66DDEE-251D-470A-A062-FA1922DFA9A8"

		var uuid: CBUUID {
			return CBUUID(string: self.rawValue)
		}
	}

	public enum CalliopeCharacteristic: String {
		case debug = "FF44DDEE-251D-470A-A062-FA1922DFA9A8"
		case notify = "FF55DDEE-251D-470A-A062-FA1922DFA9A8"
		case program = "FF66DDEE-251D-470A-A062-FA1922DFA9A8"

		var uuid: CBUUID {
			return CBUUID(string: self.rawValue)
		}
	}

	//standard bluetooth profile of any device: Peripherials contain services which contain characteristics
	//(or included services, but let´s forget about them for now)
	public static let serviceCharacteristicMap : [CalliopeService : [CalliopeCharacteristic]] = [
		.debug : [.debug],
		.notify : [.notify],
		.program: [.program]
	]

	//the services required for the playground
	public static let requiredServices : Set = [CalliopeService.notify, CalliopeService.program]


	//Bluetooth profile with non-human-readable names (same as above, but all UUIDs)
	private static let serviceCharacteristicUUIDMap = Dictionary(uniqueKeysWithValues:
		CalliopeBLEDevice.serviceCharacteristicMap.map { ($0.uuid, $1.map { $0.uuid }) })
	private static let requiredServicesUUIDs = CalliopeBLEDevice.requiredServices.map { $0.uuid }


	public enum CalliopeBLEDeviceState {
		case discovered //discovered and ready to connect, not connected yet
		case connected //connected, but services and characteristics have not (yet) been found
		case evaluateMode //connected, looking for services and characteristics
		case playgroundReady //all required services and characteristics have been found, calliope ready to be programmed
		case notPlaygroundReady //required services and characteristics not available, put into right mode
	}

	public var state : CalliopeBLEDeviceState = .discovered { //TODO: make setter private
		didSet {
			LogNotify.log("\(self)")
			updateQueue.async { self.updateBlock() }
			if state == .discovered {
				//services get invalidated, undiscovered characteristics are thus restored (need to re-discover)
				servicesWithUndiscoveredCharacteristics = CalliopeBLEDevice.requiredServicesUUIDs
			} else if state == .connected {
				//immediately evaluate whether in playground mode
				evaluateMode()
			} else if state == .playgroundReady {
				//auto-start sensor readings
				do { try readSensors(true) }
				catch { LogNotify.log("\(self)\ncannot start sensor readings") } //TODO: handle errors, at least log them
			}
		}
	}

	public var updateQueue = DispatchQueue.main
	public var updateBlock: () -> () = {}

	public let peripheral : CBPeripheral
	public private(set) var servicesWithUndiscoveredCharacteristics = CalliopeBLEDevice.requiredServicesUUIDs

	init(peripheral: CBPeripheral) {
		self.peripheral = peripheral
		super.init()
		peripheral.delegate = self
	}

	// MARK: Services discovery

	/// evaluate whether calliope is in correct mode
	public func evaluateMode() {
		//immediately continue with service discovery
		state = .evaluateMode
		peripheral.discoverServices(Array(CalliopeBLEDevice.requiredServicesUUIDs))
	}

	public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		guard error == nil else {
			//TODO: log failure cause
			state = .notPlaygroundReady
			return
		}

		let services = peripheral.services ?? []
		let uuidSet = Set(services.map { return $0.uuid })

		//evaluate whether all required services were found. If not, Calliope is not ready for programs from the playground
		if uuidSet.isSuperset(of: CalliopeBLEDevice.requiredServicesUUIDs) {
			//discover the characteristics of all required services, just to be thorough
			services.forEach { service in
				if CalliopeBLEDevice.requiredServicesUUIDs.contains(service.uuid) {
					peripheral.discoverCharacteristics(CalliopeBLEDevice.serviceCharacteristicUUIDMap[service.uuid], for: service)
				}
			}
		} else {
			state = .notPlaygroundReady
		}
	}


	// MARK: Characteristics discovery

	public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		let requiredCharacteristicsUUIDs = Set(CalliopeBLEDevice.serviceCharacteristicUUIDMap[service.uuid] ?? [])

		let characteristics = service.characteristics ?? []
		let uuidSet = Set(characteristics.map { return $0.uuid })

		if uuidSet.isSuperset(of: requiredCharacteristicsUUIDs) {
			_ = servicesWithUndiscoveredCharacteristics.remove(object: service.uuid)
		} else {
			state = .notPlaygroundReady
		}

		if servicesWithUndiscoveredCharacteristics.isEmpty {
			state = .playgroundReady
		}
	}

	//MARK: reading and writing characteristics synchronously
	public var timeoutRead: DispatchTimeInterval = DispatchTimeInterval.milliseconds(2000)
	public var timeoutWrite: DispatchTimeInterval = DispatchTimeInterval.milliseconds(2000)

	//to synchronize reads and writes
	let writeSignal = DispatchGroup()
	var writeError : Error? = nil

	public func write(_ data: Data, for characteristic: CBCharacteristic) throws {

		writeSignal.enter()
		peripheral.writeValue(data, for: characteristic, type: .withResponse)

		//TODO: this timeout could lead to unexpected results, if we submit multiple programs to be transferred and one times out
		/*
		let timeout = DispatchTime.now() + timeoutWrite
		if writeSignal.wait(timeout: timeout) == .timedOut {
			ERR("write timed out")
			//TODO: maybe use own error type
			writeError = CBError(.connectionTimeout)
		}
		*/

		writeSignal.wait()

		guard writeError == nil else {
			let error = writeError!
			//prepare for next write
			writeError = nil
			throw error
		}
	}

	public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		//set potential error and move on
		writeError = error
		writeSignal.leave()
	}

	public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		guard error == nil else { return } //TODO: log the cause

		if characteristic.uuid == CalliopeCharacteristic.notify.uuid {
			if let value = characteristic.value {
				updateSensorReading(value)
			}
		} else {
			//TODO: some other characteristic has updated its value, but we do not know why...
		}
	}

	// MARK: Receiving sensor values via notify characteristic

	public private(set) var sensorReadings: [DashboardItemType: UInt8] = [:]

	public func readSensors(_ enabled: Bool) throws {
		guard state == .playgroundReady else { throw "Not ready to receive programs yet" }

		let notifyServiceUUID = CalliopeBLEDevice.CalliopeService.notify.uuid
		let notifyCharacteristicUUID = CalliopeBLEDevice.CalliopeCharacteristic.notify.uuid
		//never crashes because we made sure we are ready for the playground, i.e. we have all required services
		let service = peripheral.services!.filter { $0.uuid ==  notifyServiceUUID }.first!
		let notifyCharacteristic = service.characteristics!.filter { $0.uuid == notifyCharacteristicUUID }.first!

		peripheral.setNotifyValue(enabled, for: notifyCharacteristic)
	}

	private func updateSensorReading(_ value: Data) {

		if let type = DashboardItemType(rawValue:UInt16(value[1])) {
			let value:UInt8 = value[3]

			LogNotify.log("\(self) received value \(value) for \(type)")

			sensorReadings.updateValue(value, forKey: type)
			//TODO: do not use notification center, but let observers subscribe directly to sensorReadings´ value
			//TODO: subscription to swift dictionaries via didSet works.
			if(type == DashboardItemType.ButtonAB)
			{
				NotificationCenter.default.post(name:UIView_DashboardItem.Ping, object: nil, userInfo:["type":DashboardItemType.ButtonA, "value":value])
				NotificationCenter.default.post(name:UIView_DashboardItem.Ping, object: nil, userInfo:["type":DashboardItemType.ButtonB, "value":value])
			}
			else if type == DashboardItemType.Thermometer {
				let localizedValue = UInt8( ValueLocalizer.current.localizeTemperature(unlocalized: Double(value)) )
				NotificationCenter.default.post(name:UIView_DashboardItem.Ping, object: nil, userInfo:["type":type, "value":localizedValue])
			}
			else
			{
				NotificationCenter.default.post(name:UIView_DashboardItem.Ping, object: nil, userInfo:["type":type, "value":value])
			}
		}
	}


	// MARK: Uploading programs via program characteristic

	public func upload(program: ProgramBuildResult) throws {

		//code of the program
		let code : [UInt8] = program.code
		//methods of the program
		let methods : [UInt16] = program.methods

		guard state == .playgroundReady else { throw "Not ready to receive programs yet" }

		let programServiceUUID = CalliopeBLEDevice.CalliopeService.program.uuid
		let programCharacteristicUUID = CalliopeBLEDevice.CalliopeCharacteristic.program.uuid
		//never crashes because we made sure we are ready for the playground, i.e. we have all required services
		let service = peripheral.services!.filter { $0.uuid ==  programServiceUUID }.first!
		let programCharacteristic = service.characteristics!.filter { $0.uuid == programCharacteristicUUID }.first!

		// transfer code in parts

		//offset of current program part
		var address = 0

		//upload porogram in pieces of size 16 bytes
		try partition(data: Data(bytes: code), size: 16)
			.forEach { part in
				//transfer part of program and wait for response
				let len = part.count
				var packet = Data(bytes: [
					len.hi(), len.lo(),
					address.hi(), address.lo(),
					])
				packet.append(part)

				LOG(String(format: "packet address:%.4x len:%.4x", address, len))

				try write(packet, for: programCharacteristic)
				address += len
		}

		// transfer end packet
		//TODO: hash should probably be a hash of the program, but is always 0
		let hash_is = UInt16(0)
		var packet = Data(bytes: [
			0x00, 0x00, // len = 0
			hash_is.hi(), hash_is.lo(),
			])
		for method in methods {
			packet.append(method.hi())
			packet.append(method.lo())
		}
		try write(packet, for: programCharacteristic)
	}

	private func partition(data: Data, size: Int) -> [Data] {
		return stride(from: 0, to: data.count, by: size).map {
			data.subdata(in: $0 ..< Swift.min($0 + size, data.count))
		}
	}
}

extension CalliopeBLEDevice {
	public override var description: String {
		return "name: \(String(describing: peripheral.name)), state: \(state)"
	}
}
