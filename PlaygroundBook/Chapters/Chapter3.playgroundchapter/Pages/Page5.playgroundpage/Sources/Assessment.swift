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
        
        guard let name = values[0] as? String else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let age = Int16(values[1]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        let p = BookProgramCommandVariables()
        p.name = name
        p.age = age
        
        //return (.pass(message: success), p)
        return (nil, p)
     }
 }

