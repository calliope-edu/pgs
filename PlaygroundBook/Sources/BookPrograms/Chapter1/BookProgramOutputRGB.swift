// OK 22
import UIKit

public final class BookProgramOutputRGB: ProgramBase, Program {

    public var color: UIColor = .red

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            movi16(NotificationAddress.rgb.rawValue, .r4),
            notify(address: .r4, value: .r4),
            rgb_on(color: color),

        ].flatMap { $0 }

        let methods: [UInt16] = [
            0x0000,
            0xffff,
            0xffff,
            0xffff,
            0xffff,
        ]

        return ProgramBuildResult(code: code, methods: methods)
    }

    public override init() {
    }
}
