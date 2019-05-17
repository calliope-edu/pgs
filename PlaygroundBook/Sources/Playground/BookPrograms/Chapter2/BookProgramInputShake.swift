// OK
public final class BookProgramInputShake: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "page.success".localized
		let hints = [
			"page.hint1".localized,
			"page.hint2".localized,
			"page.hint3".localized
		]
		let solution = "page.solution".localized

		guard values.count > 0 else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		let p = BookProgramInputShake()
		p.s = values[0]
		//return (.pass(message: success), p)
		return (nil, p)
	}

	public var s: String = "shake"

    public func build() -> ProgramBuildResult {
        let code: [UInt8] = [

            cmpi16(Gesture.shake.rawValue, .r0),
            rne(),

            movi16(NotificationAddress.shake.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
            showText(s),

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
