//
//  CalliopeBLEDevice.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 08.12.18.
//

import UIKit
import CoreBluetooth

public class CalliopeBLEDevice: NSObject, CBPeripheralDelegate {

	//the services required for the playground
//	public static let requiredServices : Set = [CalliopeService.accelerometer, CalliopeService.button, CalliopeService.led, CalliopeService.temperature, CalliopeService.ioPin]
	public static let requiredServices : Set =  [CalliopeService.notify, CalliopeService.program]

	//Bluetooth profile of the Calliope

	public enum CalliopeService: String {
		case debug = "FF44DDEE-251D-470A-A062-FA1922DFA9A8"
		case notify = "FF55DDEE-251D-470A-A062-FA1922DFA9A8"
		case program = "FF66DDEE-251D-470A-A062-FA1922DFA9A8"

		case accelerometer = "E95D0753251D470AA062FA1922DFA9A8"

		/// measures a magnetic field such as the earth's magnetic field in 3 axes.
		case magnetometer = "E95DF2D8251D470AA062FA1922DFA9A8"

		/// the two Micro Bit buttons, allows 'commands' associated with button state changes to be associated with button states and notified to a connected client.
		case button = "E95D9882251D470AA062FA1922DFA9A8"

		/// Provides read/write access to I/O pins, individually or collectively. Allows configuration of each pin for input/output and analogue/digital use.
		case ioPin = "E95D127B251D470AA062FA1922DFA9A8"

		/// Provides access to and control of LED state. Allows the state (ON or OFF) of all 25 LEDs to be set in a single write operation. Allows short text strings to be sent by a client for display on the LED matrix and scrolled across at a speed controlled by the Scrolling Delay characteristic.
		case led = "E95DD91D251D470AA062FA1922DFA9A8"

		/// A generic, bi-directional event communication service.
		/// The Event Service allows events or commands to be notified to the micro:bit by a connected client and it allows micro:bit to notify the connected client
		/// of events or commands originating from with the micro:bit. The micro:bit can inform the client of the types of event it is interested in being informed
		/// about (e.g. an incoming call) and the client can inform the micro:bit of types of event it wants to be notified about.
		/// The term “event” will be used here for both event and command types of data.
		/// Events may have an associated value.
		/// Note that specific event ID values including any special values such as those which may represent wild cards are not defined here.
		/// The micro:bit run time documentation should be consulted for this information.
		/// Multiple events of different types may be notified to the client or micro:bit at the same time.
		/// Event data is encoded as an array of structs each encoding an event of a given type together with an associated value.
		/// Event Type and Event Value are both defined as uint16 and therefore the length of this array will always be a multiple of 4.
		/// struct event {
		///    uint16 event_type;
		///    uint16 event_value;
		/// };
		case event = "E95D93AF251D470AA062FA1922DFA9A8"

		/// Ambient temperature derived from several internal temperature sensors on the micro:bit
		case temperature = "E95D6100251D470AA062FA1922DFA9A8"

		/// This is an implementation of Nordic Semicondutor's UART/Serial Port Emulation over Bluetooth low energy.
		/// See https://developer.nordicsemi.com/nRF5_SDK/nRF51_SDK_v8.x.x/doc/8.0.0/s110/html/a00072.html for the original Nordic Semiconductor documentation by way of background.
		case uart = "6E400001B5A3F393E0A9E50E24DCCA9E"

		var uuid: CBUUID {
			if self.rawValue.count == 32 {
				return CBUUID(hexString: self.rawValue)
			} else {
				return CBUUID(string: self.rawValue)
			}
		}
	}

	public enum CalliopeCharacteristic: String, CaseIterable {
		case debug = "FF44DDEE-251D-470A-A062-FA1922DFA9A8"
		case notify = "FF55DDEE-251D-470A-A062-FA1922DFA9A8"
		case program = "FF66DDEE-251D-470A-A062-FA1922DFA9A8"

		/// X, Y and Z axes as 3 signed 16 bit values in that order and in little endian format. X, Y and Z values should be divided by 1000.
		case accelerometerData = "E95DCA4B251D470AA062FA1922DFA9A8"
		/// frequency with which accelerometer data is reported in milliseconds. Valid values are 1, 2, 5, 10, 20, 80, 160 and 640.
		case accelerometerPeriod = "E95DFB24251D470AA062FA1922DFA9A8"

