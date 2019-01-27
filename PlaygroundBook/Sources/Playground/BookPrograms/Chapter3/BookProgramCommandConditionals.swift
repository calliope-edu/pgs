// OK
public final class BookProgramCommandConditionals: ProgramBase, Program {
    public var textTrue: String = "w"
    public var textFalse: String = "n"
    public var start: Int16 = 0
    public var stop: Int16 = 2
    public var n: Int16 = 1

    public func build() -> ProgramBuildResult {

        let printTrue: [UInt8] =
            showText(textTrue) +
            ret()

        let printFalse: [UInt8] =
            showText(textFalse) +
            ret()

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

            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),

            cmpi16(n, .r2),
            bne(Int8(printTrue.count)),
            printTrue +
            printFalse

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
