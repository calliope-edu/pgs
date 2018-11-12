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
        
        guard let factor = UInt16(values[0]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        guard let offset = UInt16(values[1]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        let p = BookProgramProjectTheremin()
        p.factor = Int16(factor)
        p.offset = Int16(offset)

        // return (.pass(message: success), p)
        return (nil, p)
     }
 }
