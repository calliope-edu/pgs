// NOK 22
public final class BookProgramOutputString: ProgramBase, Program {
	
	public static let assessment: AssessmentBlock = { values in
		
		let success = "bookProgramOutputString.success".localized

		let solution = "bookProgramOutputString.solution".localized
		
		guard values.count > 0 else {
			//this only happens if chapter is not designed correctly
			return (.fail(hints: [], solution: ""), nil)
		}
		
		guard values[0].unicodeScalars.reduce(true, { (isAscii, char) in isAscii && char.isASCII }) else {
			//user can accidentially input characters that cannot be displayed
			return (.fail(hints: ["bookProgramOutputString.hintNoAscii".localized], solution: solution), nil)
		}
		
		let p = BookProgramOutputString()
		p.s = values[0]
		
		return (.pass(message: success), p)
	}
	
	public var s: String = "foo"
	
	public func build() -> ProgramBuildResult {
		
		let code: [UInt8] = [
			
			movi16(NotificationAddress.display.rawValue, .r4),
			notify(address: .r4, value: .r4),
			showText(s),
			
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
