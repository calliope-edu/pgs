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
		case playgroundReady //all required services and characteristics have been found, calliope ready to be programmed
	}

	public var state : CalliopeBLEDeviceState = .discovered {
		didSet {
			switch (oldValue, state) {
			case (.discovered, .connected):
				//TODO: notify listeners that calliope will now evaluate whether it is playground ready
				// we do not know if the calliope is in the correct mode until we have discovered the appropriate services
				peripheral.discoverServices(Array(CalliopeBLEDevice.requiredServicesUUIDs))
			case (.connected, .playgroundReady):
				//TODO: notify listeners that calliope is now ready to be programmed
				return
			case (.connected, .connected):
				//TODO: notify listeners that calliope is not in correct mode, required services were not discovered
				return
			case (_, .discovered):
				//TODO: notify listeners that device returned to or remained in discovered state
				servicesWithUndiscoveredCharacteristics = CalliopeBLEDevice.requiredServicesUUIDs
				return
			default:
				//TODO: log warning about illegal state transition
				return
			}
		}
	}

	public let peripheral : CBPeripheral
	public var servicesWithUndiscoveredCharacteristics = CalliopeBLEDevice.requiredServicesUUIDs

	init(peripheral: CBPeripheral) {
		self.peripheral = peripheral
		super.init()
		peripheral.delegate = self
	}

	// MARK: Services discovery

	public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		guard error == nil else {
			//TODO: log failure cause
			state = .connected
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
			state = .connected
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
			state = .connected
		}

		if servicesWithUndiscoveredCharacteristics.isEmpty {
			state = .playgroundReady
		}
	}


	// MARK: Uploading programs

	private func partition(data: Data, size: Int, _ block: @escaping (Data) throws -> Void) throws {
		try data.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
			let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
			let totalSize = data.count
			var chunkOffset = 0
			while chunkOffset < totalSize {
				let chunkSize = chunkOffset + size > totalSize ? totalSize - chunkOffset : size
				let chunkData = Data(bytesNoCopy: mutRawPointer + chunkOffset, count: chunkSize, deallocator: Data.Deallocator.none)
				try block(chunkData)
				chunkOffset += chunkSize
			}
		}
	}


	/* TODO: adapt this function to new code
	public func upload(program: ProgramBuildResult) throws {
	let code = program.code
	let methods = program.methods

	guard state == .playgroundReady else { throw "Not ready to receive programs yet" }

	let mtu = 16

	let programServiceUUID = CalliopeBLEDevice.CalliopeService.program.uuid
	let programCharacteristicUUID = CalliopeBLEDevice.CalliopeCharacteristic.program.uuid
	//never crashes because we made sure we are ready for the playground, i.e. we have all required services
	let service = peripheral.services?.filter { $0.uuid ==  programServiceUUID }.first!
	let characteristic = service?.characteristics?.filter { $0.uuid == programCharacteristicUUID }.first!

	//        let service_debug = peripheral.find(service: Calliope.uuid_service_debug)
	//        let characteristic_debug = service_debug.find(characteristic: Calliope.uuid_characteristic_debug)

	//		let status = try characteristic.read()

	//		if debug {
	//			LOG("status before \(status.hexEncodedString())")
	//		}

	// TODO: check version and size

	// transfer code in parts
	var address: Int = 0
	try partition(data: Data(bytes: code), size: mtu) { part in
	let len = part.count
	var packet = Data(bytes: [
	len.hi(), len.lo(),
	address.hi(), address.lo(),
	])
	packet.append(part)

	LOG(String(format: "packet address:%.4x len:%.4x", address, len))

	try characteristic_link.write(data: packet)
	address += len
	}

	//		if debug {
	//			LOG("status stage1 \(try characteristic_link.read().hexEncodedString())")
	//		}

	// transfer end packet
	let hash_is = hash(bytes: code)
	var packet = Data(bytes: [
	0x00, 0x00, // len = 0
	hash_is.hi(), hash_is.lo(),
	])
	for method in methods {
	packet.append(method.hi())
	packet.append(method.lo())
	}
	try characteristic_link.write(data: packet)

	//		if debug {
	//			LOG("status stage2 \(try characteristic_link.read().hexEncodedString())")
	//			//try dump(characteristic_debug)
	//		}
	}*/
}
