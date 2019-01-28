// OK
public final class BookProgramCommandClear: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "page.success".localized
		let hints = [
			"page.hint1".localized,
			"page.hint2".localized,
			"page.hint3".localized
		]
		let solution = "page.solution".localized

		guard let img = CalliopeImage(from: values[0]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let delay = UInt16(values[1]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		let p = BookProgramCommandClear()
		p.image = img
		p.delay = Int16(delay)

		//return (.pass(message: success), p)
		return (nil, p)
	}

	public var image: CalliopeImage = .smiley
    public var delay: Int16 = 1000

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            movi16(NotificationAddress.display.rawValue, .r4),
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
