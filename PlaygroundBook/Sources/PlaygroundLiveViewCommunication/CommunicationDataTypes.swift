//
//  CommunicationDataTypes.swift
//  PlaygroundBook
//
//  Created by Tassilo Karge on 28.01.19.
//

import UIKit

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
