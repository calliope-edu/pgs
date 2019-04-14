//
//  DataTypes.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 03.02.19.
//

//MARK: protocol to implement for receiving signals from calliope

public protocol Calliope {
	//Buttons
	/// called whenever button A is pressed
	func onButtonA()
	/// called whenever button B is pressed
	func onButtonB()
	/// called whenever button A and B are pressed together
	func onButtonAB()
	/// called whenever button A is pressed long (1s)
	func onButtonALongPress()
	/// called whenever button B is pressed long (1s)
	func onButtonBLongPress()
	/// called whenever button A and B are pressed together (for 1s)
	func onButtonABLongPress()

	//Pins
	/// called whenever a touch pin is touched (pin numbers 0-3)
	func onPin(pin: UInt16)
	/// called whenever a touch pin stays touched for some time
	func onPinLongPress(pin: UInt16)

	//Accelerometer
	/// called when the calliope is shook
	func onShake()

	//Program flow
	/// called at the start of the program, as first method.
	func start()
	/// called over and over again, like a while(true) loop.
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
	case C = 65
	case Db = 69
	case D = 73
	case Eb = 78
	case E = 82
	case F = 87
	case Gb = 93
	case G = 98
	case Ab = 104
	case A = 110
	case B = 117
	case H = 123
	case c = 131
	case db = 139
	case d = 147
	case eb = 156
	case e = 165
	case f = 175
	case gb = 185
	case g = 196
	case ab = 208
	case a = 220
	case b = 233
	case h = 247
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
	case b´ = 466
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
	case b´´ = 932
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
	case b´´´ = 1865
	case h´´´ = 1976
	case c´´´´ = 2093
}
