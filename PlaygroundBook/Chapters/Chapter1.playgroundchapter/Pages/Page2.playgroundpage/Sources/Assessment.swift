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
        
        guard let num = UInt16(values[0]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        let p = BookProgramOutputNumber()
        p.n = Int16(num)
        
        return (nil, p)
    }
}

