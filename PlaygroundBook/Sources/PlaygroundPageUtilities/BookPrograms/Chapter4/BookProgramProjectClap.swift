// OK
import UIKit

public final class BookProgramProjectClap: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "bookProgramProjectClap.success".localized
		let solution = "bookProgramProjectClap.solution".localized

		guard let threshold = UInt16(values[0]) else {
			return (.fail(hints: [], solution: ""), nil)
		}

		guard threshold > 0 else {
			return (.fail(hints: ["bookProgramProjectClap.hintTooLowClapThreshold"], solution: solution), nil)
		}
		guard threshold < 30000 else {
			return (.fail(hints: ["bookProgramProjectClap.hintTooHighClapThreshold"], solution: solution), nil)
		}

		guard let mColor = miniColor(from: values[1]) else {
			return (.fail(hints: [], solution: ""), nil)
		}
		let p = BookProgramProjectClap()
		p.color = mColor.color
		p.threshold = Int16(threshold)

		return (.pass(message: success), p)
	}

    public var color: UIColor = .white
    public var threshold: Int16 = 2
    public var delay: Int16 = 10
    public var wait: Int16 = 1000

    func read() -> [UInt8] {
        return [
            noise(.r2),
            movi16(NotificationAddress.noise.rawValue, .r4),
            notify(address: .r4, value: .r2),
        ].flatMap { $0 }
    }

    func waitForHi() -> [UInt8] {
        let r = read()
        return [
            r,
            cmp(.r2, .r0),
            blt(8),
            movi16(delay, .r3),
            sleep(.r3),
            bra(Int8(-r.count - 13)),
        ].flatMap { $0 }
    }

    func waitForLo() -> [UInt8] {
        let r = read()
        return [
            r,
            cmp(.r2, .r0),
            bge(8),
            movi16(delay, .r3),
            sleep(.r3),
            bra(Int8(-r.count - 13)),
        ].flatMap { $0 }
    }

    public func build() -> ProgramBuildResult {

        let d: [UInt8] = [
            movi16(wait, .r3),
            sleep(.r3),
        ].flatMap { $0 }

        let wait_for_clap: [UInt8] = [
            waitForHi(),
            waitForLo(),
        ].flatMap { $0 }

        let block: [UInt8] = [
            wait_for_clap,

            movi16(NotificationAddress.rgb.rawValue, .r4),
            notify(address: .r4, value: .r4),
            rgb_on(color: color),
            d,

            wait_for_clap,

            movi16(NotificationAddress.rgb.rawValue, .r4),
            notify(address: .r4, value: .r4),
            rgb_off(),
            d,

        ].flatMap { $0 }

        let code: [UInt8] = [
            movi16(threshold, .r0),
            loop(block),
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
