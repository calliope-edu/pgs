// OK
public final class BookProgramCommandRandom: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "bookProgramCommandRandom.success".localized
		let solution = "bookProgramCommandRandom.solution".localized

		guard let start = Int(values[0]) else {
			return (.fail(hints: [], solution: solution), nil)
		}

		guard let stop = Int(values[1]) else {
			return (.fail(hints: [], solution: solution), nil)
		}

		guard start > Int16.min else {
			return (.fail(hints: ["bookProgramCommandRandom.hintTooLowStart".localized], solution: solution), nil)
		}

		guard start < Int16.max - 1 else {
			return (.fail(hints: ["bookProgramCommandRandom.hintTooHighStart".localized], solution: solution), nil)
		}

		guard stop > Int16.min + 1 else {
			return (.fail(hints: ["bookProgramCommandRandom.hintTooLowStop".localized], solution: solution), nil)
		}

		guard stop < Int16.max else {
			return (.fail(hints: ["bookProgramCommandRandom.hintTooHighStop".localized], solution: solution), nil)
		}

		guard start < stop else {
			return (.fail(hints: ["bookProgramCommandRandom.startNotLowerStop".localized], solution: solution), nil)
		}


		let p = BookProgramCommandRandom()
		p.start = Int16(start)
		p.stop = Int16(stop)

		return (.pass(message: success), p)
	}

	public var start: Int16 = 1
    public var stop: Int16 = 6

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            cmpi16(Gesture.shake.rawValue, .r0),
            rne(),
            movi16(DashboardItemType.Shake.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(start, .r1),
            movi16(stop + 1, .r2),
            sub(.r1, .r2),
            random(.r2),
            add(.r1, .r2),

            movi16(DashboardItemType.Display.rawValue, .r4),
            notify(address: .r4, value: .r4),
            showNumber(.r2),

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
