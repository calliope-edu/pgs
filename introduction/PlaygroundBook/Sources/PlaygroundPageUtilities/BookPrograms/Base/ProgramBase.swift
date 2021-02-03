import UIKit

public protocol Program {
    func build() -> ProgramBuildResult
}

public enum Register: UInt8 {
    case r0 = 0, r1, r2, r3, r4
}

public enum Button: Int16 {
    case a = 1, b = 2, ab = 3
}

public enum Gesture: Int16 {
    case shake = 0x001b
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
