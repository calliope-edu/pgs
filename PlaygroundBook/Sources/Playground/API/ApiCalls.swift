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

	case requestDisplay()
	case respondDisplay(grid: [UInt8])

	//other controls
	case sleep(time: UInt16)
	case finished()
	case registerCallbacks()
	//internally handled
	case start()
	case forever()
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
		case gridValue
		case sleepTime
	}

	enum CodingError: Error {
		case unknownValue
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: Key.self)
		let rawValue = try container.decode(Int.self, forKey: .rawValue)
		switch rawValue {

		//NOTIFICATIONS
		//buttons
		case 111000000:
			self = .buttonA()
		case 111000001:
			self = .buttonB()
		case 111000002:
			self = .buttonAB()
		case 111000003:
			self = .buttonALongPress()
		case 111000004:
			self = .buttonBLongPress()
		case 111000005:
			self = .buttonABLongPress()
		//pin
		case 112000000:
			let pinNumber = try container.decode(UInt16.self, forKey: .pinNumber)
			self = .pin(pin: pinNumber)
		//accelerometer
		case 113000000:
			self = .shake()
		//microphone
		case 11400000:
			self = .clap()

		//OUTPUT
		//rgb
		case 121000000:
			let color = try container.decode(miniColor.self, forKey: .rgbColor)
			self = .rgbOn(color: color)
		case 121000001:
			self = .rgbOff()
		//display
		case 122000000:
			self = .displayClear()
		case 122000001:
			let grid = try container.decode([UInt8].self, forKey: .ledGrid)
			self = .displayShowGrid(grid: grid)
		case 122000002:
			let image = try container.decode(miniImage.self, forKey: .ledImage)
			self = .displayShowImage(image: image)
		case 122000003:
			let text = try container.decode(String.self, forKey: .ledText)
			self = .displayShowText(text: text)
		//sound
		case 123000000:
			self = .soundOff()
		case 123000001:
			let note = try container.decode(miniSound.self, forKey: .soundNote)
			self = .soundOnNote(note: note)
		case 123000002:
			let freq = try container.decode(UInt16.self, forKey: .soundFreq)
			self = .soundOnFreq(freq: freq)

		//REQUEST/RESPONSE
		case 131000000:
			let button = try container.decode(buttonType.self, forKey: .button)
			self = .requestButtonState(button: button)
		case 131000001:
			let isPressed = try container.decode(Bool.self, forKey: .buttonValue)
			self = .respondButtonState(isPressed: isPressed)

		case 132000000:
			let pin = try container.decode(UInt16.self, forKey: .pinNumber)
			self = .requestPinState(pin: pin)
		case 132000001:
			let isPressed = try container.decode(Bool.self, forKey: .pinValue)
			self = .respondPinState(isPressed: isPressed)

		case 133000000:
			self = .requestNoise()
		case 133000001:
			let level = try container.decode(UInt16.self, forKey: .noiseValue)
			self = .respondNoise(level: level)

		case 134000000:
			self = .requestTemperature()
		case 134000001:
			let degrees = try container.decode(Int16.self, forKey: .temperatureValue)
			self = .respondTemperature(degrees: degrees)

		case 135000000:
			self = .requestBrightness()
		case 135000001:
			let level = try container.decode(UInt16.self, forKey: .brightnessValue)
			self = .respondBrightness(level: level)

		case 136000000:
			self = .requestDisplay()
		case 136000001:
			let grid = try container.decode([UInt8].self, forKey: .gridValue)
			self = .respondDisplay(grid: grid)

		//CONTROL
		case 191000000:
			self = .registerCallbacks()
		case 192000000:
			self = .start()
		case 193000000:
			self = .forever()
		case 194000000:
			let time = try container.decode(UInt16.self, forKey: .sleepTime)
			self = .sleep(time: time)
		case 195000000:
			self = .finished()

		default:
			throw CodingError.unknownValue
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: Key.self)
		switch self {

		//NOTIFICATIONS
		//buttons
		case .buttonA():
			try container.encode(111000000, forKey: .rawValue)
		case .buttonB():
			try container.encode(111000001, forKey: .rawValue)
		case .buttonAB():
			try container.encode(111000002, forKey: .rawValue)
		case .buttonALongPress():
			try container.encode(111000003, forKey: .rawValue)
		case .buttonBLongPress():
			try container.encode(111000004, forKey: .rawValue)
		case .buttonABLongPress():
			try container.encode(111000005, forKey: .rawValue)
		//pin
		case .pin(let pinNumber):
			try container.encode(112000000, forKey: .rawValue)
			try container.encode(pinNumber, forKey: .pinNumber)
		//accelerometer
		case .shake:
			try container.encode(113000000, forKey: .rawValue)
		//microphone
		case .clap:
			try container.encode(114000000, forKey: .rawValue)

		//OUTPUT
		//rgb
		case .rgbOn(let color):
			try container.encode(121000000, forKey: .rawValue)
			try container.encode(color, forKey: .rgbColor)
		case .rgbOff:
			try container.encode(121000001, forKey: .rawValue)
		//display
		case .displayClear:
			try container.encode(122000000, forKey: .rawValue)
		case .displayShowGrid(let grid):
			try container.encode(122000001, forKey: .rawValue)
			try container.encode(grid, forKey: .ledGrid)
		case .displayShowImage(let image):
			try container.encode(122000002, forKey: .rawValue)
			try container.encode(image, forKey: .ledImage)
		case .displayShowText(let text):
			try container.encode(122000003, forKey: .rawValue)
			try container.encode(text, forKey: .ledText)
		//sound
		case .soundOff:
			try container.encode(123000000, forKey: .rawValue)
		case .soundOnNote(let note):
			try container.encode(123000001, forKey: .rawValue)
			try container.encode(note, forKey: .soundNote)
		case .soundOnFreq(let freq):
			try container.encode(123000002, forKey: .rawValue)
			try container.encode(freq, forKey: .soundFreq)

		//REQUEST/RESPONSE
		case .requestButtonState(let button):
			try container.encode(131000000, forKey: .rawValue)
			try container.encode(button, forKey: .button)
		case .respondButtonState(let isPressed):
			try container.encode(131000001, forKey: .rawValue)
			try container.encode(isPressed, forKey: .buttonValue)

		case .requestPinState(let pin):
			try container.encode(132000000, forKey: .rawValue)
			try container.encode(pin, forKey: .pinNumber)
		case .respondPinState(let isPressed):
			try container.encode(132000001, forKey: .rawValue)
			try container.encode(isPressed, forKey: .pinValue)

		case .requestNoise:
			try container.encode(133000000, forKey: .rawValue)
		case .respondNoise(let level):
			try container.encode(133000001, forKey: .rawValue)
			try container.encode(level, forKey: .noiseValue)

		case .requestTemperature:
			try container.encode(134000000, forKey: .rawValue)
		case .respondTemperature(let degrees):
			try container.encode(134000001, forKey: .rawValue)
			try container.encode(degrees, forKey: .temperatureValue)

		case .requestBrightness():
			try container.encode(135000000, forKey: .rawValue)
		case .respondBrightness(let level):
			try container.encode(135000001, forKey: .rawValue)
			try container.encode(level, forKey: .brightnessValue)

		case .requestDisplay():
			try container.encode(136000000, forKey: .rawValue)
		case .respondDisplay(let grid):
			try container.encode(136000001, forKey: .rawValue)
			try container.encode(grid, forKey: .gridValue)

		//CONTROL
		case .registerCallbacks():
			try container.encode(191000000, forKey: .rawValue)
		case .start:
			try container.encode(192000000, forKey: .rawValue)
		case .forever:
			try container.encode(193000000, forKey: .rawValue)
		case .sleep(let time):
			try container.encode(194000000, forKey: .rawValue)
			try container.encode(time, forKey: .sleepTime)
		case .finished():
			try container.encode(195000000, forKey: .rawValue)
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
