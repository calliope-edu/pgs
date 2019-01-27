// NOK 127
import UIKit

public final class BookProgramOutputCombination: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "page.success".localized
		let hints = [
			"page.hint1".localized,
			"page.hint2".localized,
			"page.hint3".localized
		]
		let solution = "page.solution".localized

		guard let freq1 = miniSound(from: values[0]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let mColor1 = miniColor(from: values[1]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let freq2 = miniSound(from: values[2]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let mColor2 = miniColor(from: values[3]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let freq3 = miniSound(from: values[4]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let mColor3 = miniColor(from: values[5]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let str = values[6] as? String else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let img = CalliopeImage(from: values[7]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		let p = BookProgramOutputCombination()
		p.frequency1 = Int16(freq1.rawValue)
		p.color1 = mColor1.color
		p.frequency2 = Int16(freq2.rawValue)
		p.color2 = mColor2.color
		p.frequency3 = Int16(freq3.rawValue)
		p.color3 = mColor3.color
		p.s = str
		p.image = img
		// return (.pass(message: success), p)
		return (nil, p)
	}

	public var frequency1: Int16 = 2000
	public var color1: UIColor = .red
	public var frequency2: Int16 = 3000
	public var color2: UIColor = .green
	public var frequency3: Int16 = 4000
	public var color3: UIColor = .blue
	public var s: String = "Hey!"
	public var image: CalliopeImage = .smiley

	func show(frequency: Int16, color: UIColor) -> [UInt8] {
		return [

			movi16(NotificationAddress.rgb.rawValue, .r4),
			notify(address: .r4, value: .r4),

			rgb_on(color: color),

			movi16(NotificationAddress.sound.rawValue, .r4),
			notify(address: .r4, value: .r4),

			movi16(frequency, .r0),
			sound_on(.r0),
			sleep(.r1),
			sound_off(),

			].flatMap { $0 }
	}

	public func build() -> ProgramBuildResult {
		let delay: Int16 = 1000

		let code: [UInt8] = [

			movi16(delay, .r1),
			sleep(.r1),

			show(frequency: frequency1, color: color1),
			show(frequency: frequency2, color: color2),
			show(frequency: frequency3, color: color3),

			rgb_off(),

			movi16(NotificationAddress.display.rawValue, .r4),
			notify(address: .r4, value: .r4),
			showText(s),

			movi16(NotificationAddress.display.rawValue, .r4),
			notify(address: .r4, value: .r4),
			movi16(image.rawValue, .r0),
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
