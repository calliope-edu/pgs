// OK 23
public final class BookProgramOutputImage: ProgramBase, Program {

    public var image: CalliopeImage = .smiley

    public func build() -> ProgramBuildResult {

        let code: [UInt8] = [

            movi16(NotificationAddress.display.rawValue, .r4),
            notify(address: .r4, value: .r4),
            movi16(image.rawValue, .r1),
            showImage(.r1),

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
