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

        var o: Int = 0

        let image1:[UInt8] = values[o+0...o+24].flatMap{ UInt8($0) }
        guard image1.count == 25 else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        guard let mColor1 = miniColor(from: values[o+25]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        o += 26
        
        let image2:[UInt8] = values[o+0...o+24].flatMap{ UInt8($0) }
        guard image2.count == 25 else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        guard let mColor2 = miniColor(from: values[o+25]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        o += 26

        let image3:[UInt8] = values[o+0...o+24].flatMap{ UInt8($0) }
        guard image3.count == 25 else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        guard let mColor3 = miniColor(from: values[o+25]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        o += 26

        guard let freq = miniSound(from: values[o+0]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        let p = BookProgramInputCombination()
        p.imageA = image1
        p.colorA = mColor1.color
        p.imageB = image2
        p.colorB = mColor2.color
        p.imageAB = image3
        p.colorAB = mColor3.color
        p.frequency = Int16(freq.rawValue)
        
        //return (.pass(message: success), p)
        return (nil, p)
     }
 }