		/// X, Y and Z axes as 3 signed 16 bit values in that order and in little endian format.
		case magnetometerData = "E95DFB11251D470AA062FA1922DFA9A8"
		//frequency with which magnetometer data is reported in milliseconds. Valid values are 1, 2, 5, 10, 20, 80, 160 and 640.
		case magnetometerPeriod = "E95D386C251D470AA062FA1922DFA9A8"
		/// Compass bearing in degrees from North.
		case magnetometerBearing = "E95D9715251D470AA062FA1922DFA9A8"

		/// State of Button A may be read on demand by a connected client or the client may subscribe to notifications of state change. 3 button states are defined and represented by a simple numeric enumeration:  0 = not pressed, 1 = pressed, 2 = long press.
		case buttonAState = "E95DDA90251D470AA062FA1922DFA9A8"
		/// State of Button B may be read on demand by a connected client or the client may subscribe to notifications of state change. 3 button states are defined and represented by a simple numeric enumeration:  0 = not pressed, 1 = pressed, 2 = long press.
		case buttonBState = "E95DDA91251D470AA062FA1922DFA9A8"

		/// Contains data relating to zero or more pins. Structured as a variable length array of up to 19 Pin Number / Value pairs.
		/// Pin Number and Value are each uint8 fields.
		/// Note however that the micro:bit has a 10 bit ADC and so values are compressed to 8 bits with a loss of resolution.
		/// OPERATIONS:
		/// WRITE: Clients may write values to one or more pins in a single GATT write operation.
		/// A pin to which a value is to be written must have been configured for output using the Pin IO Configuration characteristic.
		/// Any attempt to write to a pin which is configured for input will be ignored.
		/// NOTIFY: Notifications will deliver Pin Number / Value pairs for those pins defined as input pins by the Pin IO Configuration characteristic
		/// and whose value when read differs from the last read of the pin.
		/// READ: A client reading this characteristic will receive Pin Number / Value pairs for all those pins defined as input pins by the Pin IO Configuration characteristic.*/
		case pinData = "E95D8D00251D470AA062FA1922DFA9A8"
		/// A bit mask which allows each pin to be configured for analogue or digital use. Bit n corresponds to pin n where 0 LESS THAN OR EQUAL TO n LESS THAN 19. A value of 0 means digital and 1 means analogue.
		case pinADConfiguration = "E95D5899251D470AA062FA1922DFA9A8"
		/// A bit mask (32 bit) which defines which inputs will be read. If the Pin AD Configuration bit mask is also set the pin will be read as an analogue input, if not it will be read as a digital input.
		/// Note that in practice, setting a pin's mask bit means that it will be read by the micro:bit runtime and, if notifications have been enabled on the Pin Data characteristic, data read will be transmitted to the connected Bluetooth peer device in a Pin Data notification. If the pin's bit is clear, it  simply means that it will not be read by the micro:bit runtime.
		/// Bit n corresponds to pin n where 0 LESS THAN OR EQUAL TO n LESS THAN 19. A value of 0 means configured for output and 1 means configured for input.
		case pinIOConfiguration = "E95DB9FE251D470AA062FA1922DFA9A8"
		/// A variable length array 1 to 2 instances of :
		/// struct PwmControlData
		/// {
		/// uint8_t     pin;
		/// uint16_t    value;
		/// uint32_t    period;
		/// }
		/// Period is in microseconds and is an unsigned int but transmitted.
		/// Value is in the range 0 – 1024, per the current DAL API (e.g. setAnalogValue). 0 means OFF.
		/// Fields are transmitted over the air in Little Endian format.
		case pwmControl = "E95DD822251D470AA062FA1922DFA9A8"

