import Foundation
import UIKit

extension CGRect {
    func insetBy(percentage: CGFloat) -> CGRect {
        let startWidth = self.width
        let startHeight = self.height
        let adjustmentWidth = (startWidth-(startWidth * percentage)) * 0.5
        let adjustmentHeight = (startHeight-(startHeight * percentage)) * 0.5
        return self.insetBy(dx: adjustmentWidth, dy: adjustmentHeight)
    }
}
