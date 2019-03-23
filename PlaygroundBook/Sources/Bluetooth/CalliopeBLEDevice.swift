//
//  CalliopeBLEDevice.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 08.12.18.
//

import UIKit
import CoreBluetooth

class CalliopeBLEDevice: NSObject, CBPeripheralDelegate {

	//the services required for the playground
	var requiredServices : Set<CalliopeService> {
		return []
	}

	enum CalliopeBLEDeviceState {
		case discovered //discovered and ready to connect, not connected yet
		case connected //connected, but services and characteristics have not (yet) been found
		case evaluateMode //connected, looking for services and characteristics
		case playgroundReady //all required services and characteristics have been found, calliope ready to be programmed
		case notPlaygroundReady //required services and characteristics not available, put into right mode
	}

	var state : CalliopeBLEDeviceState = .discovered { //TODO: make setter private
		didSet {
			LogNotify.log("\(self)")
			handleStateUpdate()
		}
	}

	func handleStateUpdate() {
		updateQueue.async { self.updateBlock() }
		if state == .discovered {
			//services get invalidated, undiscovered characteristics are thus restored (need to re-discover)
			servicesWithUndiscoveredCharacteristics = requiredServicesUUIDs
		} else if state == .connected {
			//immediately evaluate whether in playground mode
			evaluateMode()
		}
	}

	var updateQueue = DispatchQueue.main
	var updateBlock: () -> () = {}

	let peripheral : CBPeripheral
	let name : String

	lazy var servicesWithUndiscoveredCharacteristics: [CBUUID] = {
		return requiredServicesUUIDs
	}()

	lazy var requiredServicesUUIDs: [CBUUID] = requiredServices.map { $0.uuid }

	var hasMasterService = false {
		didSet {
			requiredServicesUUIDs = requiredServices.map { $0.uuid }
			servicesWithUndiscoveredCharacteristics = requiredServicesUUIDs
		}
	}

	init(peripheral: CBPeripheral, name: String) {
		self.peripheral = peripheral
		self.name = name
		super.init()
		peripheral.delegate = self
	}

	// MARK: Services discovery

	/// evaluate whether calliope is in correct mode
	private func evaluateMode() {
		//immediately continue with service discovery
		state = .evaluateMode
		peripheral.discoverServices(Array(requiredServicesUUIDs))
	}

	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		guard error == nil else {
			//TODO: log failure cause
			state = .notPlaygroundReady
			return
		}

		let services = peripheral.services ?? []
		let uuidSet = Set(services.map { return $0.uuid })

		if (uuidSet.contains(CalliopeService.master.uuid)) {
			hasMasterService = true
		}

