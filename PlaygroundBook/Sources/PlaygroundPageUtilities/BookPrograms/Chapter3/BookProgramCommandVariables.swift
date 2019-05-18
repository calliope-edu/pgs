// OK
public final class BookProgramCommandVariables: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "bookProgramCommandVariables.success".localized
		let solution = "bookProgramCommandVariables.solution".localized

		let s = values[0]
		guard s.unicodeScalars.reduce(true, { (isAscii, char) in isAscii && char.isASCII }) else {
			//user can accidentially input characters that cannot be displayed
			return (.fail(hints: ["bookProgramCommandVariables.hintNoAscii".localized], solution: solution), nil)
		}

		guard let age = Int16(values[1]) else {
			return (.fail(hints: [], solution: solution), nil)
		}

		guard age < 200 else {
			return (.fail(hints: ["bookProgramCommandVariables.hintTooOld"], solution: solution), nil)
		}

		let p = BookProgramCommandVariables()
		p.name = values[0]
		p.age = age

		return (.pass(message: success), p)
	}

	public var name: String = "Jon"
    public var age: Int16 = 25

    public func build() -> ProgramBuildResult {

        let notify_display: [UInt8] = [
            movi16(DashboardItemType.Display.rawValue, .r4) +
            notify(address: .r4, value: .r4)
        ].flatMap { $0 }

        let code: [UInt8] = [
            notify_display,
            showText(name),

            notify_display,
            movi16(age, .r0),
            showNumber(.r0),

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
