extension CalliopeImage: RawRepresentable {
    
    static var all: [CalliopeImage] {
        var values: [CalliopeImage] = []
        var index:Int16 = 0
        while let element = self.init(rawValue: index) {
            values.append(element)
            index += 1
        }
        return values
    }
    
    public init?(from: String) {
        // adding "." instead of removing from input, so we know its an enum and not some "..."
        guard let type = CalliopeImage.all.first(where: { "."+String(describing:$0) == from }) else { return nil }
        self = type
    }
    
}
