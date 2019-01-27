// OK
import UIKit

public final class BookProgramInputPin: ProgramBase, Program {

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

		let p = BookProgramInputPin()
		p.color = mColor.color

		//return (.pass(message: success), p)
		return (nil, p)
	}

	public var color: UIColor = .red

	public func build() -> ProgramBuildResult {

		let code: [UInt8] = [

			movi16(NotificationAddress.pin.rawValue, .r4),
			notify(address: .r4, value: .r4),

			movi16(NotificationAddress.display.rawValue, .r4),
			notify(address: .r4, value: .r4),

			showNumber(.r0),
			mov(.r0, .r2),

			movi16(NotificationAddress.rgb.rawValue, .r4),
			notify(address: .r4, value: .r4),
			rgb_on(color: color),
			mov(.r0, .r1),
			pin(.r1),
			bne(-7),
			rgb_off(),

			].flatMap { $0 }

		let methods: [UInt16] = [
			0xffff,
			0xffff,
			0xffff,
			0x0000,
			0xffff,
			]

		return ProgramBuildResult(code: code, methods: methods)
	}

	public override init() {
	}
}
