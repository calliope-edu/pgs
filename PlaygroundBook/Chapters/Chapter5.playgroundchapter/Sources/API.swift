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
	/// called when the microphone registers a clap
	func onClap() {}
	/// called at the start of the program
	func start() {}
	/// called in an endless loop
	func forever() { sleep(1) }
}

//MARK: special sleep function

public class mini {
	/// blocks calling method for the specified time in ms
	/// - Parameter time: the sleep time in ms
	public class func sleep(_ time: UInt16) {
		sendCommand(apiCall: .sleep(time: time))
	}
}

//MARK: visual output from RGB Led

public class rgb {

	/// sets the calliope rgb LED to a specified color
	/// - Parameter color: one of the colors predefined in the miniColor enum
	public class func on(color: miniColor) {
		sendCommand(apiCall: .rgbOn(color: color))
	}
	/// switches off the rgb LED
	public class func off() {
		sendCommand(apiCall: .rgbOff())
	}
}

//MARK: visual output on LED matrix

public class display {
	/// the currently visible led matrix
	public var currentGrid: [UInt8] {
		get { return sendRequest(apiCall: .requestDisplay())! }
		set { sendCommand(apiCall: .displayShowGrid(grid: newValue)) }
	}

	/// switches off all leds in the matrix
	public class func clear() {
		sendCommand(apiCall: .displayClear())
	}
	/// shows one of the predifined images in enum miniImage
	public class func show(image: miniImage) {
		sendCommand(apiCall: .displayShowImage(image: image))
	}
	/// scrolls a text over the display
	public class func show(text: String) {
		sendCommand(apiCall: .displayShowText(text: text))
	}
	/// scrolls a number over the display
	public class func show(number: UInt16) {
		sendCommand(apiCall: .displayShowText(text: String(number)))
	}
	/// switches on the leds where there is 1 in the array
	/// (leds numbered left to right, top to bottom)
	public class func show(grid: [UInt8]) {
		sendCommand(apiCall: .displayShowGrid(grid: grid))
	}
}

//MARK: sound output

public class sound {
	/// switches on speaker with note predefined in miniSound
	public class func on(note: miniSound) {
		sendCommand(apiCall: .soundOnNote(note: note))
	}
	/// switches on speaker with arbitrary frequency
	public class func on(frequency: UInt16) {
		sendCommand(apiCall: .soundOnFreq(freq: frequency))
	}
	/// switches speaker off
	public class func off() {
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
