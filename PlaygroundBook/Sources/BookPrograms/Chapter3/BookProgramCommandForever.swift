// OK
import UIKit

public final class BookProgramCommandForever: ProgramBase, Program {
    public var color: UIColor = .red
    public var delay: Int16 = 200

    public func build() -> ProgramBuildResult {

        let wait: [UInt8] = [
            movi16(delay, .r0),
            sleep(.r0),
        ].flatMap { $0 }

        let code: [UInt8] = [
            movi16(NotificationAddress.rgb.rawValue, .r4),
            notify(address: .r4, value: .r4),
            rgb_on(color: color),
            wait,
            rgb_off(),
            wait,
        ].flatMap { $0 }

        let methods: [UInt16] = [
            0xffff,
            0x0000,
            0xffff,
            0xffff,
            0xffff,
        ]

        return ProgramBuildResult(code: code, methods: methods)
    }

    public override init() {
    }
}
