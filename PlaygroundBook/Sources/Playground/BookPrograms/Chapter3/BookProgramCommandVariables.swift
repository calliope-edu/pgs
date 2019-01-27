// OK
public final class BookProgramCommandVariables: ProgramBase, Program {
    public var name: String = "Jon"
    public var age: Int16 = 25

    public func build() -> ProgramBuildResult {

        let notify_display: [UInt8] = [
            movi16(NotificationAddress.display.rawValue, .r4) +
            notify(address: .r4, value: .r4)
        ].flatMap { $0 }

        let code: [UInt8] = [
            notify_display,
            showText(name),

            notify_display,
            movi16(age, .r0),
            showNumber(.r0),

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
