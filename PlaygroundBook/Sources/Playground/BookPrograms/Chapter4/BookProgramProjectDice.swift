// OK
public final class BookProgramProjectDice: ProgramBase, Program {

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

		guard let freq = miniSound(from: values[2]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let delay = Int(values[3]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		let p = BookProgramProjectDice()
		p.start = Int16(start)
		p.stop = Int16(stop)
		p.frequency = Int16(freq.rawValue)
		p.delay = Int16(delay)

		// return (.pass(message: success), p)
		return (nil, p)
	}

    public var start: Int16 = 1
    public var stop: Int16 = 6

    public var frequency: Int16 = 2000
    public var delay: Int16 = 200

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            cmpi16(Gesture.shake.rawValue, .r0),
            rne(),
            movi16(NotificationAddress.shake.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(start, .r1),
            movi16(stop, .r2),
            sub(.r1, .r2),
            random(.r2),
            add(.r1, .r2),

            movi16(NotificationAddress.sound.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(frequency, .r0),
            sound_on(.r0),
            movi16(delay, .r0),
            sleep(.r0),
            sound_off(),

            movi16(NotificationAddress.display.rawValue, .r4),
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
