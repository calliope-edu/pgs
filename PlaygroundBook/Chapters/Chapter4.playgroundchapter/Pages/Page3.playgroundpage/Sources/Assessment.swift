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
        
        guard let freq0 = miniSound(from: values[0]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        guard let mColor0 = miniColor(from: values[1]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        guard let freq1 = miniSound(from: values[2]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        guard let mColor1 = miniColor(from: values[3]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        guard let freq2 = miniSound(from: values[4]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        guard let mColor2 = miniColor(from: values[5]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        guard let freq3 = miniSound(from: values[6]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        guard let mColor3 = miniColor(from: values[7]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        let p = BookProgramProjectPiano()
        p.color0 = mColor0.color
        p.frequency0 = Int16(freq0.rawValue)
        p.color1 = mColor1.color
        p.frequency1 = Int16(freq1.rawValue)
        p.color2 = mColor2.color
        p.frequency2 = Int16(freq2.rawValue)
        p.color3 = mColor3.color
        p.frequency3 = Int16(freq3.rawValue)

        // return (.pass(message: success), p)
        return (nil, p)
     }
 }
