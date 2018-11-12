import Foundation
import PlaygroundSupport

let success = "page.success".localized
let hints = [
    "page.hint1".localized,
    "page.hint2".localized,
    "page.hint3".localized
]
let solution = "page.solution".localized

public func assessment() -> AssessmentBlock {
     return { values in
        
        let grid:[UInt8] = values.flatMap{ UInt8($0) }
        
        guard grid.count == 25 else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        let p = BookProgramOutputGrid()
        p.image = grid
        
        //return (.pass(message: success), p)
        return (nil, p)
     }
 }

