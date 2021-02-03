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
		fatalError("The CalliopeBLEDevice Class is abstract! At least requiredServices variable must be overridden by subclass.")
	}

	enum CalliopeBLEDeviceState {
		case discovered //discovered and ready to connect, not connected yet
		case connected //connected, but services and characteristics have not (yet) been found
		case evaluateMode //connected, looking for services and characteristics
		case playgroundReady //all required services and characteristics have been found, calliope ready to be programmed
		case notPlaygroundReady //required services and characteristics not available, put into right mode
		case willReset //when a reset is done to enable or disable services
	}

	private(set) var state : CalliopeBLEDeviceState = .discovered {
		didSet {
			LogNotify.log("calliope state: \(state)")
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
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + BluetoothConstants.couplingDelay) {
				self.evaluateMode()
			}
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

	required init(peripheral: CBPeripheral, name: String) {
		self.peripheral = peripheral
		self.name = name
		super.init()
		peripheral.delegate = self
		_ = requiredServices
	}

	public func hasConnected() {
		if state == .discovered {
			state = .connected
		}
	}

	public func hasDisconnected() {
		if state != .discovered {
			state = .discovered
		}
	}

	// MARK: Services discovery

	/// evaluate whether calliope is in correct mode
	public func evaluateMode() {
		//immediately continue with service discovery
		state = .evaluateMode
		peripheral.discoverServices(requiredServicesUUIDs + [CalliopeService.master.uuid])
	}

	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		guard error == nil else {
			LogNotify.log(error!.localizedDescription)
			state = .notPlaygroundReady
			return
		}

		let services = peripheral.services ?? []
		let uuidSet = Set(services.map { return $0.uuid })

		//evaluate whether all required services were found. If not, Calliope is not ready for programs from the playground
		if uuidSet.isSuperset(of: requiredServicesUUIDs) {
			LogNotify.log("found all (\(requiredServicesUUIDs.count)) required services:\n\(requiredServices)")
			//discover the characteristics of all required services, just to be thorough
			services.filter { requiredServicesUUIDs.contains($0.uuid) }.forEach { service in
				peripheral.discoverCharacteristics(CalliopeBLEProfile.serviceCharacteristicUUIDMap[service.uuid], for: service)
			}
		} else if (uuidSet.contains(CalliopeService.master.uuid)) {
			//activate missing services
			LogNotify.log("attempt activation of required services through master service")
			guard let masterService = services.first(where: { $0.uuid == CalliopeService.master.uuid }) else {
				state = .notPlaygroundReady
				return
			}
			peripheral.discoverCharacteristics([CalliopeCharacteristic.services.uuid], for: masterService)
		} else {
			LogNotify.log("failed to find required services or a way to activate them")
			state = .notPlaygroundReady
		}
	}

	private func resetForRequiredServices() {
		do { try write((requiredServices.reduce(0, { $0 | $1 }) | 1 << 31).littleEndianData, for: .services) }
		catch {
			if state == .evaluateMode {
				state = .notPlaygroundReady
			}
			LogNotify.log("was not able to enable services \(requiredServices) through master service")
		}
	}


	// MARK: Characteristics discovery

	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

		if service.uuid == CalliopeService.master.uuid {
			//indicate that calliope & bluetooth connection is about to be reset programmatically
			self.state = .willReset
			updateQueue.async {
				//we searched the master service characteristics because we did not have all required characteristics
				LogNotify.log("resetting Calliope to enable required services")
				self.resetForRequiredServices()
				//in the future, just activate services on the fly
			}
		}

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
		guard state == .playgroundReady || characteristic == .services,
			let serviceUuid = CalliopeBLEProfile.characteristicServiceMap[characteristic]?.uuid
			else { return nil }
		let uuid = characteristic.uuid
		return getCBCharacteristic(serviceUuid, uuid)
	}

	func getCBCharacteristic(_ serviceUuid: CBUUID, _ uuid: CBUUID) -> CBCharacteristic? {
		return peripheral.services?.first { $0.uuid == serviceUuid }?
			.characteristics?.first { $0.uuid == uuid }
	}

	//MARK: reading and writing characteristics (asynchronously/ scheduled/ synchronously)

	//to sequentialize reads and writes

	let readWriteQueue = DispatchQueue.global(qos: .userInitiated)

	let readWriteSem = DispatchSemaphore(value: 1)

	var readWriteGroup: DispatchGroup? = nil

	var writeError : Error? = nil
	var writingCharacteristic : CBCharacteristic? = nil

	var readError : Error? = nil
	var readingCharacteristic : CBCharacteristic? = nil
	var readValue : Data? = nil

	func write (_ data: Data, for characteristic: CalliopeCharacteristic) throws {
		guard state == .playgroundReady || characteristic == .services
			else { throw "Not ready to write to characteristic \(characteristic)" }
		guard let cbCharacteristic = getCBCharacteristic(characteristic) else { throw "characteristic \(characteristic) not available" }

		try write(data, for: cbCharacteristic)
	}

	func write(_ data: Data, for characteristic: CBCharacteristic) throws {
		try applySemaphore(readWriteSem) {
			writingCharacteristic = characteristic

			waitForAsyncExecution(on: readWriteQueue) {
				//write value and wait for delegate call (or error)
				self.readWriteGroup = DispatchGroup()
				self.readWriteGroup!.enter()
				self.peripheral.writeValue(data, for: characteristic, type: .withResponse)

				if self.readWriteGroup!.wait(timeout: DispatchTime.now() + BluetoothConstants.writeTimeout) == .timedOut {
					LogNotify.log("write to \(characteristic) timed out")
					self.writeError = CBError(.connectionTimeout)
				}
			}

			guard writeError == nil else {
				LogNotify.log("write resulted in error: \(writeError!)")
				let error = writeError!
				//prepare for next write
				writeError = nil
				throw error
			}
            
			LogNotify.log("wrote \(characteristic)")
		}
	}

	func read(characteristic: CalliopeCharacteristic) throws -> Data? {
		guard state == .playgroundReady
			else { throw "Not ready to read characteristic \(characteristic)" }
		guard let cbCharacteristic = getCBCharacteristic(characteristic)
			else { throw "no service that contains characteristic \(characteristic)" }
		return try read(characteristic: cbCharacteristic)
	}

	func read(characteristic: CBCharacteristic) throws -> Data? {
		return try applySemaphore(readWriteSem) {
			readingCharacteristic = characteristic

			waitForAsyncExecution(on: readWriteQueue) {
				//read value and wait for delegate call (or error)
				self.readWriteGroup = DispatchGroup();
				self.readWriteGroup!.enter()
				self.peripheral.readValue(for: characteristic)
                
				if self.readWriteGroup!.wait(timeout: DispatchTime.now() + BluetoothConstants.readTimeout) == .timedOut {
					LogNotify.log("read from \(characteristic) timed out")
					self.readError = CBError(.connectionTimeout)
				}
			}

			guard readError == nil else {
				LogNotify.log("read resulted in error: \(readError!)")
				let error = readError!
				//prepare for next read
				readError = nil
				throw error
			}

			let data = readValue
			LogNotify.log("read \(String(describing: data)) from \(characteristic)")
			readValue = nil
			return data
		}
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

	func handleValueUpdate(_ characteristic: CalliopeCharacteristic, _ value: Data) {
		LogNotify.log("value for \(characteristic) updated (\(value.hexEncodedString()))")
	}

	private func explicitWriteResponse(_ error: Error?) {
		writingCharacteristic = nil
		//set potential error and move on
		writeError = error
		if let error = error {
			LogNotify.log("received error from writing: \(error)")
		} else {
			LogNotify.log("received write success message")
		}
		readWriteGroup?.leave()
	}

	private func explicitReadResponse(for characteristic: CBCharacteristic, error: Error?) {
		readingCharacteristic = nil
		//answer to explicit read request
		if let error = error {
			LogNotify.log("received error from reading \(characteristic): \(error)")
			readError = error
			LogNotify.log(error.localizedDescription)
		} else {
			readValue = characteristic.value
			LogNotify.log("received read response from \(characteristic): \(String(describing: readValue?.hexEncodedString()))")
		}
		readWriteGroup?.leave()
	}
}


//MARK: notifications for ui updates

extension CalliopeBLEDevice {
	func postButtonANotification(_ value: Int) {
		postSensorUpdateNotification(DashboardItemType.ButtonA, value)
	}

	func postButtonBNotification(_ value: Int) {
		postSensorUpdateNotification(DashboardItemType.ButtonB, value)
	}

	func postThermometerNotification(_ value: Int) {
		postSensorUpdateNotification(DashboardItemType.Thermometer, value)
	}

	func postSensorUpdateNotification(_ type: DashboardItemType, _ value: Int) {
		NotificationCenter.default.post(name:UIView_DashboardItem.ValueUpdateNotification, object: nil, userInfo:["type": type.rawValue, "value": value])
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
