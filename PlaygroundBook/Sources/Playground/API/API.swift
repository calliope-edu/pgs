/* Wrapper for visibility in Contents.swift */
import Foundation
import UIKit

@objc protocol Calliope {
	@objc optional

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
    public class func sleep(_ time:UInt16) {}
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

public enum buttonType {
    case A
    case B
    case AB
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
    public static var temperature: UInt16 = 42
}

//

public func random(_ range:CountableClosedRange<UInt16>) -> UInt16 {
    return UInt16( arc4random_uniform(UInt32(range.upperBound)) + UInt32(range.lowerBound) )
}

// MARK: - miniColor

public enum miniColor:String {
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

extension miniColor: RawRepresentable {
    static var all: [miniColor] = [.red, .green, .blue, .yellow, .black, .darkGray, .lightGray, .white, .cyan, .magenta, .orange, .purple]
    
    public init?(from: String) {
        // adding "." instead of removing from input, so we know its an enum and not some "..."
        guard let type = miniColor.all.first(where: { "."+String(describing:$0) == from }) else { return nil }
        self = type
    }
}
 
// MARK: - miniImage

public enum miniImage {
    case smiley
    case sad
    case heart
    case arrow_left
    case arrow_right
    case arrow_left_right
    case full
    case dot
    case small_rect
    case large_rect
    case double_row
    case tick
    case rock
    case scissors
    case well
    case flash
    case wave
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

extension miniSound: RawRepresentable {
    static var all: [miniSound] = [ .C, .D, .E, .F, .G, .A, .H, .C5]
    
    public init?(from: String) {
        // adding "." instead of removing from input, so we know its an enum and not some "..."
        guard let type = miniSound.all.first(where: { "."+String(describing:$0) == from }) else { return nil }
        self = type
    }
}
