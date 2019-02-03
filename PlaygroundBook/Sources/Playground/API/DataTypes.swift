//
//  DataTypes.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 03.02.19.
//

//MARK: protocol to implement for receiving signals from calliope

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

//MARK: - buttonType

public enum buttonType: Int8 {
	case A = 0
	case B = 1
	case AB = 2
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
