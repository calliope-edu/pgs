//
//  ClientCalliopeBLEDevice.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 23.02.19.
//

import Foundation

extension CalliopeBLEDevice {

	enum PinConfiguration {
		case Digital
		case Analogue
	}

	//Identifiers used in the firmware for sending via event message bus
	enum Event: UInt16 {
		case ALL = 0
		case PIN_TOUCH_0 = 11200
		case PIN_TOUCH_1 = 11201
		case PIN_TOUCH_2 = 11202
		case PIN_TOUCH_3 = 11203
	}

	enum ButtonPressAction: UInt8 {
		case Up
		case Down
		case Long
	}

	//MARK: Convenient way to synchronously access calliope via Bluetooth
	//TODO: read/write apis missing: parts of Event Service, PWMControl

	/// data read from I/O Pins
	public func readPinData() -> [UInt8:UInt8]? {
		return read(.pinData)
	}

	public func writePinData(data: [UInt8:UInt8]) {
		write(data, .pinData)
	}

	/// notification called when pinData value is changed
	public var pinDataNotification: (([UInt8:UInt8]?) -> ())? {
		set { setNotifyListener(for: .pinData, newValue) }
		get { return getNotifyListener(for: .pinData) }
	}

	public var pinADConfiguration: [PinConfiguration]? {
		get { return read(.pinADConfiguration) }
		set { write(newValue, .pinADConfiguration) }
	}

	public var pinIOConfiguration: [Bool]? {
		get { return read(.pinIOConfiguration) }
		set { write(newValue, .pinIOConfiguration) }
	}

	/// action that is done to button A
	public var buttonAAction: ButtonPressAction? {
		return read(.buttonAState)
	}

	/// notification called when Button A value is updated
	public var buttonAActionNotification: ((ButtonPressAction?) -> ())? {
		set { setNotifyListener(for: .buttonAState, newValue) }
		get { return getNotifyListener(for: .buttonAState) }
	}

	/// action that is done to button B
	public var buttonBAction: ButtonPressAction? {
		return read(.buttonBState)
	}

	/// notification called when Button B value is updated
	public var buttonBActionNotification: ((ButtonPressAction?) -> ())? {
		set { setNotifyListener(for: .buttonBState, newValue) }
		get { return getNotifyListener(for: .buttonBState) }
	}

	/// which leds are on and which off.
	/// ledMatrixState[2][3] gives led 3 in row 2
	public var ledMatrixState: [[Bool]]? {
		get { return read(.ledMatrixState) }
		set { write(newValue, .ledMatrixState) }
	}


	/// scrolls a string on the display of the calliope
	/// - Parameter string: the string to display,
	///                     can contain all latin letters and some symbols
	public func displayLedText(_ string: String) {
		write(string, .ledText)
	}


	/// the delay in ms between showing successive characters of the led text
	public var scrollingDelay: UInt16 {
		get { return read(.scrollingDelay)! }
		set { write(newValue, .scrollingDelay) }
	}

