//
//  ApiEncodings.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 23.02.19.
//

import Foundation

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
			let pinNumber = try container.decode(UInt16.self, forKey: .pinNumber)
			self = .pin(pin: pinNumber)
		//accelerometer
		case 11300:
			self = .shake()
		//microphone
		case 11400:
			self = .clap()

		//OUTPUT
		//rgb
		/*case 12100:
			let color = try container.decode(miniColor.self, forKey: .rgbColor)
			self = .rgbOn(color: color)
		case 12101:
			self = .rgbOff()*/
		//display
		case 12200:
			self = .displayClear()
		case 12201:
			let grid = try container.decode([UInt8].self, forKey: .ledGrid)
			self = .displayShowGrid(grid: grid)
		case 12202:
			let image = try container.decode(miniImage.self, forKey: .ledImage)
			self = .displayShowImage(image: image)
		case 12203:
			let text = try container.decode(String.self, forKey: .ledText)
			self = .displayShowText(text: text)
		//sound
		/*case 12300:
			self = .soundOff()
		case 12301:
			let note = try container.decode(miniSound.self, forKey: .soundNote)
			self = .soundOnNote(note: note)
		case 12302:
			let freq = try container.decode(UInt16.self, forKey: .soundFreq)
			self = .soundOnFreq(freq: freq)*/

		//REQUEST/RESPONSE
		case 13100:
			let button = try container.decode(buttonType.self, forKey: .button)
			self = .requestButtonState(button: button)
		case 13101:
			let isPressed = try container.decode(Bool.self, forKey: .buttonValue)
			self = .respondButtonState(isPressed: isPressed)

		case 13200:
			let pin = try container.decode(UInt16.self, forKey: .pinNumber)
			self = .requestPinState(pin: pin)
		case 13201:
			let isPressed = try container.decode(Bool.self, forKey: .pinValue)
			self = .respondPinState(isPressed: isPressed)

		case 13300:
			self = .requestNoise()
		case 13301:
			let level = try container.decode(UInt16.self, forKey: .noiseValue)
			self = .respondNoise(level: level)

		case 13400:
			self = .requestTemperature()
		case 13401:
			let degrees = try container.decode(Int16.self, forKey: .temperatureValue)
			self = .respondTemperature(degrees: degrees)

		case 13500:
			self = .requestBrightness()
		case 13501:
			let level = try container.decode(UInt16.self, forKey: .brightnessValue)
			self = .respondBrightness(level: level)

		case 13600:
			self = .requestDisplay()
		case 13601:
			let grid = try container.decode([UInt8].self, forKey: .gridValue)
			self = .respondDisplay(grid: grid)

		//CONTROL
		case 19100:
			self = .registerCallbacks()
		case 19200:
			self = .start()
		case 19300:
			self = .forever()
		case 19400:
			let time = try container.decode(UInt16.self, forKey: .sleepTime)
			self = .sleep(time: time)
		case 19500:
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
			try container.encode(11100, forKey: .rawValue)
		case .buttonB():
			try container.encode(11101, forKey: .rawValue)
		case .buttonAB():
			try container.encode(11102, forKey: .rawValue)
		case .buttonALongPress():
			try container.encode(11103, forKey: .rawValue)
		case .buttonBLongPress():
			try container.encode(11104, forKey: .rawValue)
		case .buttonABLongPress():
			try container.encode(11105, forKey: .rawValue)
		//pin
		case .pin(let pinNumber):
			try container.encode(11200, forKey: .rawValue)
			try container.encode(pinNumber, forKey: .pinNumber)
		//accelerometer
		case .shake:
			try container.encode(11300, forKey: .rawValue)
		//microphone
		case .clap:
			try container.encode(11400, forKey: .rawValue)

		//OUTPUT
		//rgb
		/*case .rgbOn(let color):
			try container.encode(12100, forKey: .rawValue)
			try container.encode(color, forKey: .rgbColor)
		case .rgbOff:
			try container.encode(12101, forKey: .rawValue)*/
		//display
		case .displayClear:
			try container.encode(12200, forKey: .rawValue)
		case .displayShowGrid(let grid):
			try container.encode(12201, forKey: .rawValue)
			try container.encode(grid, forKey: .ledGrid)
		case .displayShowImage(let image):
			try container.encode(12202, forKey: .rawValue)
			try container.encode(image, forKey: .ledImage)
		case .displayShowText(let text):
			try container.encode(12203, forKey: .rawValue)
			try container.encode(text, forKey: .ledText)
		//sound
		/*case .soundOff:
			try container.encode(12300, forKey: .rawValue)
		case .soundOnNote(let note):
			try container.encode(12301, forKey: .rawValue)
			try container.encode(note, forKey: .soundNote)
		case .soundOnFreq(let freq):
			try container.encode(12302, forKey: .rawValue)
			try container.encode(freq, forKey: .soundFreq)*/

		//REQUEST/RESPONSE
		case .requestButtonState(let button):
			try container.encode(13100, forKey: .rawValue)
			try container.encode(button, forKey: .button)
		case .respondButtonState(let isPressed):
			try container.encode(13101, forKey: .rawValue)
			try container.encode(isPressed, forKey: .buttonValue)

		case .requestPinState(let pin):
			try container.encode(13200, forKey: .rawValue)
			try container.encode(pin, forKey: .pinNumber)
		case .respondPinState(let isPressed):
			try container.encode(13201, forKey: .rawValue)
			try container.encode(isPressed, forKey: .pinValue)

		case .requestNoise:
			try container.encode(13300, forKey: .rawValue)
		case .respondNoise(let level):
			try container.encode(13301, forKey: .rawValue)
			try container.encode(level, forKey: .noiseValue)

		case .requestTemperature:
			try container.encode(13400, forKey: .rawValue)
		case .respondTemperature(let degrees):
			try container.encode(13401, forKey: .rawValue)
			try container.encode(degrees, forKey: .temperatureValue)

		case .requestBrightness():
			try container.encode(13500, forKey: .rawValue)
		case .respondBrightness(let level):
			try container.encode(13501, forKey: .rawValue)
			try container.encode(level, forKey: .brightnessValue)

		case .requestDisplay():
			try container.encode(13600, forKey: .rawValue)
		case .respondDisplay(let grid):
			try container.encode(13601, forKey: .rawValue)
			try container.encode(grid, forKey: .gridValue)

		//CONTROL
		case .registerCallbacks():
			try container.encode(19100, forKey: .rawValue)
		case .start:
			try container.encode(19200, forKey: .rawValue)
		case .forever:
			try container.encode(19300, forKey: .rawValue)
		case .sleep(let time):
			try container.encode(19400, forKey: .rawValue)
			try container.encode(time, forKey: .sleepTime)
		case .finished():
			try container.encode(19500, forKey: .rawValue)
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
