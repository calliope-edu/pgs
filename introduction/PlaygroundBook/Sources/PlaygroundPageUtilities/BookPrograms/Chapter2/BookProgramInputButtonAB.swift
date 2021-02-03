// OK
public final class BookProgramInputButtonAB: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "bookProgramInputButtonAB.success".localized

		guard let img = miniImage(from: values[0]) else {
			//static type checker prevents this
			return (.fail(hints: [], solution: ""), nil)
		}

		let p = BookProgramInputButtonAB()
		p.image = img

		return (.pass(message: success), p)
	}

    public var image: miniImage = .smiley

    public func build() -> ProgramBuildResult {
        let delay: Int16 = 500

        let code: [UInt8] = [

            cmpi16(Button.ab.rawValue, .r0),
            rne(),

            movi16(DashboardItemType.ButtonA.rawValue + DashboardItemType.ButtonB.rawValue, .r4),
            notify(address: .r4, value: .r4),

            movi16(DashboardItemType.Display.rawValue, .r4),
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