	/// (X, Y, Z) value for acceleration
	public var accelerometerValue: (Int16, Int16, Int16)? {
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
	public var magnetometerValue: (Int16, Int16, Int16)? {
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
	public var magnetometerBearing: Int16? {
		return read(.magnetometerBearing)
	}

	/// notification called when magnetometer bearing value is changed
	public var magnetometerBearingNotification: ((Int16?) -> ())? {
		set { setNotifyListener(for: .magnetometerBearing, newValue) }
		get { return getNotifyListener(for: .magnetometerBearing) }
	}

	/// (event, value) to be received via messagebus.
	public func startNotificationForEvent(_ event: Event = .ALL, value: UInt16 = 0) {
		write([(event, value)], .clientRequirements)
	}

	/// notification called when event is raised
	public var eventNotification: (((Event, UInt16)?) -> ())? {
		set { setNotifyListener(for: .microBitEvent, newValue) }
		get { return getNotifyListener(for: .microBitEvent) }
	}

	/// temperature reading in celsius
	public var temperature: Int8? {
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


	/// writes a typed input by encoding it to data and sending it to calliope
	///
	/// - Parameters:
	///   - value: some value to be written
	///   - characteristic: some characteristic to write to. Type of value needs to match type taken by characteristic
	private func write<T>(_ value: T, _ characteristic: CalliopeCharacteristic) {
		do {
			guard let data = characteristic.encode(object: value) else { throw "could not convert \(value) for \(characteristic)" }
			try write(data, for: characteristic)
		}
		catch { LogNotify.log("failed writing to \(characteristic), value \(value)") }
	}

	/// reads a value from some calliope characteristic and adds type information to the parsed value
	///
	/// - Parameters:
	///   - characteristic: some characteristic to read from. Required type needs to match value read by characteristic
	private func read<T>(_ characteristic: CalliopeCharacteristic) -> T? {
		guard let dataBytes = try? read(characteristic: characteristic) else { return nil }
		return characteristic.interpret(dataBytes: dataBytes)
	}

	private func setNotifyListener(for characteristic: CalliopeCharacteristic, _ listener: Any?) {
		guard let cbCharacteristic = getCBCharacteristic(characteristic) else { return }
		updateListeners[characteristic] = listener
		if listener != nil {
			peripheral.setNotifyValue(true, for: cbCharacteristic)
		} else {
			peripheral.setNotifyValue(false, for: cbCharacteristic)
		}
	}

	private func getNotifyListener<T>(for characteristic: CalliopeCharacteristic) -> T? {
		return updateListeners[characteristic] as? T
	}

	func notifyListener(for characteristic: CalliopeCharacteristic, value: Data) {
		switch characteristic {
		case .accelerometerData:
			accelerometerNotification?(characteristic.interpret(dataBytes: value))
		case .magnetometerData:
			magnetometerNotification?(characteristic.interpret(dataBytes: value))
		case .magnetometerBearing:
			magnetometerBearingNotification?(characteristic.interpret(dataBytes: value))
		case .pinData:
			pinDataNotification?(characteristic.interpret(dataBytes: value))
			postSensorUpdateNotification(DashboardItemType.Pin, 0)
		case .buttonAState:
			buttonAActionNotification?(characteristic.interpret(dataBytes: value))
			postSensorUpdateNotification(DashboardItemType.ButtonA, 0)
		case .buttonBState:
			buttonBActionNotification?(characteristic.interpret(dataBytes: value))
			postSensorUpdateNotification(DashboardItemType.ButtonB, 0)
		case .microBitEvent:
			eventNotification?(characteristic.interpret(dataBytes: value))
		case .temperature:
			let temperature: Int8? = characteristic.interpret(dataBytes: value)
			temperatureNotification?(temperature)
			postThermometerNotification(temperature ?? 0)
		default:
			return
		}
	}
}

extension CalliopeCharacteristic {
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
				return config.map { b -> CalliopeBLEDevice.PinConfiguration in b ? .Digital : .Analogue } as? T
			}
			return config as? T //TODO: hopefully the order is right...
		case .ledMatrixState:
			return dataBytes.map { (byte) -> [Bool] in
				return (1...5).map { offset in (byte & (1 << (5 - offset))) != 0 }
				} as? T
		case .scrollingDelay:
			return UInt16(littleEndianData: dataBytes) as? T
		case .buttonAState, .buttonBState:
			return CalliopeBLEDevice.ButtonPressAction(rawValue: dataBytes[0]) as? T
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
			return dataBytes.withUnsafeBytes { (uint16ptr:UnsafePointer<UInt16>) -> (CalliopeBLEDevice.Event, UInt16)? in
				guard let event = CalliopeBLEDevice.Event(rawValue: UInt16(littleEndian:uint16ptr[0])) else { return nil }
				return (event, UInt16(littleEndian:uint16ptr[1]))
				} as? T
		case .txCharacteristic:
			return dataBytes as? T
		case .temperature:
			let localized = Int8(ValueLocalizer.current.localizeTemperature(unlocalized: Double(Int8(littleEndianData: dataBytes) ?? 42)))
			return localized as? T
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
			let obj: [Int32]?
			if self == .pinADConfiguration {
				obj = (object as? [CalliopeBLEDevice.PinConfiguration])?.enumerated().map { $0.element == .Analogue ? (1 << $0.offset) : 0 }
			} else {
				obj = (object as? [Bool])?.enumerated().map { $0.element ? (1 << $0.offset) : 0 }
			}
			guard var asBitmap = (obj?.reduce(0) { $0 | $1 }) else { return nil }
			return Data(bytes: &asBitmap, count: MemoryLayout.size(ofValue: asBitmap))
		case .ledMatrixState:
			guard let ledArray = object as? [[Bool]] else { return nil }
			let bitmapArray = ledArray.map {
				$0.enumerated().reduce(UInt8(0)) {
					$1.element == false ? $0 : ($0 | 1 << (4 - $1.offset))
				}
			}
			return Data(bitmapArray)
		case .ledText:
			return (object as? String)?.data(using: .utf8)
		case .scrollingDelay:
			guard let delay = object as? UInt16 else { return nil }
			return delay.bigEndianData
		case .rxCharacteristic:
			return object as? Data
		case .clientRequirements:
			guard let eventTuples = object as? [(CalliopeBLEDevice.Event, UInt16)] else { return nil }
			return eventTuples.flatMap { [$0.rawValue.littleEndianData, $1.littleEndianData] }
				.reduce(into: Data()) { $0.append($1) }
		default:
			return nil
		}
	}
}
