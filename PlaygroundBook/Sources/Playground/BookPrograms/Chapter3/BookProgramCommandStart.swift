// OK
public final class BookProgramCommandStart: ProgramBase, Program {
    public var s: String = "foo"


    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
            showText(s),

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
