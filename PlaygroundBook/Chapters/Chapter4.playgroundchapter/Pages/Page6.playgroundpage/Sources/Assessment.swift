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

        guard let temp_cold = UInt16(values[0]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let color_cold = miniColor(from: values[1]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        guard let image_cold = CalliopeImage(from: values[2]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        guard let temp_normal = UInt16(values[3]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let color_normal = miniColor(from: values[4]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        guard let image_normal = CalliopeImage(from: values[5]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }
        
        guard let color_hot = miniColor(from: values[6]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        guard let image_hot = CalliopeImage(from: values[7]) else {
            return (.fail(hints: hints, solution: solution), nil)
        }

        //convert units
        let temp_cold_converted = ValueLocalizer.current.delocalizeTemperature(temp_cold)
        let temp_noraml_converted = ValueLocalizer.current.delocalizeTemperature(temp_normal)

        let p = BookProgramProjectThermometer()
        p.temp_cold = Int16(temp_cold_converted)
        p.temp_normal = Int16(temp_normal_converted)
        p.color_cold = color_cold.color
        p.color_normal = color_normal.color
        p.color_hot = color_hot.color
        p.image_cold = image_cold
        p.image_normal = image_normal
        p.image_hot = image_hot
        
        // return (.pass(message: success), p)
        return (nil, p)
     }
 }
