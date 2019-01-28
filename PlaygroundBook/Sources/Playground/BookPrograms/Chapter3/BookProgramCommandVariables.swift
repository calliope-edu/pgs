// OK
public final class BookProgramCommandVariables: ProgramBase, Program {

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

		guard let age = Int16(values[1]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		let p = BookProgramCommandVariables()
		p.name = values[0]
		p.age = age

		//return (.pass(message: success), p)
		return (nil, p)
	}

	public var name: String = "Jon"
    public var age: Int16 = 25

    public func build() -> ProgramBuildResult {

        let notify_display: [UInt8] = [
            movi16(NotificationAddress.display.rawValue, .r4) +
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
