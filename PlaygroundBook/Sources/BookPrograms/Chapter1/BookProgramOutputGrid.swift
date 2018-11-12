// OK 43
public final class BookProgramOutputGrid: ProgramBase, Program {

    public var image: [UInt8] = [
        1, 1, 1, 1, 1,
        1, 0, 1, 0, 1,
        1, 0, 1, 0, 1,
        1, 0, 1, 0, 1,
        1, 1, 1, 1, 1,
    ]

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
            showGrid(image)

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
