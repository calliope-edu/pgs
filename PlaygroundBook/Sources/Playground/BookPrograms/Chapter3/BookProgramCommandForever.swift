// OK
import UIKit

public final class BookProgramCommandForever: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "page.success".localized
		let hints = [
			"page.hint1".localized,
			"page.hint2".localized,
			"page.hint3".localized
		]
		let solution = "page.solution".localized

		guard let mColor = miniColor(from: values[0]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let delay = UInt16(values[1]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		let p = BookProgramCommandForever()
		p.color = mColor.color
		p.delay = Int16(delay)

		//return (.pass(message: success), p)
		return (nil, p)
	}

	public var color: UIColor = .red
    public var delay: Int16 = 200

    public func build() -> ProgramBuildResult {

        let wait: [UInt8] = [
            movi16(delay, .r0),
            sleep(.r0),
        ].flatMap { $0 }

        let code: [UInt8] = [
            movi16(NotificationAddress.rgb.rawValue, .r4),
            notify(address: .r4, value: .r4),
            rgb_on(color: color),
            wait,
            rgb_off(),
            wait,
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
