//
//  ApiCalls.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 28.01.19.
//

import Foundation

public enum ApiCall {

	//callbacks/inputs
	case buttonA()
	case buttonB()
	case buttonAB()
	case buttonALongPress()
	case buttonBLongPress()
	case buttonABLongPress()
	case pin(pin: UInt16)
	case shake()
	case clap()

	//internally handled
	case start()
	case forever()

	//outputs
	case rgbOn(color: miniColor)
	case rgbOff()
	case displayClear()
	case displayShowGrid(grid: [UInt8])
	case displayShowImage(image: miniImage)
	case displayShowText(text: String)
	case soundOff()
	case soundOnNote(note: miniSound)
	case soundOnFreq(freq: UInt16)
	case requestButtonState(button: buttonType)
	case respondButtonState(isPressed: Bool)
	case requestPinState(pin: UInt16)
	case respondPinState(isPressed: Bool)
	case requestNoise()
	case respondNoise(level: UInt16)
	case requestTemperature()
	case respondTemperature(degrees: Int16)
	case requestBrightness()
	case respondBrightness(level: UInt16)

	//other controls
	case sleep(time: UInt16)
	case finished()
	case registerCallbacks()
}

extension ApiCall: Codable {
	enum Key: CodingKey {
		case rawValue
		case pinNumber
		case rgbColor
		case ledGrid
		case ledImage
		case ledText
		case soundNote
		case soundFreq
		case button
		case buttonValue
		case pinValue
		case noiseValue
		case brightnessValue
		case temperatureValue
		case sleepTime
	}

