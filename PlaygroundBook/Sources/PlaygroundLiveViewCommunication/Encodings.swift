//
//  CommunicationDataTypes.swift
//  PlaygroundBook
//
//  Created by Tassilo Karge on 28.01.19.
//

extension miniImage: RawRepresentable {
    
    static var all: [miniImage] {
        var values: [miniImage] = []
        var index:Int16 = 0
        while let element = self.init(rawValue: index) {
            values.append(element)
            index += 1
        }
        return values
    }
    
    public init?(from: String) {
        // adding "." instead of removing from input, so we know its an enum and not some "..."
        guard let type = miniImage.all.first(where: { "."+String(describing:$0) == from }) else { return nil }
        self = type
    }
}

extension miniImage: Codable {}

extension miniImage {
	public var grid: [UInt8] {
		switch self {
		case .smiley:
			return [0, 0, 0, 0, 0,
					0, 1, 0, 1, 0,
					0, 0, 0, 0, 0,
					1, 0, 0, 0, 1,
					0, 1, 1, 1, 0]
		case .sad:
			return [0, 0, 0, 0, 0,
					0, 1, 0, 1, 0,
					0, 0, 0, 0, 0,
					0, 1, 1, 1, 0,
					1, 0, 0, 0, 1]
		case .heart:
			return [0, 1, 0, 1, 0,
					1, 1, 1, 1, 1,
					1, 1, 1, 1, 1,
					0, 1, 1, 1, 0,
					0, 0, 1, 0, 0]
		case .arrow_left:
			return [0, 0, 1, 0, 0,
					0, 1, 0, 0, 0,
					1, 1, 1, 1, 1,
					0, 1, 0, 0, 0,
					0, 0, 1, 0, 0]
		case .arrow_right:
			return [0, 0, 1, 0, 0,
					0, 0, 0, 1, 0,
					1, 1, 1, 1, 1,
					0, 0, 0, 1, 0,
					0, 0, 1, 0, 0]
		case .arrow_left_right:
			return [0, 0, 0, 0, 0,
					0, 1, 0, 1, 0,
					1, 1, 1, 1, 1,
					0, 1, 0, 1, 0,
					0, 0, 0, 0, 0]
		case .full:
			return [1, 1, 1, 1, 1,
					1, 1, 1, 1, 1,
					1, 1, 1, 1, 1,
					1, 1, 1, 1, 1,
					1, 1, 1, 1, 1]
		case .dot:
			return [0, 0, 0, 0, 0,
					0, 0, 0, 0, 0,
					0, 0, 1, 0, 0,
					0, 0, 0, 0, 0,
					0, 0, 0, 0, 0]
		case .small_rect:
			return [0, 0, 0, 0, 0,
					0, 1, 1, 1, 0,
					0, 1, 0, 1, 0,
					0, 1, 1, 1, 0,
					0, 0, 0, 0, 0]
		case .large_rect:
			return [1, 1, 1, 1, 1,
					1, 0, 0, 0, 1,
					1, 0, 0, 0, 1,
					1, 0, 0, 0, 1,
					1, 1, 1, 1, 1]
		case .double_row:
			return [0, 1, 1, 0, 0,
					0, 1, 1, 0, 0,
					0, 1, 1, 0, 0,
					0, 1, 1, 0, 0,
					0, 1, 1, 0, 0]
		case .tick:
			return [0, 0, 0, 0, 0,
					0, 0, 0, 0, 1,
					0, 0, 0, 1, 0,
					1, 0, 1, 0, 0,
					0, 1, 0, 0, 0]
		case .rock:
			return [0, 0, 0, 0, 0,
					0, 1, 1, 1, 0,
					0, 1, 1, 1, 0,
					0, 1, 1, 1, 0,
					0, 0, 0, 0, 0]
		case .scissors:
			return [1, 0, 0, 0, 1,
					0, 1, 0, 1, 0,
					0, 0, 1, 0, 0,
					0, 1, 0, 1, 0,
					1, 0, 0, 0, 1]
		case .well:
			return [0, 1, 1, 1, 0,
					1, 0, 0, 0, 1,
					1, 0, 0, 0, 1,
					1, 0, 0, 0, 1,
					0, 1, 1, 1, 0]
		case .flash:
			return [0, 0, 1, 1, 0,
					0, 1, 1, 0, 0,
					1, 1, 1, 1, 1,
					0, 0, 1, 1, 0,
					0, 1, 1, 0, 0]
		case .wave:
			return [0, 0, 0, 0, 0,
					0, 1, 0, 0, 0,
					1, 0, 1, 0, 1,
					0, 0, 0, 1, 0,
					0, 0, 0, 0, 0]
		}
	}
}

extension miniSound: RawRepresentable {
	static var all: [miniSound] = [ .C, .D, .E, .F, .G, .A, .H, .C5]

	public init?(from: String) {
		// adding "." instead of removing from input, so we know its an enum and not some "..."
		guard let type = miniSound.all.first(where: { "."+String(describing:$0) == from }) else { return nil }
		self = type
	}
}

extension miniSound: Codable {}


extension miniColor: RawRepresentable {
	static var all: [miniColor] = [.red, .green, .blue, .yellow, .black, .darkGray, .lightGray, .white, .cyan, .magenta, .orange, .purple]

	public init?(from: String) {
		// adding "." instead of removing from input, so we know its an enum and not some "..."
		guard let type = miniColor.all.first(where: { "."+String(describing:$0) == from }) else { return nil }
		self = type
	}
}

extension miniColor: Codable {}


extension buttonType: RawRepresentable {}
extension buttonType: Codable {}