		/// Allows the state of any|all LEDs in the 5x5 grid to be set to on or off with a single GATT operation.
		/// Consists of an array of 5 x utf8 octets, each representing one row of 5 LEDs.
		/// Octet 0 represents the first row of LEDs i.e. the top row when the micro:bit is viewed with the edge connector at the bottom and USB connector at the top.
		/// Octet 1 represents the second row and so on.
		/// In each octet, bit 4 corresponds to the first LED in the row, bit 3 the second and so on.
		/// Bit values represent the state of the related LED: off (0) or on (1).
		/// So we have:
		/// Octet 0, LED Row 1: bit4 bit3 bit2 bit1 bit0
		/// Octet 1, LED Row 2: bit4 bit3 bit2 bit1 bit0
		/// Octet 2, LED Row 3: bit4 bit3 bit2 bit1 bit0
		/// Octet 3, LED Row 4: bit4 bit3 bit2 bit1 bit0
		/// Octet 4, LED Row 5: bit4 bit3 bit2 bit1 bit0
		case ledMatrixState = "E95D7B77251D470AA062FA1922DFA9A8"
		/// A short UTF-8 string to be shown on the LED display. Maximum length 20 octets.
		case ledText = "E95D93EE251D470AA062FA1922DFA9A8"
		/// Specifies a millisecond delay to wait for in between showing each character on the display.
		case scrollingDelay = "E95D0D2D251D470AA062FA1922DFA9A8"

		/// A variable length list of event data structures which indicates the types of client event, potentially with a specific value which the micro:bit wishes to be informed of when they occur. The client should read this characteristic when it first connects to the micro:bit. It may also subscribe to notifications to that it can be informed if the value of this characteristic is changed by the micro:bit firmware.
		/// struct event {
		/// 	uint16 event_type;
		/// 	uint16 event_value;
		/// };
		/// Note that an event_type of zero means ANY event type and an event_value part set to zero means ANY event value.
		/// event_type and event_value are each encoded in little endian format.
		case microBitRequirements = "E95DB84C251D470AA062FA1922DFA9A8"
		/// Contains one or more event structures which should be notified to the client. It supports notifications and as such the client should subscribe to notifications from this characteristic.
		/// struct event {
		/// 	uint16 event_type;
		/// 	uint16 event_value;
		/// };
		case microBitEvent = "E95D9775251D470AA062FA1922DFA9A8"
		/// a variable length list of event data structures which indicates the types of micro:bit event, potentially with a specific value which the client wishes to be informed of when they occur. The client should write to this characteristic when it first connects to the micro:bit.
		/// struct event {
		/// 	uint16 event_type;
		/// 	uint16 event_value;
		/// };
		/// Note that an event_type of zero means ANY event type and an event_value part set to zero means ANY event value.
		/// event_type and event_value are each encoded in little endian format.
		case clientRequirements = "E95D23C4251D470AA062FA1922DFA9A8"
		/// a writable characteristic which the client may write one or more event structures to, to inform the micro:bit of events which have occurred on the client.
		/// These should be of types indicated in the micro:bit Requirements characteristic bit mask.
		/// struct event {
		/// 	uint16 event_type;
		/// 	uint16 event_value;
		/// };
		case clientEvent = "E95D5404251D470AA062FA1922DFA9A8"

		/// Signed integer 8 bit value in degrees celsius.
		case temperature = "E95D9250251D470AA062FA1922DFA9A8"

		/// Determines the frequency with which temperature data is updated in milliseconds.
		case temperaturePeriod = "E95D1B25251D470AA062FA1922DFA9A8"

		/// allows the micro:bit to transmit a byte array containing an arbitrary number of arbitrary octet values to a connected device.
		/// The maximum number of bytes which may be transmitted in one PDU is limited to the MTU minus three or 20 octets to be precise.
		case txCharacteristic = "6E400002B5A3F393E0A9E50E24DCCA9E"
		/// This characteristic allows a connected client to send a byte array containing an arbitrary number of arbitrary octet values to a connected micro:bit.
		/// The maximum number of bytes which may be transmitted in one PDU is limited to the MTU minus three or 20 octets to be precise.
		case rxCharacteristic = "6E400003B5A3F393E0A9E50E24DCCA9E"

		fileprivate var uuid: CBUUID {
			if self.rawValue.count == 32 {
				return CBUUID(hexString: self.rawValue)
			} else {
				return CBUUID(string: self.rawValue)
			}
		}