	enum CodingError: Error {
		case unknownValue
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: Key.self)
		let rawValue = try container.decode(Int.self, forKey: .rawValue)
		switch rawValue {
		case 0:
			self = .buttonA()
		case 1:
			self = .buttonB()
		case 2:
			self = .buttonAB()
		case 3:
			self = .buttonALongPress()
		case 4:
			self = .buttonBLongPress()
		case 5:
			self = .buttonABLongPress()
		case 6:
			let pinNumber = try container.decode(UInt16.self, forKey: .pinNumber)
			self = .pin(pin: pinNumber)
		case 7:
			self = .shake()
		case 8:
			self = .clap()
		case 9:
			self = .start()
		case 10:
			self = .forever()
		case 11:
			let color = try container.decode(miniColor.self, forKey: .rgbColor)
			self = .rgbOn(color: color)
		case 12:
			self = .rgbOff()
		case 13:
			self = .displayClear()
		case 14:
			let grid = try container.decode([UInt8].self, forKey: .ledGrid)
			self = .displayShowGrid(grid: grid)
		case 15:
			let image = try container.decode(miniImage.self, forKey: .ledImage)
			self = .displayShowImage(image: image)
		case 16:
			self = .soundOff()
		case 17:
			let note = try container.decode(miniSound.self, forKey: .soundNote)
			self = .soundOnNote(note: note)
		case 18:
			let freq = try container.decode(UInt16.self, forKey: .soundFreq)
			self = .soundOnFreq(freq: freq)
		case 19:
			let button = try container.decode(buttonType.self, forKey: .button)
			self = .requestButtonState(button: button)
		case 20:
			let isPressed = try container.decode(Bool.self, forKey: .buttonValue)
			self = .respondButtonState(isPressed: isPressed)
		case 21:
			let pin = try container.decode(UInt16.self, forKey: .pinNumber)
			self = .requestPinState(pin: pin)
		case 22:
			let isPressed = try container.decode(Bool.self, forKey: .pinValue)
			self = .respondPinState(isPressed: isPressed)
		case 23:
			self = .requestNoise()
		case 24:
			let level = try container.decode(UInt16.self, forKey: .noiseValue)
			self = .respondNoise(level: level)
		case 25:
			self = .requestTemperature()
		case 26:
			let degrees = try container.decode(Int16.self, forKey: .temperatureValue)
			self = .respondTemperature(degrees: degrees)
		case 27:
			let time = try container.decode(UInt16.self, forKey: .sleepTime)
			self = .sleep(time: time)
		case 28:
			let text = try container.decode(String.self, forKey: .ledText)
			self = .displayShowText(text: text)
		case 29:
			self = .requestBrightness()
		case 30:
			let level = try container.decode(UInt16.self, forKey: .brightnessValue)
			self = .respondBrightness(level: level)
		case 31:
			self = .finished()
		case 32:
			self = .registerCallbacks()
		default:
			throw CodingError.unknownValue
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: Key.self)
		switch self {
		case .buttonA():
			try container.encode(0, forKey: .rawValue)
		case .buttonB():
			try container.encode(1, forKey: .rawValue)
		case .buttonAB():
			try container.encode(2, forKey: .rawValue)
		case .buttonALongPress():
			try container.encode(3, forKey: .rawValue)
		case .buttonBLongPress():
			try container.encode(4, forKey: .rawValue)
		case .buttonABLongPress():
			try container.encode(5, forKey: .rawValue)
		case .pin(let pinNumber):
			try container.encode(6, forKey: .rawValue)
			try container.encode(pinNumber, forKey: .pinNumber)
		case .shake:
			try container.encode(7, forKey: .rawValue)
		case .clap:
			try container.encode(8, forKey: .rawValue)
		case .start:
			try container.encode(9, forKey: .rawValue)
		case .forever:
			try container.encode(10, forKey: .rawValue)
		case .rgbOn(let color):
			try container.encode(11, forKey: .rawValue)
			try container.encode(color, forKey: .rgbColor)
		case .rgbOff:
			try container.encode(12, forKey: .rawValue)
		case .displayClear:
			try container.encode(13, forKey: .rawValue)
		case .displayShowGrid(let grid):
			try container.encode(14, forKey: .rawValue)
			try container.encode(grid, forKey: .ledGrid)
		case .displayShowImage(let image):
			try container.encode(15, forKey: .rawValue)
			try container.encode(image, forKey: .ledImage)
		case .soundOff:
			try container.encode(16, forKey: .rawValue)
		case .soundOnNote(let note):
			try container.encode(17, forKey: .rawValue)
			try container.encode(note, forKey: .soundNote)
		case .soundOnFreq(let freq):
			try container.encode(18, forKey: .rawValue)
			try container.encode(freq, forKey: .soundFreq)
		case .requestButtonState(let button):
			try container.encode(19, forKey: .rawValue)
			try container.encode(button, forKey: .button)
		case .respondButtonState(let isPressed):
			try container.encode(20, forKey: .rawValue)
			try container.encode(isPressed, forKey: .buttonValue)
		case .requestPinState(let pin):
			try container.encode(21, forKey: .rawValue)
			try container.encode(pin, forKey: .pinNumber)
		case .respondPinState(let isPressed):
			try container.encode(22, forKey: .rawValue)
			try container.encode(isPressed, forKey: .pinValue)
		case .requestNoise:
			try container.encode(23, forKey: .rawValue)
		case .respondNoise(let level):
			try container.encode(24, forKey: .rawValue)
			try container.encode(level, forKey: .noiseValue)
		case .requestTemperature:
			try container.encode(25, forKey: .rawValue)
		case .respondTemperature(let degrees):
			try container.encode(26, forKey: .rawValue)
			try container.encode(degrees, forKey: .temperatureValue)
		case .sleep(let time):
			try container.encode(27, forKey: .rawValue)
			try container.encode(time, forKey: .sleepTime)
		case .displayShowText(let text):
			try container.encode(28, forKey: .rawValue)
			try container.encode(text, forKey: .ledText)
		case .requestBrightness():
			try container.encode(29, forKey: .rawValue)
		case .respondBrightness(let level):
			try container.encode(30, forKey: .rawValue)
			try container.encode(level, forKey: .brightnessValue)
		case .finished():
			try container.encode(31, forKey: .rawValue)
		case .registerCallbacks():
			try container.encode(32, forKey: .rawValue)
		}
	}
}


extension ApiCall: DataConvertible {
	public var data: Data {
		return (try? PropertyListEncoder().encode(self)) ?? Data()
	}

	init?(data: Data) {
		let maybeCall = try? PropertyListDecoder().decode(ApiCall.self, from: data)
		guard let call = maybeCall else { return nil }
		self = call
	}
}
