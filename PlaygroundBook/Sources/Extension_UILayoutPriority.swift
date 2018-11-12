import Foundation
import UIKit

extension UILayoutPriority {
    static func higherPriority(plus: Float) -> UILayoutPriority {
        let rawPriority = UILayoutPriority.defaultHigh.rawValue
        return UILayoutPriority(rawPriority + plus)
    }
    
    static func lowerPriority(minus: Float) -> UILayoutPriority {
        let rawPriority = UILayoutPriority.defaultLow.rawValue
        return UILayoutPriority(rawPriority - minus)
    }
}
