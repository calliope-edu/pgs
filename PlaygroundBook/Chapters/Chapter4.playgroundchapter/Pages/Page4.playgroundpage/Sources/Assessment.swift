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
        
        guard let threshold = UInt16(values[0]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        guard let mColor = miniColor(from: values[1]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        let p = BookProgramProjectClap()
        p.color = mColor.color
        p.threshold = Int16(threshold)
        
        // return (.pass(message: success), p)
        return (nil, p)
     }
 }


