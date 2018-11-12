import Foundation
import PlaygroundSupport

let success = "page.success".localized
let hints = [
    "page.hint1".localized,
    "page.hint2".localized,
    "page.hint3".localized
]
let solution = "page.solution".localized

let time_hint = [ "page.hint.time".localized ]
let time_solution = "page.solution.time".localized

public func assessment() -> AssessmentBlock {
     return { values in

        guard let speed = UInt16(values[0]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        //if speed < 100 {
            //return (.fail(hints: time_hint, solution: time_solution), nil)
        //}
        
        guard let img1 = CalliopeImage(from: values[1]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let img2 = CalliopeImage(from: values[2]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let img3 = CalliopeImage(from: values[3]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        let p = BookProgramProjectRockPaperScissors()
        p.speed = Int16(speed)
        p.image1 = img1
        p.image2 = img2
        p.image3 = img3

        // return (.pass(message: success), p)
        return (nil, p)
     }
}

