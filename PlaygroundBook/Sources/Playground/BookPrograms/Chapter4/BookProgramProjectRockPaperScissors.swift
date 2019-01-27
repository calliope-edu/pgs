// OK
public final class BookProgramProjectRockPaperScissors: ProgramBase, Program {
    public var speed: Int16 = 10

    public var image1: CalliopeImage = .arrow_left
    public var image2: CalliopeImage = .arrow_right
    public var image3: CalliopeImage = .arrow_left_right

    func waitOnButton() -> [UInt8] {
        return [
            movi16(speed, .r1),
            sleep(.r1),

            movi16(Button.a.rawValue, .r0),
            button(.r0),
            beq(21 + 3),

            movi16(NotificationAddress.buttonA.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(Button.a.rawValue, .r0),
            button(.r0),
            bne(-8),

            sleep(.r1),
        ].flatMap { $0 }
    }

    public func build() -> ProgramBuildResult {

        let notify_display: [UInt8] = [
            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
        ].flatMap { $0 }

        let rock: [UInt8] = [
            notify_display,
            movi16(image1.rawValue, .r0),
            showImage(.r0),
            waitOnButton(),
        ].flatMap { $0 }

        let paper: [UInt8] = [
            notify_display,
            movi16(image2.rawValue, .r0),
            showImage(.r0),
            waitOnButton(),
        ].flatMap { $0 }

        let scissors: [UInt8] = [
            notify_display,
            movi16(image3.rawValue, .r0),
            showImage(.r0),
            waitOnButton(),
        ].flatMap { $0 }

        let code: [UInt8] = [
            rock +
            paper +
            scissors
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
