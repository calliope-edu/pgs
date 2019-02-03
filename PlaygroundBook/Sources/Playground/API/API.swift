/* Wrapper for visibility in Contents.swift */
import Foundation
import UIKit

public protocol Calliope {
	//Buttons
	/// when button A gets pressed
	func onButtonA()
	/// when button B gets pressed
	func onButtonB()
	/// when button A and B are pressed together
	func onButtonAB()
	/// when button A is pressed for some seconds
	func onButtonALongPress()
	/// when button B is pressed for some seconds
	func onButtonBLongPress()
	/// when button A and B are pressed for some seconds
	func onButtonABLongPress()

	//Pins
	/// when minus and any of pins 1-4 are connected (not implemented yet)
	func onPin(pin:UInt16)

	//Motion
	/// when calliope is shook (not implemented yet)
	func onShake()

	//Sound
	/// when calliope recognizes loud sound (not implemented yet)
	func onClap()

	//control flow
	/// executed when calliope is connected
	func start()
	/// executed over and over again
	func forever()
}

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

///calliope for api callbacks (e.g. when button is pressed, temperature changed, ...)
public var myCalliope: Calliope? {
	didSet {
		//register for callbacks
		PlayGroundManager.shared.sendWithoutResponse(apiCall: .registerCallbacks())
		//execute start once (if it exists)
		myCalliope?.start()
		//start the calls to "forever" after a slight delay
		PlayGroundManager.shared.startForever()
	}
}

public func playgroundPrologue() {
    PlayGroundManager.shared.setup()
}

public func playgroundEpilogue(_ block: AssessmentBlock? = nil) {
    if let block = block {
        PlayGroundManager.shared.registerAssessment(block)
    }
    PlayGroundManager.shared.run()
}

// umbrella API

public class mini {
    public class func sleep(_ time: UInt16) {
		PlayGroundManager.shared.sendWithoutResponse(apiCall: .sleep(time: time))
	}
}

//

public class rgb {
    public class func on(color: miniColor) {
		PlayGroundManager.shared.sendWithoutResponse(apiCall: .rgbOn(color: color))
	}
    public class func off() {
		PlayGroundManager.shared.sendWithoutResponse(apiCall: .rgbOff())
	}
}

//

public class display {
    public class func clear() {
		PlayGroundManager.shared.sendWithoutResponse(apiCall: .displayClear())
	}
    public class func show(image: miniImage) {
		PlayGroundManager.shared.sendWithoutResponse(apiCall: .displayShowImage(image: image))
	}
    public class func show(text: String) {
		PlayGroundManager.shared.sendWithoutResponse(apiCall: .displayShowText(text: text))
	}
    public class func show(number: UInt16) {
		PlayGroundManager.shared.sendWithoutResponse(apiCall: .displayShowText(text: String(number)))
	}
    public class func show(grid: [UInt8]) {
		PlayGroundManager.shared.sendWithoutResponse(apiCall: .displayShowGrid(grid: grid))
	}
}

//

public class sound {
    public class func on(note: miniSound) {
		PlayGroundManager.shared.sendWithoutResponse(apiCall: .soundOnNote(note: note))
	}
    public class func on(frequency: UInt16) {
		PlayGroundManager.shared.sendWithoutResponse(apiCall: .soundOnFreq(freq: frequency))
	}
    public class func off() {
		PlayGroundManager.shared.sendWithoutResponse(apiCall: .soundOff())
	}
}

public struct io {
    public class button {
        public var isPressed: Bool = false
        public init(_ type: buttonType) {
			isPressed = PlayGroundManager.shared.send(apiCall: .requestButtonState(button: type))!
		}
    }
    public class pin {
        public var isPressed: Bool = false
        public init(_ type: UInt) {
			isPressed = PlayGroundManager.shared.send(apiCall: .requestPinState(pin: type))!
		}
    }
	public static var noise: UInt16 {
		return PlayGroundManager.shared.send(apiCall: .requestNoise())!
	}
	public static var brightness: UInt16 {
		return PlayGroundManager.shared.send(apiCall: .requestBrightness())!
	}
	public static var temperature: Int16 {
		return PlayGroundManager.shared.send(apiCall: .requestTemperature())!
	}
}

//

public func random(_ range:CountableClosedRange<UInt16>) -> UInt16 {
    return UInt16( arc4random_uniform(UInt32(range.upperBound)) + UInt32(range.lowerBound) )
}