		fileprivate func interpret<T>(dataBytes: Data?) -> T? {
			guard let dataBytes = dataBytes else { return nil }

			switch self {
			case .pinData:
				var values = [UInt8:UInt8]()
				let sequence = stride(from: 0, to: dataBytes.count, by: 2)
				for element in sequence {
					values[dataBytes[element]] = dataBytes[element + 1]
				}
				return values as? T
			case .pinADConfiguration, .pinIOConfiguration:
				let config = Array(dataBytes.flatMap { (byte) -> [Bool] in
					(0..<8).map { offset in (byte & (1 << offset)) == 0 ? false : true }
					}.prefix(19))
				if self == .pinADConfiguration {
					return config.map { b -> PinConfiguration in b ? .Digital : .Analogue } as? T
				}
				return config as? T //TODO: hopefully the order is right...
			case .ledMatrixState:
				return dataBytes.map { (byte) -> [Bool] in
					return (1...5).map { offset in (byte & (1 << (5 - offset))) != 0 }
				} as? T //TODO: look up endianness in led octets and apply offset correspondingly
			case .scrollingDelay:
				return UInt16(littleEndianData: dataBytes) as? T
			case .buttonAState, .buttonBState:
				return ButtonPressAction(rawValue: dataBytes[0]) as? T
			case .accelerometerData, .magnetometerData:
				return dataBytes.withUnsafeBytes {
					(int16Ptr: UnsafePointer<Int16>) -> (Int16, Int16, Int16) in
					return (Int16(littleEndian: int16Ptr[0]), //X
						Int16(littleEndian: int16Ptr[1]), //y
						Int16(littleEndian: int16Ptr[2])) //z
					} as? T
			case .accelerometerPeriod, .magnetometerPeriod, .temperaturePeriod:
				return UInt16(littleEndianData: dataBytes) as? T
			case .magnetometerBearing:
				return UInt16(littleEndianData: dataBytes) as? T
			case .microBitEvent:
				return dataBytes.withUnsafeBytes { (uint16ptr:UnsafePointer<Int16>) -> (Event, Int16)? in
					guard let event = Event(rawValue: Int16(littleEndian:uint16ptr.pointee)) else { return nil }
					return (event, Int16(littleEndian:uint16ptr.pointee))
					} as? T
			case .txCharacteristic:
				return dataBytes as? T
			case .temperature:
				return Int8(littleEndianData: dataBytes) as? T
			default:
				return nil
			}
		}

		fileprivate func encode<T>(object: T) -> Data? {
			switch self {
			case .accelerometerPeriod, .magnetometerPeriod, .temperaturePeriod:
				guard let period = object as? UInt16 else { return nil }
				return period.littleEndianData
			case .pinData:
				guard let pinValues = object as? [UInt8: UInt8] else { return nil }
				return Data(bytes: pinValues.flatMap { [$0, $1] })
			case .pinADConfiguration, .pinIOConfiguration:
				let obj: [Bool]?
				if self == .pinADConfiguration {
					obj = (object as? [PinConfiguration])?.map { $0 == .Analogue }
				} else {
					obj = object as? [Bool]
				}
				guard var asBitmap = (obj?.enumerated().reduce(Int32(0)) {
					return $1.element == false ? $0 : ($0 | (1 << $1.offset))
				}) else { return nil }
				return Data(bytes: &asBitmap, count: MemoryLayout.size(ofValue: asBitmap)).subdata(in: 0..<3)
			case .ledMatrixState:
				guard let ledArray = object as? [[Bool]] else { return nil }
				let bitmapArray = ledArray.map {
					$0.enumerated().reduce(UInt8(0)) {
						$1.element == false ? $0 : ($0 | 1 << (4 - $1.offset))
					}
				} //TODO: look up endianness in led octets and apply offset correspondingly
				return Data(bitmapArray)
			case .ledText:
				return (object as? String)?.data(using: .utf8)
			case .scrollingDelay:
				guard let delay = object as? UInt16 else { return nil }
				return delay.bigEndianData
			case .rxCharacteristic:
				return object as? Data
			default:
				return nil
			}
		}
	}

	public static let uuidCharacteristicMap = Dictionary(uniqueKeysWithValues:CalliopeCharacteristic.allCases.map { ($0.uuid, $0) })

