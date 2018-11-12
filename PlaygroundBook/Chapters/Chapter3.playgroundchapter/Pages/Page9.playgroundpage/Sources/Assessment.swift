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

        guard let mColor0 = miniColor(from: values[0]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let mColor1 = miniColor(from: values[1]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let mColor2 = miniColor(from: values[2]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let mColor3 = miniColor(from: values[3]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let correct = CalliopeImage(from: values[4]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let wrong = CalliopeImage(from: values[5]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        let p = BookProgramCommandCombination()
        p.color0 = mColor0.color
        p.color1 = mColor1.color
        p.color2 = mColor2.color
        p.color3 = mColor3.color
        p.correct = correct
        p.wrong = wrong
        
        //return (.pass(message: success), p)
        return (nil, p)
     }
 }

