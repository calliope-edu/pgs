// OK
import UIKit

public final class BookProgramProjectPiano: ProgramBase, Program {

    public var color0: UIColor = .red
    public var color1: UIColor = .green
    public var color2: UIColor = .blue
    public var color3: UIColor = .white

    public var frequency0: Int16 = 1000
    public var frequency1: Int16 = 2000
    public var frequency2: Int16 = 3000
    public var frequency3: Int16 = 4000

    func check(pin: Int16, color: UIColor, frequency: Int16, offset: Int8) -> [UInt8] {
        return [
            movi16(pin, .r0),
            mov(.r0, .r1),
            self.pin(.r0),
            beq(11),
            rgb_on(color: color),
            movi16(frequency, .r2),
            bra(offset),
        ].flatMap { $0 }
    }

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            check(pin: 0, color: color0, frequency: frequency0, offset: 67),
            check(pin: 1, color: color1, frequency: frequency1, offset: 45),
            check(pin: 2, color: color2, frequency: frequency2, offset: 23),
            check(pin: 3, color: color3, frequency: frequency3, offset: 1),
            ret(),

            movi16(NotificationAddress.pin.rawValue, .r4),
            notify(address: .r4, value: .r1),
            movi16(NotificationAddress.rgb.rawValue, .r4),
            notify(address: .r4, value: .r4),
            movi16(NotificationAddress.sound.rawValue, .r4),
            notify(address: .r4, value: .r4),

            sound_on(.r2),

            mov(.r1, .r0),
            pin(.r0),
            bne(-7),

            sound_off(),
            rgb_off(),

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
