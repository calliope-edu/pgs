// OK
public final class BookProgramInputButtonA: ProgramBase, Program {

    public var image: CalliopeImage = .smiley

    public func build() -> ProgramBuildResult {
        let delay: Int16 = 200

        let code: [UInt8] = [

            cmpi16(Button.a.rawValue, .r0),
            rne(),

            movi16(NotificationAddress.buttonA.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(image.rawValue, .r0),
            showImage(.r0),

            movi16(delay, .r0),
            sleep(.r0),

            clear(),

        ].flatMap { $0 }

        let methods: [UInt16] = [
            0xffff,
            0xffff,
            0x0000,
            0xffff,
            0xffff,
        ]

        return ProgramBuildResult(code: code, methods: methods)
    }

    public override init() {
    }
}
