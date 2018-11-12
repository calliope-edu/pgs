// NOK 36
public final class BookProgramOutputSound: ProgramBase, Program {

    public var frequency: Int16 = 2000
    public var delay: Int16 = 1000

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            movi16(delay, .r0),
            sleep(.r0),

            movi16(NotificationAddress.sound.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(frequency, .r0),
            sound_on(.r0),
            movi16(delay, .r0),
            sleep(.r0),
            sound_off(),

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
