import UIKit

extension ProgramBase {
    func ret() -> [UInt8] {
        return [0x00]
    }

    func req() -> [UInt8] {
        return [0x01]
    }

    func rne() -> [UInt8] {
        return [0x02]
    }

    func rgt() -> [UInt8] {
        return [0x03]
    }

    func rlt() -> [UInt8] {
        return [0x04]
    }

    func rge() -> [UInt8] {
        return [0x05]
    }

    func rle() -> [UInt8] {
        return [0x06]
    }

    func jsr(_ offset: Int8) -> [UInt8] {
        let o = UInt8(bitPattern: offset)
        return [0x07, o]
    }

    func bra(_ offset: Int8) -> [UInt8] {
        let o = UInt8(bitPattern: offset)
        return [0x10, o]
    }

    func beq(_ offset: Int8) -> [UInt8] {
        let o = UInt8(bitPattern: offset)
        return [0x11, o]
    }

    func bne(_ offset: Int8) -> [UInt8] {
        let o = UInt8(bitPattern: offset)
        return [0x12, o]
    }

    func bgt(_ offset: Int8) -> [UInt8] {
        let o = UInt8(bitPattern: offset)
        return [0x13, o]
    }

    func blt(_ offset: Int8) -> [UInt8] {
        let o = UInt8(bitPattern: offset)
        return [0x14, o]
    }

    func bge(_ offset: Int8) -> [UInt8] {
        let o = UInt8(bitPattern: offset)
        return [0x15, o]
    }

    func ble(_ offset: Int8) -> [UInt8] {
        let o = UInt8(bitPattern: offset)
        return [0x16, o]
    }

    func bra16(_ offset: Int16) -> [UInt8] {
        let o = UInt16(bitPattern: offset)
        return [0x17, o.hi(), o.lo()]
    }

    func cmp(_ ra: Register, _ rb: Register) -> [UInt8] {
        return [0x20, ra.rawValue, rb.rawValue]
    }

    func cmpi16(_ i: Int16, _ rb: Register) -> [UInt8] {
        let i16 = UInt16(bitPattern: i)
        return [0x21, i16.hi(), i16.lo(), rb.rawValue]
    }

    func mov(_ ra: Register, _ rb: Register) -> [UInt8] {
        return [0x22, ra.rawValue, rb.rawValue]
    }

    func movi16(_ i: Int16, _ register: Register) -> [UInt8] {
        let u: UInt16 = UInt16(i)
        return [
            0x23, u.hi(), u.lo(), register.rawValue,
        ]
    }

    func add(_ ra: Register, _ rb: Register) -> [UInt8] {
        return [0x30, ra.rawValue, rb.rawValue]
    }

    func sub(_ ra: Register, _ rb: Register) -> [UInt8] {
        return [0x31, ra.rawValue, rb.rawValue]
    }

    func mul(_ ra: Register, _ rb: Register) -> [UInt8] {
        return [0x32, ra.rawValue, rb.rawValue]
    }

    func div(_ ra: Register, _ rb: Register) -> [UInt8] {
        return [0x33, ra.rawValue, rb.rawValue]
    }

    func sleep(_ rx: Register) -> [UInt8] {
        return [0x40, rx.rawValue]
    }

    func random(_ rx: Register) -> [UInt8] {
        return [0x41, rx.rawValue]
    }

    func time(_ rx: Register) -> [UInt8] {
        return [0x42, rx.rawValue]
    }

    func temperature(_ rx: Register) -> [UInt8] {
        return [0x50, rx.rawValue]
    }

    func noise(_ rx: Register) -> [UInt8] {
        return [0x51, rx.rawValue]
    }

    func brightness(_ rx: Register) -> [UInt8] {
        return [0x52, rx.rawValue]
    }

    func button(_ rx: Register) -> [UInt8] {
        return [0x60, rx.rawValue]
    }

    func pin(_ rx: Register) -> [UInt8] {
        return [0x61, rx.rawValue]
    }

    func clear() -> [UInt8] {
        return [0x70]
    }

    func showNumber(_ number: Register) -> [UInt8] {
        return [0x71, number.rawValue]
    }

    func showImage(_ image: Register) -> [UInt8] {
        return [0x72, image.rawValue]
    }

    func showGrid(_ grid: [UInt8]) -> [UInt8] {
        return [0x73] + grid
    }

    func showText(_ text: String) -> [UInt8] {
        let len = text.count + 1
        return
            [0x74, len.hi(), len.lo()]
            + text.ascii
            + [0x00]
    }

    func rgb_off() -> [UInt8] {
        return [0x80]
    }

    func rgb_on(color: UIColor) -> [UInt8] {
        return [
            0x81,
            UInt8(color.components.red * 255),
            UInt8(color.components.green * 255),
            UInt8(color.components.blue * 255),
            0x00,
        ]
    }

    func sound_off() -> [UInt8] {
        return [0x90]
    }

    func sound_on(_ frequency: Register) -> [UInt8] {
        return [
            0x91, frequency.rawValue,
        ]
    }

    func gesture(_ rx: Register) -> [UInt8] {
        return [0xa0, rx.rawValue]
    }

    func pitch(_ rx: Register) -> [UInt8] {
        return [0xa1, rx.rawValue]
    }

    func roll(_ rx: Register) -> [UInt8] {
        return [0xa2, rx.rawValue]
    }

    func position(x: Register, y: Register, z: Register) -> [UInt8] {
        return [0xa3, x.rawValue, y.rawValue, z.rawValue]
    }

    func notify(address: Register, value: Register) -> [UInt8] {
        return [0xf0, address.rawValue, value.rawValue]
    }

    func log(_ rx: Register) -> [UInt8] {
        return [0xf1, rx.rawValue]
    }
}
