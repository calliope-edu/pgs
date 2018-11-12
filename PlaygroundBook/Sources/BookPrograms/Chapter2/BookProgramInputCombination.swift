// OK
import UIKit

public final class BookProgramInputCombination: ProgramBase, Program {

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
            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
            movi16(NotificationAddress.rgb.rawValue, .r4),
            notify(address: .r4, value: .r4),

            rgb_on(color: color),
            showGrid(image),
            ret(),
        ].flatMap { $0 }
    }

    public func build() -> ProgramBuildResult {

        let buttonA: [UInt8] = gen_button(
            address: NotificationAddress.buttonA.rawValue,
            color: colorA,
            image: imageA
        )

        let buttonB: [UInt8] = gen_button(
            address: NotificationAddress.buttonB.rawValue,
            color: colorB,
            image: imageB
        )

        let buttonAB: [UInt8] = gen_button(
            address: NotificationAddress.buttonAB.rawValue,
            color: colorAB,
            image: imageAB
        )

        let onButton: [UInt8] = [
            cmpi16(Button.a.rawValue, .r0),
            beq(13),
            cmpi16(Button.b.rawValue, .r0),
            beq(Int8(7 + buttonA.count)),
            cmpi16(Button.ab.rawValue, .r0),
            beq(Int8(1 + buttonA.count + buttonB.count)),
            ret(),
            buttonA,
            buttonB,
            buttonAB,
        ].flatMap { $0 }

        let onPin: [UInt8] = [
            movi16(NotificationAddress.pin.rawValue, .r4),
            notify(address: .r4, value: .r4),
            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
            showNumber(.r0),
            ret(),
        ].flatMap { $0 }


        let onShake: [UInt8] = [
            cmpi16(Gesture.shake.rawValue, .r0),
            rne(),
            movi16(NotificationAddress.shake.rawValue, .r4),
            notify(address: .r4, value: .r4),
            movi16(NotificationAddress.sound.rawValue, .r4),
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