	//standard bluetooth profile of any device: Peripherials contain services which contain characteristics
	//(or included services, but let´s forget about them for now)
	public static let serviceCharacteristicMap : [CalliopeService : [CalliopeCharacteristic]] = [
		.debug : [.debug],
		.notify : [.notify],
		.program: [.program],

		.accelerometer: [.accelerometerData, .accelerometerPeriod],
		.magnetometer: [.magnetometerData, .magnetometerPeriod, .magnetometerBearing],
		.button: [.buttonAState, .buttonBState],
		.ioPin: [.pinData, .pinADConfiguration, .pinIOConfiguration, .pwmControl],
		.led: [.ledMatrixState, .ledText, .scrollingDelay],
		.event: [.microBitRequirements, .microBitEvent, .clientRequirements, .clientEvent],
		.temperature: [.temperature, .temperaturePeriod],
		.uart: [.txCharacteristic, .rxCharacteristic]
	]

	private static let characteristicServiceMap = Dictionary(uniqueKeysWithValues: serviceCharacteristicMap.flatMap {(key, value) in value.map { value in (value, key) } })

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
	public let name : String
	public private(set) var servicesWithUndiscoveredCharacteristics = CalliopeBLEDevice.requiredServicesUUIDs

	init(peripheral: CBPeripheral, name: String) {
		self.peripheral = peripheral
		self.name = name
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

	//MARK: reading and writing characteristics (asynchronously/ scheduled/ synchronously)

	public var timeoutRead: DispatchTimeInterval = DispatchTimeInterval.milliseconds(2000)
	public var timeoutWrite: DispatchTimeInterval = DispatchTimeInterval.milliseconds(2000)

	//to sequentialize reads and writes

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

	public func write (_ data: Data, for characteristic: CalliopeCharacteristic) throws {
		guard state == .playgroundReady
			else { throw "Not ready to write to characteristic \(characteristic)" }
		guard let service = CalliopeBLEDevice.characteristicServiceMap[characteristic], CalliopeBLEDevice.requiredServices.contains(service)
			else { throw "service not available" }

		let cbCharacteristic = peripheral.services!.filter { $0.uuid ==  service.uuid }.first!.characteristics!.filter { $0.uuid == characteristic.uuid }.first!
		try write(data, for: cbCharacteristic)
	}

	private func write(_ data: Data, for characteristic: CBCharacteristic) throws {
		readWriteSem.wait()
		writingCharacteristic = characteristic

		//write value and wait for delegate call (or error)
		writeGroup.enter()
		self.peripheral.writeValue(data, for: characteristic, type: .withResponse)
		//TODO: writeSignal.wait(timeout) could lead to unexpected results, if we submit multiple dependant writes to be transferred and one times out
		if writeGroup.wait(timeout: DispatchTime.now() + 10) == .timedOut {
			LogNotify.log("write to \(characteristic) timed out")
			writeError = CBError(.connectionTimeout)
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

	public func read(characteristic: CalliopeCharacteristic) throws -> Data? {
		guard state == .playgroundReady
			else { throw "Not ready to read characteristic \(characteristic)" }
		guard let cbCharacteristic = getCBCharacteristic(characteristic)
			else { throw "no service that contains characteristic \(characteristic)" }
		return try read(characteristic: cbCharacteristic)
	}

	private func read(characteristic: CBCharacteristic) throws -> Data? {
		readWriteSem.wait()
		readingCharacteristic = characteristic

		//read value and wait for delegate call (or error)
		readGroup.enter()
		self.peripheral.readValue(for: characteristic)
		if readGroup.wait(timeout: DispatchTime.now() + 10) == .timedOut {
			LogNotify.log("read from \(characteristic) timed out")
			readError = CBError(.connectionTimeout)
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

	public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		if let writingCharac = writingCharacteristic, characteristic.uuid == writingCharac.uuid {
			return explicitWriteResponse(error)
		}
	}

	public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

		if let readingCharac = readingCharacteristic, characteristic.uuid == readingCharac.uuid {
			return explicitReadResponse(for: characteristic, error: error)
		}

		guard error == nil, let value = characteristic.value else {
			LogNotify.log(readError?.localizedDescription ?? "characteristic \(characteristic.uuid) does not have a value")
			return
		}

		if characteristic.uuid == CalliopeCharacteristic.notify.uuid {
			updateSensorReading(value)
		} else {
			//TODO: if we have all the sensor characteristics, and one updates, we can as well update the dashboard using it
			updateQueue.async {
				self.notifyListener(for: characteristic, value: value)
			}
		}
	}

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
			readGroup.leave()
			return
		} else {
			readValue = characteristic.value
			readGroup.leave()
			return
		}
	}

	private func notifyListener(for characteristic: CBCharacteristic, value: Data) {
		guard let calliopeCharacteristic = CalliopeBLEDevice.uuidCharacteristicMap[characteristic.uuid] else { return }
		switch calliopeCharacteristic {
		case .accelerometerData:
			accelerometerNotification?(calliopeCharacteristic.interpret(dataBytes: value))
		case .magnetometerData:
			magnetometerNotification?(calliopeCharacteristic.interpret(dataBytes: value))
		case .magnetometerBearing:
			magnetometerBearingNotification?(calliopeCharacteristic.interpret(dataBytes: value))
		case .pinData:
			pinDataNotification?(calliopeCharacteristic.interpret(dataBytes: value))
			postSensorUpdateNotification(DashboardItemType.Pin, 0)
		case .buttonAState:
			buttonAActionNotification?(calliopeCharacteristic.interpret(dataBytes: value))
			postSensorUpdateNotification(DashboardItemType.ButtonA, 0)
		case .buttonBState:
			buttonBActionNotification?(calliopeCharacteristic.interpret(dataBytes: value))
			postSensorUpdateNotification(DashboardItemType.ButtonB, 0)
		case .microBitEvent:
			eventNotification?(calliopeCharacteristic.interpret(dataBytes: value))
		case .temperature:
			let temperature: Int8? = calliopeCharacteristic.interpret(dataBytes: value)
			temperatureNotification?(temperature)
			postThermometerNotification(temperature ?? 0)
		default:
			return
		}
	}

	private func getCBCharacteristic(_ characteristic: CalliopeCharacteristic) -> CBCharacteristic? {
		guard let serviceUuid = CalliopeBLEDevice.characteristicServiceMap[characteristic]?.uuid else { return nil }
		let uuid = characteristic.uuid
		return peripheral.services!.filter { $0.uuid == serviceUuid }.first!
			.characteristics!.filter { $0.uuid == uuid }.first!
	}
}

extension CalliopeBLEDevice {

