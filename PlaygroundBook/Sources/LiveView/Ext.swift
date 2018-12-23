import UIKit

extension String: Error {}

func LOG(_ message: Any, fileName: String = #file, lineNumber: Int = #line) {
    let lastPathComponent = (fileName as NSString).lastPathComponent
    let filenameOnly = lastPathComponent.components(separatedBy: ".")[0]
    let extendedMessage = "\(filenameOnly):\(lineNumber)| \(message)"

    print(extendedMessage)
}

func ERR(_ message: Any, fileName: String = #file, lineNumber: Int = #line) {
    let lastPathComponent = (fileName as NSString).lastPathComponent
    let filenameOnly = lastPathComponent.components(separatedBy: ".")[0]
    let extendedMessage = "\(filenameOnly):\(lineNumber) \(message)"

    print(extendedMessage)
}

extension Character {
    var ascii: UInt8 {
        return UInt8(String(self).unicodeScalars.first!.value)
    }
}

extension String {
    var ascii: [UInt8] {
        return unicodeScalars.filter { $0.isASCII }.map { UInt8($0.value) }
    }
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }

    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
}

extension UInt16 {
    func hi() -> UInt8 {
        return UInt8((self >> 8) & 0xff)
    }

    func lo() -> UInt8 {
        return UInt8(self & 0xff)
    }
}

extension Int {
    func hi() -> UInt8 {
        return UInt8((self >> 8) & 0xff)
    }

    func lo() -> UInt8 {
        return UInt8(self & 0xff)
    }
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let hexDigits = Array((options.contains(.upperCase) ? "0123456789ABCDEF" : "0123456789abcdef").utf16)
        var chars: [unichar] = []
        chars.reserveCapacity(2 * count)
        for byte in self {
            chars.append(hexDigits[Int(byte / 16)])
            chars.append(hexDigits[Int(byte % 16)])
        }
        return String(utf16CodeUnits: chars, count: chars.count)
    }
}

func int8(_ i: UInt8) -> Int8 {
    return i > Int8.max
        ? Int8(Int(i) - Int(0x100))
        : Int8(i)
}

func uint8(_ i: Int8) -> UInt8 {
    if i < Int8.min || i > Int8.max {
        fatalError("out of range")
    }
    return UInt8(bitPattern: Int8(i))
}

func uint16(_ i: Int) -> UInt16 {
    if i < Int16.min || i > Int16.max {
        fatalError("out of range")
    }
    return UInt16(bitPattern: Int16(i))
}

// extension Array {
// static func <<< ( left: [UInt8], right: [UInt8]) -> [UInt8] {
//    return left + right
// }
//
// }

// func <<< (var outputStream: OutputStream, streamable: Streamable) -> OutputStream {
//    // Note: It seems like streamable.writeTo(&outputStream) should work, but playground crashes,
//    //       so we write to a string and then output the string
//    var outputString = ""
//    streamable.writeTo(&outputString)
//    outputStream.write(outputString)
//    return outputStream
// }
