// OK
public final class BookProgramProjectTheremin: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "bookProgramProjectTheremin.success".localized

		guard let offset = UInt16(values[0]) else {
			return (.fail(hints: [], solution: ""), nil)
		}

		guard let factor = UInt16(values[1]) else {
			return (.fail(hints: [], solution: ""), nil)
		}

		let p = BookProgramProjectTheremin()
		p.factor = Int16(factor)
		p.offset = Int16(offset)

		return (.pass(message: success), p)
	}

    public var factor: Int16 = 10
    public var offset: Int16 = 200
    public var delay: Int16 = 100

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [
            movi16(factor, .r3),
            movi16(offset, .r1),
            // f = brightness * freq + off
            brightness(.r2),

			movi16(DashboardItemType.Brightness.rawValue, .r4),
			notify(address: .r4, value: .r2),

			mov(.r2, .r0),

			bne(
				onTrue:
				[mul(.r3, .r2),
				add(.r1, .r2),
				sound_on(.r2),
				movi16(DashboardItemType.Sound.rawValue, .r4),
				notify(address: .r4, value: .r4)]
					.flatMap {$0 },
				onFalse:
				[sound_off()]
					.flatMap { $0 }
			),

            movi16(delay, .r0),
            sleep(.r0),

        ].flatMap { $0 }

        let methods: [UInt16] = [
            0xffff,
            0x0000,
            0xffff,
            0xffff,
            0xffff,
        ]

        return ProgramBuildResult(code: code, methods: methods)
    }

    public override init() {
    }
}
