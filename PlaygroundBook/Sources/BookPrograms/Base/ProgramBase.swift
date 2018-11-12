import UIKit

public struct ProgramBuildResult: Codable {
    var code: [UInt8] = []
    var methods: [UInt16] = [
        0xffff,
        0xffff,
        0xffff,
        0xffff,
        0xffff,
    ]

    func length() -> Int {
        let bytesCode = code.count * 1
        let bytesMethods = methods.count * 2
        return bytesCode + bytesMethods
    }

    func toDebug() -> String {
        let parser = ProgramParser(code: code)
        let pass1 = parser.pass1()
        let pass2 = parser.pass2()
        return
            pass1.joined(separator: "\n") + "\n" +
            pass2.joined(separator: "\n")
    }
}

public protocol Program {
    func build() -> ProgramBuildResult
}

public enum Register: UInt8 {
    case r0 = 0, r1, r2, r3, r4
}

public enum Button: Int16 {
    case a = 1, b, ab
}

public enum Gesture: Int16 {
    case shake = 0x001b
}

public enum NotificationAddress: Int16 {
    case display = 0x0000
    case buttonA = 0x0001
    case buttonB = 0x0002
    case buttonAB = 0x0003
    case rgb = 0x004
    case sound = 0x005
    case pin = 0x006
    case shake = 0x007
    case temperature = 0x008
    case noise = 0x009
    case light = 0x00a
}

public class ProgramBase {
    func beq(onTrue: [UInt8], onFalse: [UInt8] = []) -> [UInt8] {
        return
            beq(Int8(onFalse.count + 2)) +
            onFalse +
            bra(Int8(onTrue.count)) +
            onTrue
    }

    func bne(onTrue: [UInt8], onFalse: [UInt8] = []) -> [UInt8] {
        return
            bne(Int8(onFalse.count + 2)) +
            onFalse +
            bra(Int8(onTrue.count)) +
            onTrue
    }

    func loop(_ block: [UInt8]) -> [UInt8] {
        let len = uint16(-block.count - 3)
        return block + [
            0x17, len.hi(), len.lo(),
        ]
    }
}
