// OK
public final class BookProgramCommandClear: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "bookProgramCommandClear.success".localized
		let solution = "bookProgramCommandClear.solution".localized

		guard let img = miniImage(from: values[0]) else {
			//will not happen
			return (.fail(hints: [], solution: solution), nil)
		}

		guard let delay = UInt16(values[1]) else {
			return (.fail(hints: [], solution: solution), nil)
		}

		guard delay > 100 else {
			return (.fail(hints: ["bookProgramCommandClear.hintTooShortSleep"], solution: solution), nil)
		}
		guard delay < 30000 else {
			return (.fail(hints: ["bookProgramCommandClear.hintTooLongSleep"], solution: solution), nil)
		}

		let p = BookProgramCommandClear()
		p.image = img
		p.delay = Int16(delay)

		return (.pass(message: success), p)
	}

	public var image: miniImage = .smiley
    public var delay: Int16 = 1000

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            movi16(DashboardItemType.Display.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(image.rawValue, .r0),
            showImage(.r0),

            movi16(delay, .r0),
            sleep(.r0),
            clear(),

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
