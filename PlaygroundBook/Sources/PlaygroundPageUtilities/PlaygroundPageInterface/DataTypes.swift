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
	/// when minus and any of pins 0-3 are connected
	func onPin(pin: UInt16)

	//Motion
	/// when calliope is shook (not implemented yet)
	func onShake()

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

public enum miniSound: UInt16, CaseIterable {
	case A3 = 55
	case Bb3 = 58
	case B3 = 62
	case C2 = 65
	case Db2 = 69
	case D2 = 73
	case Eb2 = 78
	case E2 = 82
	case F2 = 87
	case Gb2 = 93
	case G2 = 98
	case Ab2 = 104
	case A2 = 110
	case Bb2 = 117
	case H2 = 123
	case C = 131
	case Db = 139
	case D = 147
	case Eb = 156
	case E = 165
	case F = 175
	case Gb = 185
	case G = 196
	case Ab = 208
	case A = 220
	case Bb = 233
	case H = 247
	case c´ = 262
	case db´ = 277
	case d´ = 294
	case eb´ = 311
	case e´ = 330
	case f´ = 349
	case gb´ = 370
	case g´ = 392
	case ab´ = 415
	case a´ = 440
	case bb´ = 466
	case h´ = 494
	case c´´ = 523
	case db´´ = 554
	case d´´ = 587
	case eb´´ = 622
	case e´´ = 659
	case f´´ = 698
	case gb´´ = 740
	case g´´ = 784
	case ab´´ = 831
	case a´´ = 880
	case bb´´ = 932
	case h´´ = 988
	case c´´´ = 1047
	case db´´´ = 1109
	case d´´´ = 1175
	case eb´´´ = 1245
	case e´´´ = 1319
	case f´´´ = 1397
	case gb´´´ = 1480
	case g´´´ = 1568
	case ab´´´ = 1661
	case a´´´ = 1760
}
