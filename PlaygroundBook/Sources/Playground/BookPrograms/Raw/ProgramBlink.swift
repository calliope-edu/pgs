public final class ProgramBlink: ProgramBase, Program {

    public var n: Int = 200

    public func build() -> ProgramBuildResult {
        let code: [UInt8] = [
            0x81, 0xff, 0x00, 0x00, 0x00,
            0x23, n.hi(), n.lo(), 0x00,
            0x40, 0x00,
            0x80,
            0x23, n.hi(), n.lo(), 0x00,
            0x40, 0x00,
        ]

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
