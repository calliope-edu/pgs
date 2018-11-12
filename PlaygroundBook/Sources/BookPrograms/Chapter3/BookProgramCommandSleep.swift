// OK
public final class BookProgramCommandSleep: ProgramBase, Program {
    public var image1: CalliopeImage = .sad
    public var image2: CalliopeImage = .smiley
    public var delay: Int16 = 1000

    public func build() -> ProgramBuildResult {

        let notify_display: [UInt8] = [
            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
        ].flatMap { $0 }

        let code: [UInt8] = [

            notify_display,

            movi16(image1.rawValue, .r0),
            showImage(.r0),

            movi16(delay, .r0),
            sleep(.r0),

            notify_display,

            movi16(image2.rawValue, .r0),
            showImage(.r0),

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
