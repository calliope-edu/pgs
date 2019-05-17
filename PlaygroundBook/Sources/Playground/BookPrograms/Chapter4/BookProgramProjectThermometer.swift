// OK
import UIKit

public final class BookProgramProjectThermometer: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "page.success".localized
		let hints = [
			"page.hint1".localized,
			"page.hint2".localized,
			"page.hint3".localized
		]
		let solution = "page.solution".localized

		guard let temp_cold = UInt16(values[0]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let color_cold = miniColor(from: values[1]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let image_cold = miniImage(from: values[2]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let temp_normal = UInt16(values[3]),
			temp_normal > temp_cold else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let color_normal = miniColor(from: values[4]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let image_normal = miniImage(from: values[5]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let color_hot = miniColor(from: values[6]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		guard let image_hot = miniImage(from: values[7]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}

		//convert units
		let temp_cold_converted = ValueLocalizer.current.delocalizeTemperature(localized: Double(temp_cold))
		let temp_normal_converted = ValueLocalizer.current.delocalizeTemperature(localized: Double(temp_normal))

		let p = BookProgramProjectThermometer()
		p.temp_cold = Int16(temp_cold_converted)
		p.temp_normal = Int16(temp_normal_converted)
		p.color_cold = color_cold.color
		p.color_normal = color_normal.color
		p.color_hot = color_hot.color
		p.image_cold = image_cold
		p.image_normal = image_normal
		p.image_hot = image_hot

		// return (.pass(message: success), p)
		return (nil, p)
	}

    public var temp_cold: Int16 = 15
    public var temp_normal: Int16 = 23

    public var color_cold: UIColor = .blue
    public var color_normal: UIColor = .green
    public var color_hot: UIColor = .red

    public var image_cold: miniImage = .sad
    public var image_normal: miniImage = .heart
    public var image_hot: miniImage = .smiley

    public var delay: Int16 = 5000

    func below(temperature: Int16, color: UIColor, image: miniImage) -> [UInt8] {
        return [
            cmpi16(temperature, .r1),
            ble(32),
            show(color: color),
            show(image: image),
            ret(),
        ].flatMap { $0 }
    }

    func show(color: UIColor) -> [UInt8] {
        return [
            movi16(NotificationAddress.rgb.rawValue, .r4),
            notify(address: .r4, value: .r4),
            rgb_on(color: color),
        ].flatMap { $0 }
    }

    func show(image: miniImage) -> [UInt8] {
        return [
            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
            movi16(image.rawValue, .r0),
            showImage(.r0),
            movi16(delay, .r0),
            sleep(.r0),
        ].flatMap { $0 }
    }

    func read() -> [UInt8] {
        return [
            temperature(.r1),
            movi16(NotificationAddress.temperature.rawValue, .r4),
            notify(address: .r4, value: .r1),
        ].flatMap { $0 }
    }

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [
            read(),
            below(temperature: temp_cold, color: color_cold, image: image_cold),
            below(temperature: temp_normal, color: color_normal, image: image_normal),
            show(color: color_hot),
            show(image: image_hot),
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
