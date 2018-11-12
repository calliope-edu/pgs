// OK
public final class BookProgramProjectTheremin: ProgramBase, Program {

    public var factor: Int16 = 10
    public var offset: Int16 = 200
    public var delay: Int16 = 100

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [
            movi16(factor, .r0),
            movi16(offset, .r1),
            // f = brightness * freq + off
            brightness(.r2),
            mul(.r0, .r2),
            add(.r1, .r2),

            movi16(NotificationAddress.light.rawValue, .r4),
            notify(address: .r4, value: .r2),

            movi16(NotificationAddress.sound.rawValue, .r4),
            notify(address: .r4, value: .r4),
            sound_on(.r2),
            movi16(delay, .r0),
            sleep(.r0),

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
