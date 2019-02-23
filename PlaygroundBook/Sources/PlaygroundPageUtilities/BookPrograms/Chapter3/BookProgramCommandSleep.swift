// OK
public final class BookProgramCommandSleep: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "page.success".localized
		let hints = [
			"page.hint1".localized,
			"page.hint2".localized,
			"page.hint3".localized
		]
		let solution = "page.solution".localized

		guard let img1 = miniImage(from: values[0]) else {
			LogNotify.log("img1")
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let delay = UInt16(values[1]) else {
			LogNotify.log("delay")
			return (.fail(hints: hints, solution: solution), nil)
		}

		LogNotify.log("img2 \(values[2])")

		guard let img2 = miniImage(from: values[2]) else {
			LogNotify.log("img2")
			return (.fail(hints: hints, solution: solution), nil)
		}

		let p = BookProgramCommandSleep()
		p.image1 = img1
		p.delay = Int16(delay)
		p.image2 = img2

		//return (.pass(message: success), p)
		return (nil, p)
	}

	public var image1: miniImage = .sad
    public var image2: miniImage = .smiley
    public var delay: Int16 = 1000

    public func build() -> ProgramBuildResult {

        let notify_display: [UInt8] = [
            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
        ].flatMap { $0 }

        let code: [UInt8] = [

            notify_display,

            movi16(image1.rawValue, .r0),
            showImage(.r0),

            movi16(delay, .r0),
            sleep(.r0),

            notify_display,

            movi16(image2.rawValue, .r0),
            showImage(.r0),

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
