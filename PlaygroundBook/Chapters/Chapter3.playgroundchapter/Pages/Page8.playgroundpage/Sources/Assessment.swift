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
        
        guard let n = Int(values[2]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let textTrue = values[3] as? String else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let textFalse = values[4] as? String else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        let p = BookProgramCommandConditionals()
        p.start =  Int16(start)
        p.stop =  Int16(stop)
        p.n =  Int16(n)
        p.textTrue = textTrue
        p.textFalse = textFalse
        
        //return (.pass(message: success), p)
        return (nil, p)
    }
}

