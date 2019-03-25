//
//  ApiEncodings.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 23.02.19.
//

import Foundation

enum Key: CodingKey {
	case enumValue
	case parameterValue
}

enum CodingError: Error {
	case unknownValue
}

protocol ApiCall: Codable, DataConvertible {
	init(_: KeyedDecodingContainer<Key>, _: Int) throws
	func encode(to container: inout KeyedEncodingContainer<Key>) throws
}

extension ApiCall {
	public var data: Data {
		return (try? PropertyListEncoder().encode(self)) ?? Data()
	}

	public init?(data: Data) {
		let maybeCall = try? PropertyListDecoder().decode(Self.self, from: data)
		guard let call = maybeCall else { return nil }
		self = call
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: Key.self)
		let enumValue = try container.decode(Int.self, forKey: .enumValue)
		try self.init(container, enumValue)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: Key.self)
		try self.encode(to: &container)
	}
}

extension ApiCommand: ApiCall {

	init(_ container: KeyedDecodingContainer<Key>, _ enumValue: Int) throws {
		switch enumValue {
		//OUTPUT
		//rgb
		case 12100:
			let color = try container.decode(miniColor.self, forKey: .parameterValue)
			self = .rgbOnColor(color: color)
		case 12101:
			self = .rgbOff()
		case 12102:
			let colorData = try container.decode([UInt8].self, forKey: .parameterValue)
			self = .rgbOnValues(r: colorData[0], g: colorData[1], b: colorData[2])
		//display
		case 12200:
			self = .displayClear()
		case 12201:
			let grid = try container.decode([UInt8].self, forKey: .parameterValue)
			self = .displayShowGrid(grid: grid)
		case 12202:
			let image = try container.decode(miniImage.self, forKey: .parameterValue)
			self = .displayShowImage(image: image)
		case 12203:
			let text = try container.decode(String.self, forKey: .parameterValue)
			self = .displayShowText(text: text)
		//sound
		case 12300:
			self = .soundOff()
		case 12301:
			let note = try container.decode(miniSound.self, forKey: .parameterValue)
			self = .soundOnNote(note: note)
		case 12302:
			let freq = try container.decode(UInt16.self, forKey: .parameterValue)
			self = .soundOnFreq(freq: freq)

		//CONTROL
		case 19100:
			self = .registerCallbacks()
		case 19400:
			let time = try container.decode(UInt16.self, forKey: .parameterValue)
			self = .sleep(time: time)

		default:
			throw CodingError.unknownValue
		}
	}


	func encode(to container: inout KeyedEncodingContainer<Key>) throws {
		switch self {

		//OUTPUT
		//rgb
		case .rgbOnColor(let color):
			try container.encode(12100, forKey: .enumValue)
			try container.encode(color, forKey: .parameterValue)
		case .rgbOff:
			try container.encode(12101, forKey: .enumValue)
		case .rgbOnValues(let r, let g, let b):
			try container.encode(12102, forKey: .enumValue)
			try container.encode([r, g, b], forKey: .parameterValue)
		//display
		case .displayClear:
			try container.encode(12200, forKey: .enumValue)
		case .displayShowGrid(let grid):
			try container.encode(12201, forKey: .enumValue)
			try container.encode(grid, forKey: .parameterValue)
		case .displayShowImage(let image):
			try container.encode(12202, forKey: .enumValue)
			try container.encode(image, forKey: .parameterValue)
		case .displayShowText(let text):
			try container.encode(12203, forKey: .enumValue)
			try container.encode(text, forKey: .parameterValue)
		//sound
		case .soundOff:
			try container.encode(12300, forKey: .enumValue)
		case .soundOnNote(let note):
			try container.encode(12301, forKey: .enumValue)
			try container.encode(note, forKey: .parameterValue)
		case .soundOnFreq(let freq):
			try container.encode(12302, forKey: .enumValue)
			try container.encode(freq, forKey: .parameterValue)

		//CONTROL
		case .registerCallbacks():
			try container.encode(19100, forKey: .enumValue)
		case .sleep(let time):
			try container.encode(19400, forKey: .enumValue)
			try container.encode(time, forKey: .parameterValue)
		}
	}
}

extension ApiRequest: ApiCall {

	init(_ container: KeyedDecodingContainer<Key>, _ enumValue: Int) throws {
		switch enumValue {

		//REQUEST/RESPONSE
		case 13100:
			let button = try container.decode(buttonType.self, forKey: .parameterValue)
			self = .requestButtonState(button: button)

		case 13200:
			let pin = try container.decode(UInt16.self, forKey: .parameterValue)
			self = .requestPinState(pin: pin)

		case 13300:
			self = .requestNoise()

		case 13400:
			self = .requestTemperature()

		case 13500:
			self = .requestBrightness()

		case 13600:
			self = .requestDisplay()

		default:
			throw CodingError.unknownValue
		}
	}

