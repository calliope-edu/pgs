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
        let p = ProgramBlink()

        guard let n = Int(values[0]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        if(n < 200) {
            return (.fail(hints: hints, solution: solution), nil)
        }

        p.n = n
        return (.pass(message: success), p)
     }
 }

