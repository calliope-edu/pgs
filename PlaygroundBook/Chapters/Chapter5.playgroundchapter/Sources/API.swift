/* Wrapper for visibility in Contents.swift */
import Foundation

//MARK: protocol to implement for receiving signals from calliope

public extension Calliope {
	/// called whenever button A is pressed
	func onButtonA() {}
	/// called whenever button B is pressed
	func onButtonB() {}
	/// called whenever button A and B are pressed together
	func onButtonAB() {}
	/// called whenever button A is pressed long (1s)
	func onButtonALongPress() {}
	/// called whenever button B is pressed long (1s)
	func onButtonBLongPress() {}
	/// called whenever button A and B are pressed together (for 1s)
	func onButtonABLongPress() {}
	/// called whenever a touch pin is touched (pin numbers 0-3)
	func onPin(pin: UInt16) {}
	/// called when the calliope is shook
	func onShake() {}
	/// called at the start of the program
	func start() {}
	/// called in an endless loop
	func forever() { sleep(1) }
}

//MARK: special sleep function

public struct mini {
	/// blocks calling method for the specified time in ms
	/// - Parameter time: the sleep time in ms
	public static func sleep(_ time: UInt16) {
		sendCommand(apiCall: .sleep(time: time))
	}
}

//MARK: visual output from RGB Led

public struct rgb {

	/// sets the calliope rgb LED to a specified color
	/// - Parameter color: one of the colors predefined in the miniColor enum
	public static func on(color: miniColor) {
		sendCommand(apiCall: .rgbOnColor(color: color))
	}
	public static func on(r: UInt8, g: UInt8, b: UInt8) {
		sendCommand(apiCall: .rgbOnValues(r: r, g: g, b: b))
	}
	/// switches off the rgb LED
	public static func off() {
		sendCommand(apiCall: .rgbOff())
	}
}

//MARK: visual output on LED matrix

public struct display {
	/// the currently visible led matrix
	public static var currentGrid: [UInt8] {
		get { return sendRequest(apiCall: .requestDisplay())! }
		set { sendCommand(apiCall: .displayShowGrid(grid: newValue)) }
	}

	/// switches off all leds in the matrix
	public static func clear() {
		sendCommand(apiCall: .displayClear())
	}
	/// shows one of the predifined images in enum miniImage
	public static func show(image: miniImage) {
		sendCommand(apiCall: .displayShowImage(image: image))
	}
	/// scrolls a text over the display
	public static func show(text: String) {
		sendCommand(apiCall: .displayShowText(text: text))
	}
	/// scrolls a number over the display
	public static func show(number: UInt16) {
		sendCommand(apiCall: .displayShowText(text: String(number)))
	}
	/// switches on the leds where there is 1 in the array
	/// (leds numbered left to right, top to bottom)
	public static func show(grid: [UInt8]) {
		sendCommand(apiCall: .displayShowGrid(grid: grid))
	}

	/// all leds for which true is set are switched on, all others off
	/// - Parameter leds: five tuples of five values, one tuple for each row and one value per column
	public static func show(leds: (
		(Bool, Bool, Bool, Bool, Bool),
		(Bool, Bool, Bool, Bool, Bool),
		(Bool, Bool, Bool, Bool, Bool),
		(Bool, Bool, Bool, Bool, Bool),
		(Bool, Bool, Bool, Bool, Bool))) {
		let toInt = { (b: Bool) -> UInt8 in b ? 1 : 0 }
		let rowToInt = { (b: (Bool, Bool, Bool, Bool, Bool)) -> [UInt8] in [toInt(b.0), toInt(b.1), toInt(b.2), toInt(b.3), toInt(b.4)] }
		sendCommand(apiCall: .displayShowGrid(grid: rowToInt(leds.0) + rowToInt(leds.1) + rowToInt(leds.2) + rowToInt(leds.3) + rowToInt(leds.4)))
	}
}

//MARK: sound output

public struct sound {
	/// switches on speaker with note predefined in miniSound
	public static func on(note: miniSound) {
		sendCommand(apiCall: .soundOnNote(note: note))
	}
	/// switches on speaker with arbitrary frequency
	public static func on(frequency: UInt16) {
		sendCommand(apiCall: .soundOnFreq(freq: frequency))
	}
	/// switches speaker off
	public static func off() {
		sendCommand(apiCall: .soundOff())
	}
}

//MARK: inputs from calliope

public struct io {
	/// creates a button with the state that
	/// the corresponding button on the calliope has at instanciation time
	public class button {
		public var isPressed: Bool = false
		public init(_ type: buttonType) {
			isPressed = sendRequest(apiCall: .requestButtonState(button: type))!
		}
	}
	/// creates a button with the state that
	/// the corresponding pin on the calliope has at instanciation time
	public class pin {
		public var isPressed: Bool = false
		public init(_ type: UInt16) {
			isPressed = sendRequest(apiCall: .requestPinState(pin: type))!
		}
	}
	/// requests how loud the sound is that the microphone receives
	public static var noise: UInt16 {
		return sendRequest(apiCall: .requestNoise())!
	}
	/// requests how bright the light is shining onto the calliope
	public static var brightness: UInt16 {
		return sendRequest(apiCall: .requestBrightness())!
	}
	/// requests the temperature that the calliope measures
	public static var temperature: Int16 {
		return sendRequest(apiCall: .requestTemperature())!
	}
}

//MARK: - random number generation

/// Generates a uniformly distributed integer random number
/// - Parameter range: the range (start and end inclusive) for the random number
/// - Returns: a random integer number in the specified range
public func random(_ range:CountableClosedRange<UInt16>) -> UInt16 {
	return UInt16( arc4random_uniform(UInt32(range.upperBound)) + UInt32(range.lowerBound) )
}
