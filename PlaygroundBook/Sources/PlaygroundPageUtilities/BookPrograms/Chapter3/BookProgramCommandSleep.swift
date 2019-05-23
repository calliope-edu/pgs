// OK
public final class BookProgramCommandSleep: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "bookProgramCommandSleep.success".localized
		let solution = "bookProgramCommandSleep.solution".localized

		guard let img1 = miniImage(from: values[0]) else {
			//will not happen
			return (.fail(hints: [], solution: ""), nil)
		}

		guard let delay = UInt16(values[1]) else {
			//will not happen
			return (.fail(hints: [], solution: ""), nil)
		}

		guard delay > 100 else {
			return (.fail(hints: ["bookProgramCommandSleep.hintTooShortSleep".localized], solution: solution), nil)
		}
		guard delay < 30000 else {
			return (.fail(hints: ["bookProgramCommandSleep.hintTooLongSleep".localized], solution: solution), nil)
		}

		guard let img2 = miniImage(from: values[2]) else {
			//will not happen
			return (.fail(hints: [], solution: solution), nil)
		}

		let p = BookProgramCommandSleep()
		p.image1 = img1
		p.delay = Int16(delay)
		p.image2 = img2

		return (.pass(message: success), p)
	}

	public var image1: miniImage = .sad
    public var image2: miniImage = .smiley
    public var delay: Int16 = 1000

    public func build() -> ProgramBuildResult {

        let notify_display: [UInt8] = [
            movi16(DashboardItemType.Display.rawValue, .r4),
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
