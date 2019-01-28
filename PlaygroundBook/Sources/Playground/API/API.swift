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

//

public enum buttonType: Int8 {
    case A = 0
    case B = 1
    case AB = 2
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

// MARK: - miniColor

public enum miniColor: String {
    case red
    case green
    case blue
    case yellow
    case black
    case darkGray
    case lightGray
    case white
    case cyan
    case magenta
    case orange
    case purple
    
    public var color: UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .green:
            return UIColor.green
        case .blue:
            return UIColor.blue
        case .yellow:
            return UIColor.yellow
        case .black:
            return UIColor.black
        case .darkGray:
            return UIColor.darkGray
        case .lightGray:
            return UIColor.lightGray
        case .white:
            return UIColor.white
        case .cyan:
            return UIColor.cyan
        case .magenta:
            return UIColor.magenta
        case .orange:
            return UIColor.orange
        case .purple:
            return UIColor.purple
        }
    }
}
 
// MARK: - miniImage

public enum miniImage: Int16 {
	case smiley = 0x00
	case sad = 0x01
	case heart = 0x02
	case arrow_left = 0x03
	case arrow_right = 0x04
	case arrow_left_right = 0x05
	case full = 0x06
	case dot = 0x07
	case small_rect = 0x08
	case large_rect = 0x09
	case double_row = 0x0a
	case tick = 0x0b
	case rock = 0x0c
	case scissors = 0x0d
	case well = 0x0e
	case flash = 0x0f
	case wave = 0x10
}

// MARK: - miniSound

public enum miniSound:UInt16 {
    case C = 262
    case D = 294
    case E = 330
    case F = 349
    case G = 392
    case A = 440
    case H = 494
    case C5 = 523
}
