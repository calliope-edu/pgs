// OK 43
public final class BookProgramOutputGrid: ProgramBase, Program {
	
	public static let assessment: AssessmentBlock = { values in
		
		let success = "bookProgramOutputGrid.success".localized
		let solution = "bookProgramOutputGrid.solution".localized
		
		let grid:[UInt8] = values.compactMap { UInt8($0) }
		
		guard grid.count == 25 else {
			return (.fail(hints: ["bookProgramOutputGrid.tooManyOrFewEntries".localized], solution: solution), nil)
		}

		guard grid.reduce(true, { (isGrid, entry) in isGrid && entry < 2 }) else {
			return (.fail(hints: ["bookProgramOutputGrid.otherThanZeroOrOne".localized], solution: solution), nil)
		}
		
		let p = BookProgramOutputGrid()
		p.image = grid
		
		return (.pass(message: success), p)
	}
	
	public var image: [UInt8] = [
		1, 1, 1, 1, 1,
		1, 0, 1, 0, 1,
		1, 0, 1, 0, 1,
		1, 0, 1, 0, 1,
		1, 1, 1, 1, 1,
		]
	
	public func build() -> ProgramBuildResult {
		
		let code: [UInt8] = [
			
			movi16(DashboardItemType.Display.rawValue, .r4),
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
