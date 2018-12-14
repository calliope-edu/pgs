import Foundation
import UIKit

// https://crunchybagel.com/working-with-hex-colors-in-swift-3/
extension UIColor {

	convenience init(hex: Int) {
		let r = (hex >> 16) & 0xff
		let g = (hex >> 8) & 0xff
		let b = hex & 0xff
		self.init(red:CGFloat(r)/255.0, green:CGFloat(g)/255.0, blue:CGFloat(b)/255.0, alpha: 1.0)
	}

    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    public class var random:UIColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }

    public class func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(Double.pi) / 180
    }
}
