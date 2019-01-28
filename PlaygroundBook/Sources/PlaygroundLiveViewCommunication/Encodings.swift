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
