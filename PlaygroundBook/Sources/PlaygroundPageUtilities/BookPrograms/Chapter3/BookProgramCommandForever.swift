// OK
import UIKit

public final class BookProgramCommandForever: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "bookProgramCommandForever.success".localized
		let solution = "bookProgramCommandForever.solution".localized

		guard let mColor = miniColor(from: values[0]) else {
			return (.fail(hints: [], solution: solution), nil)
		}

		guard let delay = UInt16(values[1]) else {
			return (.fail(hints: [], solution: solution), nil)
		}

		guard delay > 100 else {
			return (.fail(hints: ["bookProgramCommandForever.hintTooShortSleep".localized], solution: solution), nil)
		}
		guard delay < 30000 else {
			return (.fail(hints: ["bookProgramCommandForever.hintTooLongSleep".localized], solution: solution), nil)
		}

		guard let delayOff = UInt16(values[2]) else {
			return (.fail(hints: [], solution: solution), nil)
		}

		guard delay > 100 else {
			return (.fail(hints: ["bookProgramCommandForever.hintTooShortSleep".localized], solution: solution), nil)
		}
		guard delay < 30000 else {
			return (.fail(hints: ["bookProgramCommandForever.hintTooLongSleep".localized], solution: solution), nil)
		}

		let p = BookProgramCommandForever()
		p.color = mColor.color
		p.delay = Int16(delay)
		p.delayOff = Int16(delayOff)

		return (.pass(message: success), p)
	}

	public var color: UIColor = .red
    public var delay: Int16 = 200
	public var delayOff: Int16 = 200

    public func build() -> ProgramBuildResult {

        let wait: [UInt8] = [
            movi16(delay, .r0),
            sleep(.r0),
        ].flatMap { $0 }

		let waitOff: [UInt8] = [
			movi16(delayOff, .r0),
			sleep(.r0),
		].flatMap { $0 }

        let code: [UInt8] = [
            movi16(DashboardItemType.RGB.rawValue, .r4),
            notify(address: .r4, value: .r4),
            rgb_on(color: color),
            wait,
            rgb_off(),
            waitOff,
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