	//MARK: variables retrieved over bluetooth
	//Calliope API can be built on top of this.
	//TODO: read/write apis missing: parts of Event Service, PWMControl

	/// data read from I/O Pins
	func readPinData() -> [UInt8:UInt8]? {
		return read(.pinData)
	}

	func writePinData(data: [UInt8:UInt8]) {
		write(data, .pinData)
	}

	/// notification called when pinData value is changed
	public var pinDataNotification: (([UInt8:UInt8]?) -> ())? {
		set { setNotifyListener(for: .pinData, newValue) }
		get { return getNotifyListener(for: .pinData) }
	}

	public enum PinConfiguration {
		case Digital
		case Analogue
	}

	var pinADConfiguration: [PinConfiguration]? {
		get { return read(.pinADConfiguration) }
		set { write(newValue, .pinADConfiguration) }
	}

	var pinIOConfiguration: [Bool]? {
		get { return read(.pinIOConfiguration) }
		set { write(newValue, .pinIOConfiguration) }
	}

	public enum ButtonPressAction: UInt8 {
		case Up
		case Down
		case Long
	}

	/// action that is done to button A
	var buttonAAction: ButtonPressAction? {
		return read(.buttonAState)
	}

	/// notification called when Button A value is updated
	public var buttonAActionNotification: ((ButtonPressAction?) -> ())? {
		set { setNotifyListener(for: .buttonAState, newValue) }
		get { return getNotifyListener(for: .buttonAState) }
	}

	/// action that is done to button B
	var buttonBAction: ButtonPressAction? {
		return read(.buttonBState)
	}

