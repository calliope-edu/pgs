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
        
        guard let start = Int(values[0]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let stop = Int(values[1]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        let p = BookProgramCommandRandom()
        p.start = Int16(start)
        p.stop = Int16(stop)
        
        //return (.pass(message: success), p)
        return (nil, p)
     }
 }