	func encode(to container: inout KeyedEncodingContainer<Key>) throws {
		switch self {

		//REQUEST/RESPONSE
		case .requestButtonState(let button):
			try container.encode(13100, forKey: .enumValue)
			try container.encode(button, forKey: .parameterValue)

		case .requestPinState(let pin):
			try container.encode(13200, forKey: .enumValue)
			try container.encode(pin, forKey: .parameterValue)

		case .requestNoise:
			try container.encode(13300, forKey: .enumValue)

		case .requestTemperature:
			try container.encode(13400, forKey: .enumValue)

		case .requestBrightness():
			try container.encode(13500, forKey: .enumValue)

		case .requestDisplay():
			try container.encode(13600, forKey: .enumValue)
		}
	}
}

extension ApiResponse: ApiCall {

	init(_ container: KeyedDecodingContainer<Key>, _ enumValue: Int) throws {
		switch enumValue {

		//REQUEST/RESPONSE
		case 13101:
			let isPressed = try container.decode(Bool.self, forKey: .parameterValue)
			self = .respondButtonState(isPressed: isPressed)

		case 13201:
			let isPressed = try container.decode(Bool.self, forKey: .parameterValue)
			self = .respondPinState(isPressed: isPressed)

		case 13301:
			let level = try container.decode(UInt16.self, forKey: .parameterValue)
			self = .respondNoise(level: level)

		case 13401:
			let degrees = try container.decode(Int16.self, forKey: .parameterValue)
			self = .respondTemperature(degrees: degrees)

		case 13501:
			let level = try container.decode(UInt16.self, forKey: .parameterValue)
			self = .respondBrightness(level: level)

		case 13601:
			let grid = try container.decode([UInt8].self, forKey: .parameterValue)
			self = .respondDisplay(grid: grid)

		case 19500:
			self = .finished()

		default:
			throw CodingError.unknownValue
		}
	}

	func encode(to container: inout KeyedEncodingContainer<Key>) throws {
		switch self {

		//REQUEST/RESPONSE
		case .respondButtonState(let isPressed):
			try container.encode(13101, forKey: .enumValue)
			try container.encode(isPressed, forKey: .parameterValue)

		case .respondPinState(let isPressed):
			try container.encode(13201, forKey: .enumValue)
			try container.encode(isPressed, forKey: .parameterValue)

		case .respondNoise(let level):
			try container.encode(13301, forKey: .enumValue)
			try container.encode(level, forKey: .parameterValue)

		case .respondTemperature(let degrees):
			try container.encode(13401, forKey: .enumValue)
			try container.encode(degrees, forKey: .parameterValue)

		case .respondBrightness(let level):
			try container.encode(13501, forKey: .enumValue)
			try container.encode(level, forKey: .parameterValue)

		case .respondDisplay(let grid):
			try container.encode(13601, forKey: .enumValue)
			try container.encode(grid, forKey: .parameterValue)

		case .finished():
			try container.encode(19500, forKey: .enumValue)

		}
	}
}

extension ApiCallback: ApiCall {

	init(_ container: KeyedDecodingContainer<Key>, _ enumValue: Int) throws {
		switch enumValue {

		//NOTIFICATIONS
		//buttons
		case 11100:
			self = .buttonA()
		case 11101:
			self = .buttonB()
		case 11102:
			self = .buttonAB()
		case 11103:
			self = .buttonALongPress()
		case 11104:
			self = .buttonBLongPress()
		case 11105:
			self = .buttonABLongPress()
		//pin
		case 11200:
			let pinNumber = try container.decode(UInt16.self, forKey: .parameterValue)
			self = .pin(pin: pinNumber)
		//accelerometer
		case 11300:
			self = .shake()

		//CONTROL
		case 19200:
			self = .start()
		case 19300:
			self = .forever()

		default:
			throw CodingError.unknownValue
		}
	}

	func encode(to container: inout KeyedEncodingContainer<Key>) throws {
		switch self {

		//NOTIFICATIONS
		//buttons
		case .buttonA():
			try container.encode(11100, forKey: .enumValue)
		case .buttonB():
			try container.encode(11101, forKey: .enumValue)
		case .buttonAB():
			try container.encode(11102, forKey: .enumValue)
		case .buttonALongPress():
			try container.encode(11103, forKey: .enumValue)
		case .buttonBLongPress():
			try container.encode(11104, forKey: .enumValue)
		case .buttonABLongPress():
			try container.encode(11105, forKey: .enumValue)
		//pin
		case .pin(let pinNumber):
			try container.encode(11200, forKey: .enumValue)
			try container.encode(pinNumber, forKey: .parameterValue)
		//accelerometer
		case .shake:
			try container.encode(11300, forKey: .enumValue)

		//CONTROL
		case .start:
			try container.encode(19200, forKey: .enumValue)
		case .forever:
			try container.encode(19300, forKey: .enumValue)
		}
	}
}