	/// notification called when Button B value is updated
	public var buttonBActionNotification: ((ButtonPressAction?) -> ())? {
		set { setNotifyListener(for: .buttonBState, newValue) }
		get { return getNotifyListener(for: .buttonBState) }
	}

	/// which leds are on and which off.
	/// ledMatrixState[2][3] gives led 3 in row 2
	var ledMatrixState: [[Bool]]? {
		get { return read(.ledMatrixState) }
		set { write(newValue, .ledMatrixState) }
	}


	/// scrolls a string on the display of the calliope
	/// - Parameter string: the string to display,
	///                     can contain all latin letters and some symbols
	func displayLedText(_ string: String) {
		write(string, .ledText)
	}


	/// the delay in ms between showing successive characters of the led text
	var scrollingDelay: UInt16 {
		get { return read(.scrollingDelay)! }
		set { write(newValue, .scrollingDelay) }
	}

	/// (X, Y, Z) value for acceleration
	var accelerometerValue: (Int16, Int16, Int16)? {
		return read(.accelerometerData)
	}

	/// notification called when accelerometer value is being requested periodically
	public var accelerometerNotification: (((Int16, Int16, Int16)?) -> ())? {
		set { setNotifyListener(for: .accelerometerData, newValue) }
		get { return getNotifyListener(for: .accelerometerData) }
	}

	/// frequency with which the accelerometer data is read
	/// valid values: 1, 2, 5, 10, 20, 80, 160 and 640.
	public var accelerometerUpdateFrequency: UInt16? {
		get { return read(.accelerometerPeriod) }
		set { write(newValue, .accelerometerPeriod) }
	}

	/// (X, Y, Z) value for angle to magnetic pole
	var magnetometerValue: (Int16, Int16, Int16)? {
		return read(.magnetometerData)
	}

	/// notification called when magnetometer value is being requested periodically
	public var magnetometerNotification: (((Int16, Int16, Int16)?) -> ())? {
		set { setNotifyListener(for: .magnetometerData, newValue) }
		get { return getNotifyListener(for: .magnetometerData) }
	}

	/// frequency with which the magnetometer data is read
	/// valid values: 1, 2, 5, 10, 20, 80, 160 and 640.
	public var magnetometerUpdateFrequency: UInt16? {
		get { return read(.magnetometerPeriod) }
		set { write(newValue, .magnetometerPeriod) }
	}

	/// bearing, i.e. deviation of north of the magnetometer
	var magnetometerBearing: Int16? {
		return read(.magnetometerBearing)
	}

	/// notification called when magnetometer bearing value is changed
	public var magnetometerBearingNotification: ((Int16?) -> ())? {
		set { setNotifyListener(for: .magnetometerBearing, newValue) }
		get { return getNotifyListener(for: .magnetometerBearing) }
	}

	//TODO: don´t really know what event is for
	public enum Event: Int16 {
		case MES_DEVICE_INFO_ID = 1103
		case MES_SIGNAL_STRENGTH_ID = 1101
		case MES_DPAD_CONTROLLER_ID = 1104
		case MES_BROADCAST_GENERAL_ID = 2000
	}

	/// (event, value) received via messagebus
	var eventValue: (Event, Int16)? {
		return read(.microBitEvent)
	}

	/// notification called when event value is being requested periodically
	public var eventNotification: (((Event, Int16)?) -> ())? {
		set { setNotifyListener(for: .microBitEvent, newValue) }
		get { return getNotifyListener(for: .microBitEvent) }
	}

	/// temperature reading in celsius
	var temperature: Int8? {
		return read(.temperature)
	}

	/// notification called when tx value is being requested periodically
	public var temperatureNotification: ((Int8?) -> ())? {
		set { setNotifyListener(for: .temperature, newValue) }
		get { return getNotifyListener(for: .temperature) }
	}

	/// frequency with which the temperature is updated
	var temperatureUpdateFrequency: UInt16? {
		get { return read(.temperaturePeriod) }
		set { write(newValue, .temperaturePeriod) }
	}

	/// data received via UART, 20 bytes max.
	public func readSerialData() -> Data? {
		return read(.txCharacteristic)
	}

	// data sent via UART, 20 bytes max.
	public func sendSerialData(_ data: Data) {
		return write(data, .rxCharacteristic)
	}

