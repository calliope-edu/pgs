// OK 23
public final class BookProgramOutputImage: ProgramBase, Program {
	
	public static let assessment: AssessmentBlock = { values in
		
		let success = "bookProgramOutputImage.success".localized
		
		guard let img = miniImage(from: values[0]) else {
			//static type checker should prevent this from happening
			return (.fail(hints: [], solution: ""), nil)
		}
		
		let p = BookProgramOutputImage()
		p.image = img
		
		return (.pass(message: success), p)
	}
	
	public var image: miniImage = .smiley
	
	public func build() -> ProgramBuildResult {
		
		let code: [UInt8] = [
			
			movi16(DashboardItemType.Display.rawValue, .r4),
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
