import UIKit

public final class BookProgramCommandCombination: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "page.success".localized
		let hints = [
			"page.hint1".localized,
			"page.hint2".localized,
			"page.hint3".localized
		]
		let solution = "page.solution".localized

		guard let mColor0 = miniColor(from: values[0]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let mColor1 = miniColor(from: values[1]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let mColor2 = miniColor(from: values[2]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let mColor3 = miniColor(from: values[3]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let correct = miniImage(from: values[4]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let wrong = miniImage(from: values[5]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		let p = BookProgramCommandCombination()
		p.color0 = mColor0.color
		p.color1 = mColor1.color
		p.color2 = mColor2.color
		p.color3 = mColor3.color
		p.correct = correct
		p.wrong = wrong

		//return (.pass(message: success), p)
		return (nil, p)
	}

	public var color0: UIColor = .red
    public var color1: UIColor = .green
    public var color2: UIColor = .blue
    public var color3: UIColor = .white

    public var arrow: miniImage = .arrow_left
    public var correct: miniImage = .smiley
    public var wrong: miniImage = .sad

    public var delay1: Int16 = 400
    public var delay2: Int16 = 1000

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            // show arrow
            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
            movi16(arrow.rawValue, .r0),
            showImage(.r0),

            // wait for A
            movi16(Button.a.rawValue, .r1),
            mov(.r1, .r0),
            button(.r0),
            beq(-7),
            movi16(NotificationAddress.buttonA.rawValue, .r4),
            notify(address: .r4, value: .r4),
            mov(.r1, .r0),
            button(.r0),
            bne(-7),

            // get random
            movi16(4, .r0),
            mov(.r0, .r1),
            random(.r1),
            mov(.r0, .r2),
            random(.r2),
            mov(.r0, .r3),
            random(.r3),

            // show colors
            mov(.r1, .r0),
            jsr(126),
            mov(.r2, .r0),
            jsr(121),
            mov(.r3, .r0),
            jsr(116),

            // show question
            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
            showText("?"),

            // wait 1
            jsr(0x77 - 0x4f),
            cmp(.r4, .r1),
            bne(22),
            // wait 2
            jsr(0x77 - 0x56),
            cmp(.r4, .r2),
            bne(15),
            // wait 3
            jsr(0x77 - 0x5d),
            cmp(.r4, .r3),
            bne(8),

            // correct
            movi16(correct.rawValue, .r0),
            showImage(.r0),
            bra(6),

            // wrong
            movi16(wrong.rawValue, .r0),
            showImage(.r0),

            movi16(delay2, .r0),
            sleep(.r0),
            ret(),

            // wait for pin down
            movi16(0, .r0),
            mov(.r0, .r4),
            pin(.r0),
            bne(35),
            movi16(1, .r0),
            mov(.r0, .r4),
            pin(.r0),
            bne(24),
            movi16(2, .r0),
            mov(.r0, .r4),
            pin(.r0),
            bne(13),
            movi16(3, .r0),
            mov(.r0, .r4),
            pin(.r0),
            bne(2),
            bra(-46),
            movi16(NotificationAddress.pin.rawValue, .r0),
            notify(address: .r0, value: .r4),
            // wait for pin up
            mov(.r4, .r0),
            pin(.r0),
            bne(-7),

            // no beep, keep the offset
            ret(),
            ret(),

            // show colors
            cmpi16(0, .r0),
            bne(7),
            rgb_on(color: color0),
            bra(31),
            cmpi16(1, .r0),
            bne(7),
            rgb_on(color: color1),
            bra(18),
            cmpi16(2, .r0),
            bne(7),
            rgb_on(color: color2),
            bra(5),
            rgb_on(color: color3),
            movi16(NotificationAddress.rgb.rawValue, .r4),
            notify(address: .r4, value: .r4),
            movi16(delay1, .r4),
            sleep(.r4),
            rgb_off(),
            sleep(.r4),
            log(.r0),
            ret(),

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
