/* Wrapper for visibility in Contents.swift */
import Foundation

//MARK: protocol to implement for receiving signals from calliope

public extension Calliope {
	func onButtonA() {}
	func onButtonB() {}
	func onButtonAB() {}
	func onButtonALongPress() {}
	func onButtonBLongPress() {}
	func onButtonABLongPress() {}
	func onPin(pin:UInt16) {}
	func onShake() {}
	func onClap() {}
	func start() {}
	func forever() { sleep(1) }
}

//MARK: special sleep function

public class mini {
	public class func sleep(_ time: UInt16) {
		sendWithoutResponse(apiCall: .sleep(time: time))
	}
}

//MARK: visual output from RGB Led

public class rgb {
	public class func on(color: miniColor) {
		sendWithoutResponse(apiCall: .rgbOn(color: color))
	}
	public class func off() {
		sendWithoutResponse(apiCall: .rgbOff())
	}
}

//MARK: visual output on LED matrix

public class display {
	public class func clear() {
		sendWithoutResponse(apiCall: .displayClear())
	}
	public class func show(image: miniImage) {
		sendWithoutResponse(apiCall: .displayShowImage(image: image))
	}
	public class func show(text: String) {
		sendWithoutResponse(apiCall: .displayShowText(text: text))
	}
	public class func show(number: UInt16) {
		sendWithoutResponse(apiCall: .displayShowText(text: String(number)))
	}
	public class func show(grid: [UInt8]) {
		sendWithoutResponse(apiCall: .displayShowGrid(grid: grid))
	}
}

//MARK: sound output

public class sound {
	public class func on(note: miniSound) {
		sendWithoutResponse(apiCall: .soundOnNote(note: note))
	}
	public class func on(frequency: UInt16) {
		sendWithoutResponse(apiCall: .soundOnFreq(freq: frequency))
	}
	public class func off() {
		sendWithoutResponse(apiCall: .soundOff())
	}
}

//MARK: inputs from calliope

public struct io {
	public class button {
		public var isPressed: Bool = false
		public init(_ type: buttonType) {
			isPressed = send(apiCall: .requestButtonState(button: type))!
		}
	}
	public class pin {
		public var isPressed: Bool = false
		public init(_ type: UInt) {
			isPressed = send(apiCall: .requestPinState(pin: type))!
		}
	}
	public static var noise: UInt16 {
		return send(apiCall: .requestNoise())!
	}
	public static var brightness: UInt16 {
		return send(apiCall: .requestBrightness())!
	}
	public static var temperature: Int16 {
		return send(apiCall: .requestTemperature())!
	}
}

//MARK: - random number generation

public func random(_ range:CountableClosedRange<UInt16>) -> UInt16 {
	return UInt16( arc4random_uniform(UInt32(range.upperBound)) + UInt32(range.lowerBound) )
}
