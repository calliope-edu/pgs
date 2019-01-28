// OK
public final class BookProgramCommandLoops: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "page.success".localized
		let hints = [
			"page.hint1".localized,
			"page.hint2".localized,
			"page.hint3".localized
		]
		let solution = "page.solution".localized

		guard let start = Int(values[0]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let stop = Int(values[1]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let delay = UInt16(values[2]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		let p = BookProgramCommandLoops()
		p.start = Int16(start)
		p.stop = Int16(stop)
		p.delay = Int16(delay)

		//return (.pass(message: success), p)
		return (nil, p)
	}

	public var start: Int16 = 1
    public var stop: Int16 = 3
    public var delay: Int16 = 1000

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            movi16(delay, .r0),
            movi16(start, .r1),
            movi16(stop, .r2),
            movi16(1, .r3),

            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
            showNumber(.r1),
            sleep(.r0),
            add(.r3, .r1),
            cmp(.r1, .r2),
            ble(-19),

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
