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

        guard let img1 = CalliopeImage(from: values[0]) else {
            LogNotify.log("img1")
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let delay = UInt16(values[1]) else {
            LogNotify.log("delay")
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        LogNotify.log("img2 \(values[2])")
        
        guard let img2 = CalliopeImage(from: values[2]) else {
            LogNotify.log("img2")
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        let p = BookProgramCommandSleep()
        p.image1 = img1
        p.delay = Int16(delay)
        p.image2 = img2
        
        //return (.pass(message: success), p)
        return (nil, p)
     }
 }