	private func write<T>(_ value: T, _ characteristic: CalliopeCharacteristic) {
		do {
			guard let data = characteristic.encode(object: value) else { throw "could not convert" }
			try write(data, for: characteristic)
		}
		catch { LogNotify.log("failed writing to \(characteristic), value \(value)") }
	}

	private func read<T>(_ characteristic: CalliopeCharacteristic) -> T? {
		let dataBytes: Data?
		do { dataBytes = try read(characteristic: characteristic) }
		catch { return nil }
		return characteristic.interpret(dataBytes: dataBytes)
	}

	private func setNotifyListener(for characteristic: CalliopeCharacteristic, _ listener: Any?) {
		updateListeners[characteristic] = listener
		let cbCharacteristic = getCBCharacteristic(characteristic)!
		if listener != nil {
			peripheral.setNotifyValue(true, for: cbCharacteristic)
		} else {
			peripheral.setNotifyValue(false, for: cbCharacteristic)
		}
	}

	private func getNotifyListener<T>(for characteristic: CalliopeCharacteristic) -> T? {
		return updateListeners[characteristic] as? T
	}
}

extension CalliopeBLEDevice {

	// MARK: Receiving sensor values via notify characteristic

	public func readSensors(_ enabled: Bool) throws {
		guard CalliopeBLEDevice.requiredServices.contains(.notify)
			&& state == .playgroundReady else { throw "Not ready to read sensor values" }

		let notifyServiceUUID = CalliopeBLEDevice.CalliopeService.notify.uuid
		let notifyCharacteristicUUID = CalliopeBLEDevice.CalliopeCharacteristic.notify.uuid
		//never crashes because we made sure we are ready for the playground, i.e. we have all required services
		let service = peripheral.services!.filter { $0.uuid ==  notifyServiceUUID }.first!
		let notifyCharacteristic = service.characteristics!.filter { $0.uuid == notifyCharacteristicUUID }.first!

		peripheral.setNotifyValue(enabled, for: notifyCharacteristic)
	}

	private func updateSensorReading(_ value: Data) {

		if let type = DashboardItemType(rawValue:UInt16(value[1])) {
			LogNotify.log("\(self) received value \(String(describing: UInt16(littleEndianData: value.subdata(in: 2..<value.count))))) for \(type)")
			let value = int8(Int(value[3]))

			//TODO: do not use notification center, but let observers subscribe directly to sensorReadings´ value
			//TODO: subscription to swift dictionaries via didSet works.
			if(type == DashboardItemType.ButtonAB) {
				postButtonANotification(value)
				postButtonBNotification(value)
			} else if type == DashboardItemType.Thermometer {
				postThermometerNotification(value)
			} else {
				postSensorUpdateNotification(type, value)
			}
		}
	}

	private func postButtonANotification(_ value: Int8) {
		postSensorUpdateNotification(DashboardItemType.ButtonA, value)
	}

	private func postButtonBNotification(_ value: Int8) {
		postSensorUpdateNotification(DashboardItemType.ButtonB, value)
	}

	private func postThermometerNotification(_ value: Int8) {
		let localizedValue = Int8( ValueLocalizer.current.localizeTemperature(unlocalized: Double(value)) )
		postSensorUpdateNotification(DashboardItemType.Thermometer, localizedValue)
	}

	fileprivate func postSensorUpdateNotification(_ type: DashboardItemType, _ value: Int8) {
		NotificationCenter.default.post(name:UIView_DashboardItem.Ping, object: nil, userInfo:["type":type.rawValue, "value":value])
	}
}


extension CalliopeBLEDevice {

	// MARK: Uploading programs via program characteristic

	public func upload(program: ProgramBuildResult) throws {
		guard CalliopeBLEDevice.requiredServices.contains(.notify)
			&& state == .playgroundReady else { throw "Not ready to receive programs yet" }

		//code of the program
		let code : [UInt8] = program.code
		//methods of the program
		let methods : [UInt16] = program.methods

		//never crashes because we made sure we are ready for the playground, i.e. we have all required services
		let programCharacteristic = getCBCharacteristic(.program)!

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
		return "name: \(String(describing: name)), state: \(state)"
	}
}
