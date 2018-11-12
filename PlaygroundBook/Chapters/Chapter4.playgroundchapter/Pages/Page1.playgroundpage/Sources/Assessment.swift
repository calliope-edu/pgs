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
        
        guard let freq = miniSound(from: values[2]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let delay = Int(values[3]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        let p = BookProgramProjectDice()
        p.start = Int16(start)
        p.stop = Int16(stop)
        p.frequency = Int16(freq.rawValue)
        p.delay = Int16(delay)

        // return (.pass(message: success), p)
        return (nil, p)
     }
 }


public var start: Int16 = 1
public var stop: Int16 = 6

public var frequency: Int16 = 2000
public var delay: Int16 = 200
