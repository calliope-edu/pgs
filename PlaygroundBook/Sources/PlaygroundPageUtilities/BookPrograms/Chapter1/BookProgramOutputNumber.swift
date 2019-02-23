// OK 23
public final class BookProgramOutputNumber: ProgramBase, Program {
	
	public static let assessment: AssessmentBlock = { values in
		
		let success = "page.success".localized
		let hints = [
			"page.hint1".localized,
			"page.hint2".localized,
			"page.hint3".localized
		]
		let solution = "page.solution".localized
		
		guard let num = UInt16(values[0]) else {
			return (.fail(hints: hints, solution: solution), nil)
		}
		
		let p = BookProgramOutputNumber()
		p.n = Int16(num)
		
		return (nil, p)
	}
	
	public var n: Int16 = 9
	
	public func build() -> ProgramBuildResult {
		
		let code: [UInt8] = [
			
			movi16(NotificationAddress.display.rawValue, .r4),
			notify(address: .r4, value: .r4),
			movi16(n, .r1),
			showNumber(.r1),
			
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
