// OK
public final class BookProgramInputShake: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "bookProgramInputShake.success".localized
		let solution = "bookProgramInputShake.solution".localized

		let s = values[0]

		guard s.unicodeScalars.reduce(true, { (isAscii, char) in isAscii && char.isASCII }) else {
			//user can accidentially input characters that cannot be displayed
			return (.fail(hints: ["bookProgramInputShake.hintNoAscii".localized], solution: solution), nil)
		}

		let p = BookProgramInputShake()
		p.s = s
		return (.pass(message: success), p)
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
