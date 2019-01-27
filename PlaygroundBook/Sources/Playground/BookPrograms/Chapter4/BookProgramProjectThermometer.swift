// OK
import UIKit

public final class BookProgramProjectThermometer: ProgramBase, Program {

    public var temp_cold: Int16 = 15
    public var temp_normal: Int16 = 23

    public var color_cold: UIColor = .blue
    public var color_normal: UIColor = .green
    public var color_hot: UIColor = .red

    public var image_cold: CalliopeImage = .sad
    public var image_normal: CalliopeImage = .heart
    public var image_hot: CalliopeImage = .smiley

    public var delay: Int16 = 5000

    func below(temperature: Int16, color: UIColor, image: CalliopeImage) -> [UInt8] {
        return [
            movi16(temperature, .r2),
            cmp(.r2, .r1),
            blt(32),
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

    func show(image: CalliopeImage) -> [UInt8] {
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
