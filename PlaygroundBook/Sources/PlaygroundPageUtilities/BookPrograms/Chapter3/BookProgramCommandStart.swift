// OK
public final class BookProgramCommandStart: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "bookProgramCommandStart.success".localized
		let solution = "bookProgramCommandStart.solution".localized

		let s = values[0]
		guard s.unicodeScalars.reduce(true, { (isAscii, char) in isAscii && char.isASCII }) else {
			//user can accidentially input characters that cannot be displayed
			return (.fail(hints: ["bookProgramCommandStart.hintNoAscii".localized], solution: solution), nil)
		}

		let p = BookProgramCommandStart()
		p.s = s

		return (.pass(message: success), p)
	}

	public var s: String = "foo"


    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
            showText(s),

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
