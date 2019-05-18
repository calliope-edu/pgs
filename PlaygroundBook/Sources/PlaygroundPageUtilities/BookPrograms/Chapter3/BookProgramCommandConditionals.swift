// OK
public final class BookProgramCommandConditionals: ProgramBase, Program {

	public static let assessment: AssessmentBlock = { values in

		let success = "bookProgramCommandConditionals.success".localized
		let solution = "bookProgramCommandConditionals.solution".localized

		guard let start = Int(values[0]) else {
			return (.fail(hints: [], solution: ""), nil)
		}

		guard let stop = Int(values[1]) else {
			return (.fail(hints: [], solution: ""), nil)
		}

		guard start > Int16.min else {
			return (.fail(hints: ["bookProgramCommandConditionals.hintTooLowStart"], solution: solution), nil)
		}

		guard start < Int16.max - 1 else {
			return (.fail(hints: ["bookProgramCommandConditionals.hintTooHighStart"], solution: solution), nil)
		}

		guard stop > Int16.min + 1 else {
			return (.fail(hints: ["bookProgramCommandConditionals.hintTooLowStop"], solution: solution), nil)
		}

		guard stop < Int16.max else {
			return (.fail(hints: ["bookProgramCommandConditionals.hintTooHighStop"], solution: solution), nil)
		}

		guard start < stop else {
			return (.fail(hints: ["bookProgramCommandConditionals.startNotLowerStop"], solution: solution), nil)
		}

		guard let r = Int(values[2]) else {
			return (.fail(hints: [], solution: ""), nil)
		}

		let s1 = values[3]
		guard s1.unicodeScalars.reduce(true, { (isAscii, char) in isAscii && char.isASCII }) else {
			//user can accidentially input characters that cannot be displayed
			return (.fail(hints: ["bookProgramCommandConditionals.hintNoAsciiTextTrue".localized], solution: solution), nil)
		}

		let s2 = values[4]
		guard s2.unicodeScalars.reduce(true, { (isAscii, char) in isAscii && char.isASCII }) else {
			//user can accidentially input characters that cannot be displayed
			return (.fail(hints: ["bookProgramCommandConditionals.hintNoAsciiTextFalse".localized], solution: solution), nil)
		}


		let p = BookProgramCommandConditionals()
		p.start =  Int16(start)
		p.stop =  Int16(stop)
		p.r =  Int16(r)
		p.textTrue = s1
		p.textFalse = s2

		return (.pass(message: success), p)
	}

	public var textTrue: String = "w"
    public var textFalse: String = "n"
    public var start: Int16 = 0
    public var stop: Int16 = 2
    public var r: Int16 = 1

    public func build() -> ProgramBuildResult {

        let printTrue: [UInt8] =
            showText(textTrue) +
            ret()

        let printFalse: [UInt8] =
            showText(textFalse) +
            ret()

        let code: [UInt8] = [

            cmpi16(Gesture.shake.rawValue, .r0),
            rne(),
            movi16(NotificationAddress.shake.rawValue, .r4),
            notify(address: .r4, value: .r4),

			movi16(NotificationAddress.display.rawValue, .r4),
			notify(address: .r4, value: .r4),

			movi16(start, .r1),
			movi16(stop + 1, .r2),
			sub(.r1, .r2),
			random(.r2),
			add(.r1, .r2),

			cmpi16(r, .r2),
			beq(onTrue: printTrue, onFalse: printFalse)

        ].flatMap { $0 }

        let methods: [UInt16] = [
            0xffff,
            0xffff,
            0xffff,
            0xffff,
            0x0000,
        ]

        return ProgramBuildResult(code: code, methods: methods)
    }

    public override init() {
    }
}