		//evaluate whether all required services were found. If not, Calliope is not ready for programs from the playground
		if uuidSet.isSuperset(of: requiredServicesUUIDs) {
			//discover the characteristics of all required services, just to be thorough
			services.forEach { service in
				if requiredServicesUUIDs.contains(service.uuid) {
					peripheral.discoverCharacteristics(CalliopeBLEProfile.serviceCharacteristicUUIDMap[service.uuid], for: service)
				}
			}
		} else if (hasMasterService) {
			//TODO: activate missing services, retry connect and evaluation
			//in the future, just activate services on the fly
		} else {
			state = .notPlaygroundReady
		}
	}


	// MARK: Characteristics discovery

	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		let requiredCharacteristicsUUIDs = Set(CalliopeBLEProfile.serviceCharacteristicUUIDMap[service.uuid] ?? [])

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

	func getCBCharacteristic(_ characteristic: CalliopeCharacteristic) -> CBCharacteristic? {
		guard state == .playgroundReady,
			let serviceUuid = CalliopeBLEProfile.characteristicServiceMap[characteristic]?.uuid
			else { return nil }
		let uuid = characteristic.uuid
		return getCBCharacteristic(serviceUuid, uuid)
	}

	func getCBCharacteristic(_ serviceUuid: CBUUID, _ uuid: CBUUID) -> CBCharacteristic? {
		return peripheral.services?.filter { $0.uuid == serviceUuid }.first?
			.characteristics?.filter { $0.uuid == uuid }.first
	}

	//MARK: reading and writing characteristics (asynchronously/ scheduled/ synchronously)

	var timeoutRead: DispatchTimeInterval = DispatchTimeInterval.milliseconds(2000)
	var timeoutWrite: DispatchTimeInterval = DispatchTimeInterval.milliseconds(2000)

	//to sequentialize reads and writes

	let readWriteQueue = DispatchQueue.global(qos: .userInitiated)

	let readWriteSem = DispatchSemaphore(value: 1)

	let writeGroup = DispatchGroup()
	var writeError : Error? = nil
	var writingCharacteristic : CBCharacteristic? = nil

	let readGroup = DispatchGroup()
	var readError : Error? = nil
	var readingCharacteristic : CBCharacteristic? = nil
	var readValue : Data? = nil

	///listeners for periodic data updates (max. one for each)
	var updateListeners: [CalliopeCharacteristic: Any] = [:]

	func write (_ data: Data, for characteristic: CalliopeCharacteristic) throws {
		guard state == .playgroundReady
			else { throw "Not ready to write to characteristic \(characteristic)" }
		guard let cbCharacteristic = getCBCharacteristic(characteristic) else { throw "characteristic \(characteristic) not available" }

		try write(data, for: cbCharacteristic)
	}

	func write(_ data: Data, for characteristic: CBCharacteristic) throws {
		readWriteSem.wait()
		writingCharacteristic = characteristic

		asyncAndWait(on: readWriteQueue) {
			//write value and wait for delegate call (or error)
			self.writeGroup.enter()
			self.peripheral.writeValue(data, for: characteristic, type: .withResponse)

			if self.writeGroup.wait(timeout: DispatchTime.now() + 10) == .timedOut {
				LogNotify.log("write to \(characteristic) timed out")
				self.writeError = CBError(.connectionTimeout)
			}
		}

		guard writeError == nil else {
			let error = writeError!
			//prepare for next write
			writeError = nil
			readWriteSem.signal()
			throw error
		}
		readWriteSem.signal()
	}

	func read(characteristic: CalliopeCharacteristic) throws -> Data? {
		guard state == .playgroundReady
			else { throw "Not ready to read characteristic \(characteristic)" }
		guard let cbCharacteristic = getCBCharacteristic(characteristic)
			else { throw "no service that contains characteristic \(characteristic)" }
		return try read(characteristic: cbCharacteristic)
	}

	func read(characteristic: CBCharacteristic) throws -> Data? {
		readWriteSem.wait()
		readingCharacteristic = characteristic

		asyncAndWait(on: readWriteQueue) {
			//read value and wait for delegate call (or error)
			self.readGroup.enter()
			self.peripheral.readValue(for: characteristic)
			if self.readGroup.wait(timeout: DispatchTime.now() + 10) == .timedOut {
				LogNotify.log("read from \(characteristic) timed out")
				self.readError = CBError(.connectionTimeout)
			}
		}

		guard readError == nil else {
			let error = readError!
			//prepare for next read
			readError = nil
			readWriteSem.signal()
			throw error
		}

		let data = readValue
		readValue = nil
		readWriteSem.signal()
		return data
	}

	func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		if let writingCharac = writingCharacteristic, characteristic.uuid == writingCharac.uuid {
			explicitWriteResponse(error)
			return
		} else {
			LogNotify.log("didWrite called for characteristic that we did not write to!")
		}
	}

	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

		if let readingCharac = readingCharacteristic, characteristic.uuid == readingCharac.uuid {
			explicitReadResponse(for: characteristic, error: error)
			return
		}

		guard error == nil, let value = characteristic.value else {
			LogNotify.log(readError?.localizedDescription ??
				"characteristic \(characteristic.uuid) does not have a value")
			return
		}

		guard let calliopeCharacteristic = CalliopeBLEProfile.uuidCharacteristicMap[characteristic.uuid]
			else {
				LogNotify.log("received value from unknown characteristic: \(characteristic.uuid)")
				return
		}

		handleValueUpdate(calliopeCharacteristic, value)
	}

	func handleValueUpdate(_ characteristic: CalliopeCharacteristic, _ value: Data) {}

	private func explicitWriteResponse(_ error: Error?) {
		writingCharacteristic = nil
		//set potential error and move on
		writeError = error
		if let error = error {
			LogNotify.log(error.localizedDescription)
		}
		writeGroup.leave()
	}

	private func explicitReadResponse(for characteristic: CBCharacteristic, error: Error?) {
		readingCharacteristic = nil
		//answer to explicit read request
		if let error = error {
			readError = error
			LogNotify.log(error.localizedDescription)
		} else {
			readValue = characteristic.value
		}
		readGroup.leave()
	}
}


//MARK: notifications for ui updates

extension CalliopeBLEDevice {
	func postButtonANotification(_ value: Int8) {
		postSensorUpdateNotification(DashboardItemType.ButtonA, value)
	}

	func postButtonBNotification(_ value: Int8) {
		postSensorUpdateNotification(DashboardItemType.ButtonB, value)
	}

	func postThermometerNotification(_ value: Int8) {
		postSensorUpdateNotification(DashboardItemType.Thermometer, value)
	}

	func postSensorUpdateNotification(_ type: DashboardItemType, _ value: Int8) {
		NotificationCenter.default.post(name:UIView_DashboardItem.Ping, object: nil, userInfo:["type":type.rawValue, "value":value])
	}
}

//MARK: Equatable (conformance inherited default implementation by NSObject)

extension CalliopeBLEDevice {
	/*static func == (lhs: CalliopeBLEDevice, rhs: CalliopeBLEDevice) -> Bool {
		return lhs.peripheral == rhs.peripheral
	}*/

	override func isEqual(_ object: Any?) -> Bool {
		return self.peripheral == (object as? CalliopeBLEDevice)?.peripheral
	}
}

//MARK: CustomStringConvertible (conformance inherited default implementation by NSObject)

extension CalliopeBLEDevice {
	override var description: String {
		return "name: \(String(describing: name)), state: \(state)"
	}
}
