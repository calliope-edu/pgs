// OK
import UIKit

public final class BookProgramInputCombination: ProgramBase, Program {
	
	public static let assessment: AssessmentBlock = { values in
		
		let success = "bookProgramInputCombination.success".localized
		let solution = "bookProgramInputCombination.solution".localized
		
		var o: Int = 0
		
		let image1:[UInt8] = values[o+0...o+24].compactMap{ UInt8($0) }
		guard image1.count == 25 else {
			return (.fail(hints: ["bookProgramInputCombination.tooManyOrFewEntriesImage1".localized], solution: solution), nil)
		}

		guard image1.reduce(true, { (isGrid, entry) in isGrid && entry < 2 }) else {
			return (.fail(hints: ["bookProgramInputCombination.otherThanZeroOrOneImage1".localized], solution: solution), nil)
		}
		guard let mColor1 = miniColor(from: values[o+25]) else {
			return (.fail(hints: [], solution: ""), nil)
		}
		o += 26
		
		let image2:[UInt8] = values[o+0...o+24].compactMap{ UInt8($0) }
		guard image2.count == 25 else {
			return (.fail(hints: ["bookProgramInputCombination.tooManyOrFewEntriesImage2".localized], solution: solution), nil)
		}

		guard image2.reduce(true, { (isGrid, entry) in isGrid && entry < 2 }) else {
			return (.fail(hints: ["bookProgramInputCombination.otherThanZeroOrOneImage2".localized], solution: solution), nil)
		}
		guard let mColor2 = miniColor(from: values[o+25]) else {
			return (.fail(hints: [], solution: ""), nil)
		}
		o += 26
		
		let image3:[UInt8] = values[o+0...o+24].compactMap{ UInt8($0) }
		guard image3.count == 25 else {
			return (.fail(hints: ["bookProgramInputCombination.tooManyOrFewEntriesImage3".localized], solution: solution), nil)
		}

		guard image3.reduce(true, { (isGrid, entry) in isGrid && entry < 2 }) else {
			return (.fail(hints: ["bookProgramInputCombination.otherThanZeroOrOneImage3".localized], solution: solution), nil)
		}
		guard let mColor3 = miniColor(from: values[o+25]) else {
			return (.fail(hints: [], solution: ""), nil)
		}
		o += 26
		
		guard let freq = miniSound(from: values[o+0]) else {
			return (.fail(hints: [], solution: ""), nil)
		}
		
		let p = BookProgramInputCombination()
		p.imageA = image1
		p.colorA = mColor1.color
		p.imageB = image2
		p.colorB = mColor2.color
		p.imageAB = image3
		p.colorAB = mColor3.color
		p.frequency = Int16(freq.rawValue)
		
		return (.pass(message: success), p)
	}
	
	public var imageA: [UInt8] = [
		1, 1, 1, 1, 1,
		1, 0, 1, 0, 1,
		1, 0, 1, 0, 1,
		1, 0, 1, 0, 1,
		1, 1, 1, 1, 1,
		]
	public var imageB: [UInt8] = [
		1, 1, 1, 1, 1,
		1, 0, 1, 0, 1,
		1, 0, 1, 0, 1,
		1, 0, 1, 0, 1,
		1, 1, 1, 1, 1,
		]
	public var imageAB: [UInt8] = [
		1, 1, 1, 1, 1,
		1, 0, 1, 0, 1,
		1, 0, 1, 0, 1,
		1, 0, 1, 0, 1,
		1, 1, 1, 1, 1,
		]
	public var colorA: UIColor = .red
	public var colorB: UIColor = .green
	public var colorAB: UIColor = .blue
	public var frequency: Int16 = 2000
	public var delay: Int16 = 200
	
	func gen_button(address: Int16, color: UIColor, image: [UInt8]) -> [UInt8] {
		return [
			movi16(address, .r4),
			notify(address: .r4, value: .r4),
			movi16(DashboardItemType.Display.rawValue, .r4),
			notify(address: .r4, value: .r4),
			movi16(DashboardItemType.RGB.rawValue, .r4),
			notify(address: .r4, value: .r4),
			
			rgb_on(color: color),
			showGrid(image),
			ret(),
			].flatMap { $0 }
	}
	
	public func build() -> ProgramBuildResult {
		
		let buttonA: [UInt8] = gen_button(
			address: DashboardItemType.ButtonA.rawValue,
			color: colorA,
			image: imageA
		)
		
		let buttonB: [UInt8] = gen_button(
			address: DashboardItemType.ButtonB.rawValue,
			color: colorB,
			image: imageB
		)
		
		let buttonAB: [UInt8] = gen_button(
			address: DashboardItemType.ButtonAB.rawValue,
			color: colorAB,
			image: imageAB
		)
		
		let onButton: [UInt8] = [
			cmpi16(Button.a.rawValue, .r0),
			beq(onTrue: buttonA,
				onFalse: [cmpi16(Button.b.rawValue, .r0),
						  beq(onTrue: buttonB,
							  onFalse: [cmpi16(Button.ab.rawValue, .r0),
										beq(onTrue: buttonAB,
											onFalse: ret())]
								.flatMap { $0 })]
					.flatMap { $0 })
			].flatMap { $0 }
		
		let onPin: [UInt8] = [
			movi16(DashboardItemType.Pin.rawValue, .r4),
			notify(address: .r4, value: .r4),
			movi16(DashboardItemType.Display.rawValue, .r4),
			notify(address: .r4, value: .r4),
			showNumber(.r0),
			ret(),
			].flatMap { $0 }
		
		
		let onShake: [UInt8] = [
			cmpi16(Gesture.shake.rawValue, .r0),
			rne(),
			movi16(DashboardItemType.Shake.rawValue, .r4),
			notify(address: .r4, value: .r4),
			movi16(DashboardItemType.Sound.rawValue, .r4),
			notify(address: .r4, value: .r4),
			movi16(frequency, .r0),
			sound_on(.r0),
			movi16(delay, .r0),
			sleep(.r0),
			sound_off(),
			ret(),
			].flatMap { $0 }
		
		let code: [UInt8] = [
			onButton,
			onPin,
			onShake,
			].flatMap { $0 }
		
		let methods: [UInt16] = [
			0xffff,
			0xffff,
			0x0000,
			UInt16(onButton.count),
			UInt16(onButton.count + onPin.count),
			]
		
		return ProgramBuildResult(code: code, methods: methods)
	}
	
	public override init() {
	}
}
