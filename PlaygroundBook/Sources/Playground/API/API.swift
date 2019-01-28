/* Wrapper for visibility in Contents.swift */
import Foundation
import UIKit

@objc protocol Calliope {
	//Buttons
	/// when button A gets pressed
	@objc optional func onButtonA()
	/// when button B gets pressed
	@objc optional func onButtonB()
	/// when button A and B are pressed together
	@objc optional func onButtonAB()
	/// when button A is pressed for some seconds
	@objc optional func onButtonALongPress()
	/// when button B is pressed for some seconds
	@objc optional func onButtonBLongPress()
	/// when button A and B are pressed for some seconds
	@objc optional func onButtonABLongPress()

	//Pins
	/// when minus and any of pins 1-4 are connected (not implemented yet)
	@objc optional func onPin(pin:UInt16)

	//Motion
	/// when calliope is shook (not implemented yet)
	@objc optional func onShake()

	//Sound
	/// when calliope recognizes loud sound (not implemented yet)
	@objc optional func onClap()

	//control flow
	/// executed when calliope is connected
	@objc optional func start()
	/// executed over and over again
	@objc optional func forever()
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
    public class func sleep(_ time: UInt16) {}
}

//

public class rgb {
    public class func on(color: miniColor) {}
    public class func off() {}
}

//

public class display {
    public class func clear() {}
    public class func show(image: miniImage) {}
    public class func show(text: String) {}
    public class func show(number: UInt16) {}
    public class func show(grid: [UInt8]) {}
}

//

public class sound {
    public class func on(note: miniSound) {}
    public class func on(frequency: UInt16) {}
    public class func off() {}
}

public struct io {
    public class button {
        public var isPressed:Bool = false
        public init(_ type: buttonType) {}
    }
    public class pin {
        public var isPressed:Bool = false
        public init(_ type: UInt) {}
    }

    public static var noise: UInt16 = 42
    public static var brightness: UInt16 = 42
	public static var temperature: Int16 = 42
}

//

public func random(_ range:CountableClosedRange<UInt16>) -> UInt16 {
    return UInt16( arc4random_uniform(UInt32(range.upperBound)) + UInt32(range.lowerBound) )
}
