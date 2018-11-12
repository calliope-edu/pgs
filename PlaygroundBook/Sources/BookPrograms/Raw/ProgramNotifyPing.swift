public final class ProgramNotifyPing: ProgramBase, Program {
    public var address: Int = 255
    public var value: Int = 25
    public var delay: Int = 3000
    public var blink: Int = 500

    public func build() -> ProgramBuildResult {
        let code: [UInt8] = [
            0x81, 0xff, 0x00, 0xc8, 0x78,
            0x23, delay.hi(), delay.lo(), 0x00,
            0x23, address.hi(), address.lo(), 0x01,
            0x23, value.hi(), value.lo(), 0x02,
            0x23, blink.hi(), blink.lo(), 0x04,
            0x40, 0x04,
            0x80,
            0xf0, 0x01, 0x02,
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
