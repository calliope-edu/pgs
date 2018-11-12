// OK
public final class BookProgramProjectDice: ProgramBase, Program {

    public var start: Int16 = 1
    public var stop: Int16 = 6

    public var frequency: Int16 = 2000
    public var delay: Int16 = 200

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            cmpi16(Gesture.shake.rawValue, .r0),
            rne(),
            movi16(NotificationAddress.shake.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(start, .r1),
            movi16(stop, .r2),
            sub(.r1, .r2),
            random(.r2),
            add(.r1, .r2),

            movi16(NotificationAddress.sound.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(frequency, .r0),
            sound_on(.r0),
            movi16(delay, .r0),
            sleep(.r0),
            sound_off(),

            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
            showNumber(.r2),

        ].flatMap { $0 }

        let methods: [UInt16] = [
            0xffff,
            0xffff,
            0xffff,
            0xffff,
            0x0000,
        ]

        return ProgramBuildResult(code: code, methods: methods)
    }

    public override init() {
    }
}
