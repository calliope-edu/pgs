/* Wrapper for visibility in Contents.swift */
import Foundation

//MARK: special sleep function

public class mini {
	public class func sleep(_ time: UInt16) {}
}

//MARK: visual output from RGB Led

public class rgb {
	public class func on(color: miniColor) {}
	public class func off() {}
}

//MARK: visual output on LED matrix

public class display {
	public class func clear() {}
	public class func show(image: miniImage) {}
	public class func show(text: String) {}
	public class func show(number: UInt16) {}
	public class func show(grid: [UInt8]) {}
}

//MARK: sound output

public class sound {
	public class func on(note: miniSound) {}
	public class func on(frequency: UInt16) {}
	public class func off() {}
}

//MARK: inputs from calliope

public struct io {
	public class button {
		public var isPressed: Bool = false
	}
	public class pin {
		public var isPressed: Bool = false
	}
	public static var noise: UInt16 = 42
	public static var brightness: UInt16 = 42
	public static var temperature: Int16 = 42
}

//MARK: - random number generation

public func random(_ range:CountableClosedRange<UInt16>) -> UInt16 {
	return UInt16( arc4random_uniform(UInt32(range.upperBound)) + UInt32(range.lowerBound) )
}
