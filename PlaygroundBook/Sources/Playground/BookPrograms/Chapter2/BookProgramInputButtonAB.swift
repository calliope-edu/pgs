// OK
public final class BookProgramInputButtonAB: ProgramBase, Program {

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

		let p = BookProgramInputButtonAB()
		p.image = img

		//return (.pass(message: success), p)
		return (nil, p)
	}

    public var image: CalliopeImage = .smiley

    public func build() -> ProgramBuildResult {
        let delay: Int16 = 200

        let code: [UInt8] = [

            cmpi16(Button.ab.rawValue, .r0),
            rne(),

            movi16(NotificationAddress.buttonAB.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(image.rawValue, .r0),
            showImage(.r0),

            movi16(delay, .r0),
            sleep(.r0),

            clear(),

        ].flatMap { $0 }

        let methods: [UInt16] = [
            0xffff,
            0xffff,
            0x0000,
            0xffff,
            0xffff,
        ]

        return ProgramBuildResult(code: code, methods: methods)
    }

    public override init() {
    }
}
