import UIKit

public class ProgramBuilder {
    var code: [UInt8] = []
    var base = ProgramBase()

    func build() -> [UInt8] {
        return code
    }

    func ret() -> ProgramBuilder {
        code += base.ret()
        return self
    }

    func req() -> ProgramBuilder {
        code += base.req()
        return self
    }

    func rne() -> ProgramBuilder {
        code += base.rne()
        return self
    }

    func rgt() -> ProgramBuilder {
        code += base.rgt()
        return self
    }

    func rlt() -> ProgramBuilder {
        code += base.rlt()
        return self
    }

    func rge() -> ProgramBuilder {
        code += base.rge()
        return self
    }

    func rle() -> ProgramBuilder {
        code += base.rle()
        return self
    }

    func jsr(_ offset: Int8) -> ProgramBuilder {
        code += base.jsr(offset)
        return self
    }

    func bra(_ offset: Int8) -> ProgramBuilder {
        code += base.bra(offset)
        return self
    }

    func beq(_ offset: Int8) -> ProgramBuilder {
        code += base.beq(offset)
        return self
    }

    func bne(_ offset: Int8) -> ProgramBuilder {
        code += base.bne(offset)
        return self
    }

    func bgt(_ offset: Int8) -> ProgramBuilder {
        code += base.bgt(offset)
        return self
    }

    func blt(_ offset: Int8) -> ProgramBuilder {
        code += base.blt(offset)
        return self
    }

    func bge(_ offset: Int8) -> ProgramBuilder {
        code += base.bge(offset)
        return self
    }

    func ble(_ offset: Int8) -> ProgramBuilder {
        code += base.ble(offset)
        return self
    }

    func bra16(_ offset: Int16) -> ProgramBuilder {
        code += base.bra16(offset)
        return self
    }

    func cmp(_ ra: Register, _ rb: Register) -> ProgramBuilder {
        code += base.cmp(ra, rb)
        return self
    }

    func cmpi16(_ i: Int16, _ rb: Register) -> ProgramBuilder {
        code += base.cmpi16(i, rb)
        return self
    }

    func mov(_ ra: Register, _ rb: Register) -> ProgramBuilder {
        code += base.mov(ra, rb)
        return self
    }

    func movi16(_ i: Int16, _ rb: Register) -> ProgramBuilder {
        code += base.movi16(i, rb)
        return self
    }

    func add(_ ra: Register, _ rb: Register) -> ProgramBuilder {
        code += base.add(ra, rb)
        return self
    }

    func sub(_ ra: Register, _ rb: Register) -> ProgramBuilder {
        code += base.sub(ra, rb)
        return self
    }

    func mul(_ ra: Register, _ rb: Register) -> ProgramBuilder {
        code += base.mul(ra, rb)
        return self
    }

    func div(_ ra: Register, _ rb: Register) -> ProgramBuilder {
        code += base.div(ra, rb)
        return self
    }

    func sleep(_ rx: Register) -> ProgramBuilder {
        code += base.sleep(rx)
        return self
    }

    func random(_ rx: Register) -> ProgramBuilder {
        code += base.random(rx)
        return self
    }

    func time(_ rx: Register) -> ProgramBuilder {
        code += base.time(rx)
        return self
    }

    func temperature(_ rx: Register) -> ProgramBuilder {
        code += base.temperature(rx)
        return self
    }

    func noise(_ rx: Register) -> ProgramBuilder {
        code += base.noise(rx)
        return self
    }

    func brightness(_ rx: Register) -> ProgramBuilder {
        code += base.brightness(rx)
        return self
    }

    func button(_ rx: Register) -> ProgramBuilder {
        code += base.button(rx)
        return self
    }

    func pin(_ rx: Register) -> ProgramBuilder {
        code += base.pin(rx)
        return self
    }

    func clear() -> ProgramBuilder {
        code += base.clear()
        return self
    }

    func showNumber(_ number: Register) -> ProgramBuilder {
        code += base.showNumber(number)
        return self
    }

    func showImage(_ image: Register) -> ProgramBuilder {
        code += base.showImage(image)
        return self
    }

    func showGrid(_ grid: [UInt8]) -> ProgramBuilder {
        code += base.showGrid(grid)
        return self
    }

    func showText(_ text: String) -> ProgramBuilder {
        code += base.showText(text)
        return self
    }

    func rgb_off() -> ProgramBuilder {
        code += base.rgb_off()
        return self
    }

    func rgb_on(color: UIColor) -> ProgramBuilder {
        code += base.rgb_on(color: color)
        return self
    }

    func sound_off() -> ProgramBuilder {
        code += base.sound_off()
        return self
    }

    func sound_on(_ frequency: Register) -> ProgramBuilder {
        code += base.sound_on(frequency)
        return self
    }

    func gesture(_ rx: Register) -> ProgramBuilder {
        code += base.gesture(rx)
        return self
    }

    func pitch(_ rx: Register) -> ProgramBuilder {
        code += base.pitch(rx)
        return self
    }

    func roll(_ rx: Register) -> ProgramBuilder {
        code += base.roll(rx)
        return self
    }

    func position(x: Register, y: Register, z: Register) -> ProgramBuilder {
        code += base.position(x: x, y: y, z: z)
        return self
    }

    func notify(address: Register, value: Register) -> ProgramBuilder {
        code += base.notify(address: address, value: value)
        return self
    }

    func log(_ rx: Register) -> ProgramBuilder {
        code += base.log(rx)
        return self
    }
}
