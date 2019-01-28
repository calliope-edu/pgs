//
//  ApiCalls.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 28.01.19.
//

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
	case soundOff()
	case soundOnNote(note: miniSound)
	case soundOnFreq(freq: UInt16)
	case requestButtonState(button: buttonType)
	case respondButtonState(isPressed: Bool)
	case requestPinState(pin: UInt)
	case respondPinState(isPressed: Bool)
	case requestNoise()
	case respondNoise(level: UInt16)
	case requestTemperature()
	case respondTemperature(degrees: Int16)

	//other controls
	case sleep(time: UInt16)
}

extension ApiCall: Codable {
	enum Key: CodingKey {
		case rawValue
		case pinNumber
		case rgbColor
		case ledGrid
		case ledImage
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
			/* TODO: all the rest

			case .soundOnNote(let note):
			try container.encode(17, forKey: .rawValue)
			try container.encode(note, forKey: .soundNote)
			case .soundOnFreq(let freq):
			try container.encode(18, forKey: .rawValue)
			try container.encode(freq, forKey: .soundFreq)
			case .requestButtonState(let button):
			try container.encode(19, forKey: .rawValue)
			try container.encode(button, forKey: .button)
			case .respondButtonState(let button, let isPressed):
			try container.encode(20, forKey: .rawValue)
			try container.encode(button, forKey: .button)
			try container.encode(isPressed, forKey: .buttonValue)
			case .requestPinState(let pin):
			try container.encode(21, forKey: .rawValue)
			try container.encode(pin, forKey: .pinNumber)
			case .respondPinState(let pin, let isPressed):
			try container.encode(22, forKey: .rawValue)
			try container.encode(pin, forKey: .pinNumber)
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
			try container.encode(time, forKey: .sleepTime)*/
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
		}
	}
}
