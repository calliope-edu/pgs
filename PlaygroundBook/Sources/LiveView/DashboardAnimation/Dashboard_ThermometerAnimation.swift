import UIKit

@IBDesignable
class Dashboard_ThermometerAnimation: UIView_DashboardItemAnimation, CAAnimationDelegate {
	
    //MARK: - animator
    
    override func run(_ completionBlock: @escaping ((Bool) -> Void)) {
        addThermometerAnimation(completionBlock: completionBlock)
    }
	
	//MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupProperties()
		setupLayers()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		setupProperties()
		setupLayers()
	}
	
	func setupProperties(){
	}
	
	func setupLayers() {
        self.textLabel = Layout.animationLabel(in: self, center: false)
        textLabelXConstraint = self.textLabel?.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        textLabelYConstraint = self.textLabel?.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        textLabelXConstraint?.isActive = true
        textLabelYConstraint?.isActive = true
        addSwoosh()
	}
    
    override func adjustFrames() {
        super.adjustFrames()
        if let detection_view = self.viewWithTag(34567) {
            detection_view.frame = bounds
        }
    }
	
	//MARK: - Animation Setup
	
	func addThermometerAnimation(totalDuration: CFTimeInterval = 0.5, endTime: CFTimeInterval = 1, completionBlock: ((_ finished: Bool) -> Void)? = nil){
        delay(time: totalDuration) {
            if let completionBlock = completionBlock {
                completionBlock(true)
                
            }
        }
	}
	
	//MARK: - Animation Cleanup
	
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
		
	}
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let inner_bounds = self.bounds.insetBy(percentage: 0.78)
        drawCanvas1(frame: inner_bounds)
    }
	
    func drawCanvas1(frame: CGRect = CGRect(x: 0, y: 0, width: 120, height: 120)) {
        //// General Declarations
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Color Declarations
        let fillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        
        //// Subframes
        let termometer_1_: CGRect = CGRect(x: frame.minX + fastFloor(frame.width * 0.41790 + 0.35) + 0.15, y: frame.minY + fastFloor(frame.height * 0.27000 + 0.1) + 0.4, width: fastFloor(frame.width * 0.57000 + 0.1) - fastFloor(frame.width * 0.41790 + 0.35) + 0.25, height: fastFloor(frame.height * 0.74333 + 0.3) - fastFloor(frame.height * 0.27000 + 0.1) - 0.2)
        
        
        //// termometer_1_
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 1.00000 * termometer_1_.height))
        bezier3Path.addLine(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 1.00000 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.44381 * termometer_1_.width, y: termometer_1_.minY + 0.99926 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.48168 * termometer_1_.width, y: termometer_1_.minY + 1.00000 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.46274 * termometer_1_.width, y: termometer_1_.minY + 1.00000 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.00359 * termometer_1_.width, y: termometer_1_.minY + 0.86377 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.21660 * termometer_1_.width, y: termometer_1_.minY + 0.99116 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.03199 * termometer_1_.width, y: termometer_1_.minY + 0.93446 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.15506 * termometer_1_.width, y: termometer_1_.minY + 0.73196 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + -0.01535 * termometer_1_.width, y: termometer_1_.minY + 0.81443 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.04146 * termometer_1_.width, y: termometer_1_.minY + 0.76583 * termometer_1_.height))
        bezier3Path.addLine(to: CGPoint(x: termometer_1_.minX + 0.15506 * termometer_1_.width, y: termometer_1_.minY + 0.10751 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.00000 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.15506 * termometer_1_.width, y: termometer_1_.minY + 0.04860 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.30890 * termometer_1_.width, y: termometer_1_.minY + 0.00000 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.84616 * termometer_1_.width, y: termometer_1_.minY + 0.10751 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.68995 * termometer_1_.width, y: termometer_1_.minY + 0.00000 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.84616 * termometer_1_.width, y: termometer_1_.minY + 0.04786 * termometer_1_.height))
        bezier3Path.addLine(to: CGPoint(x: termometer_1_.minX + 0.84616 * termometer_1_.width, y: termometer_1_.minY + 0.73196 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 1.00000 * termometer_1_.width, y: termometer_1_.minY + 0.84462 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.94556 * termometer_1_.width, y: termometer_1_.minY + 0.76141 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 1.00000 * termometer_1_.width, y: termometer_1_.minY + 0.80191 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.85326 * termometer_1_.width, y: termometer_1_.minY + 0.95434 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 1.00000 * termometer_1_.width, y: termometer_1_.minY + 0.88586 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.94793 * termometer_1_.width, y: termometer_1_.minY + 0.92563 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 1.00000 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.75859 * termometer_1_.width, y: termometer_1_.minY + 0.98380 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.63315 * termometer_1_.width, y: termometer_1_.minY + 1.00000 * termometer_1_.height))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.03903 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.28050 * termometer_1_.width, y: termometer_1_.minY + 0.10751 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.37991 * termometer_1_.width, y: termometer_1_.minY + 0.03903 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.28050 * termometer_1_.width, y: termometer_1_.minY + 0.06996 * termometer_1_.height))
        bezier3Path.addLine(to: CGPoint(x: termometer_1_.minX + 0.28050 * termometer_1_.width, y: termometer_1_.minY + 0.74080 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.25920 * termometer_1_.width, y: termometer_1_.minY + 0.75552 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.28050 * termometer_1_.width, y: termometer_1_.minY + 0.74669 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.27340 * termometer_1_.width, y: termometer_1_.minY + 0.75184 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.12903 * termometer_1_.width, y: termometer_1_.minY + 0.85935 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.16216 * termometer_1_.width, y: termometer_1_.minY + 0.78130 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.11483 * termometer_1_.width, y: termometer_1_.minY + 0.81959 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.45801 * termometer_1_.width, y: termometer_1_.minY + 0.96097 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.15033 * termometer_1_.width, y: termometer_1_.minY + 0.91237 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.28760 * termometer_1_.width, y: termometer_1_.minY + 0.95508 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.96171 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.47221 * termometer_1_.width, y: termometer_1_.minY + 0.96171 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.48641 * termometer_1_.width, y: termometer_1_.minY + 0.96171 * termometer_1_.height))
        bezier3Path.addLine(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.96171 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.76569 * termometer_1_.width, y: termometer_1_.minY + 0.92710 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.60002 * termometer_1_.width, y: termometer_1_.minY + 0.96171 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.69469 * termometer_1_.width, y: termometer_1_.minY + 0.94919 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.87693 * termometer_1_.width, y: termometer_1_.minY + 0.84462 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.83669 * termometer_1_.width, y: termometer_1_.minY + 0.90501 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.87693 * termometer_1_.width, y: termometer_1_.minY + 0.87555 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.74439 * termometer_1_.width, y: termometer_1_.minY + 0.75552 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.87693 * termometer_1_.width, y: termometer_1_.minY + 0.81001 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.82959 * termometer_1_.width, y: termometer_1_.minY + 0.77761 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.72309 * termometer_1_.width, y: termometer_1_.minY + 0.74080 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.73019 * termometer_1_.width, y: termometer_1_.minY + 0.75184 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.72309 * termometer_1_.width, y: termometer_1_.minY + 0.74669 * termometer_1_.height))
        bezier3Path.addLine(to: CGPoint(x: termometer_1_.minX + 0.72309 * termometer_1_.width, y: termometer_1_.minY + 0.10751 * termometer_1_.height))
        bezier3Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.03903 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.72072 * termometer_1_.width, y: termometer_1_.minY + 0.06996 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.62132 * termometer_1_.width, y: termometer_1_.minY + 0.03903 * termometer_1_.height))
        bezier3Path.close()
        fillColor.setFill()
        bezier3Path.fill()
        
        
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.92268 * termometer_1_.height))
        bezier4Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.24027 * termometer_1_.width, y: termometer_1_.minY + 0.84168 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.35624 * termometer_1_.width, y: termometer_1_.minY + 0.92268 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.24027 * termometer_1_.width, y: termometer_1_.minY + 0.88660 * termometer_1_.height))
        bezier4Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.76068 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.24027 * termometer_1_.width, y: termometer_1_.minY + 0.79676 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.35624 * termometer_1_.width, y: termometer_1_.minY + 0.76068 * termometer_1_.height))
        bezier4Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.76096 * termometer_1_.width, y: termometer_1_.minY + 0.84168 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.64498 * termometer_1_.width, y: termometer_1_.minY + 0.76068 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.76096 * termometer_1_.width, y: termometer_1_.minY + 0.79676 * termometer_1_.height))
        bezier4Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.92268 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.76096 * termometer_1_.width, y: termometer_1_.minY + 0.88660 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.64498 * termometer_1_.width, y: termometer_1_.minY + 0.92268 * termometer_1_.height))
        bezier4Path.close()
        bezier4Path.move(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.79897 * termometer_1_.height))
        bezier4Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.36334 * termometer_1_.width, y: termometer_1_.minY + 0.84168 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.42487 * termometer_1_.width, y: termometer_1_.minY + 0.79897 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.36334 * termometer_1_.width, y: termometer_1_.minY + 0.81811 * termometer_1_.height))
        bezier4Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.88439 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.36334 * termometer_1_.width, y: termometer_1_.minY + 0.86524 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.42487 * termometer_1_.width, y: termometer_1_.minY + 0.88439 * termometer_1_.height))
        bezier4Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.63788 * termometer_1_.width, y: termometer_1_.minY + 0.84168 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.57635 * termometer_1_.width, y: termometer_1_.minY + 0.88439 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.63788 * termometer_1_.width, y: termometer_1_.minY + 0.86524 * termometer_1_.height))
        bezier4Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.79897 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.63788 * termometer_1_.width, y: termometer_1_.minY + 0.81811 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.57635 * termometer_1_.width, y: termometer_1_.minY + 0.79897 * termometer_1_.height))
        bezier4Path.close()
        fillColor.setFill()
        bezier4Path.fill()
        
        
        //// Bezier 5 Drawing
        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.79897 * termometer_1_.height))
        bezier5Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.43907 * termometer_1_.width, y: termometer_1_.minY + 0.77982 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.46511 * termometer_1_.width, y: termometer_1_.minY + 0.79897 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.43907 * termometer_1_.width, y: termometer_1_.minY + 0.79013 * termometer_1_.height))
        bezier5Path.addLine(to: CGPoint(x: termometer_1_.minX + 0.43907 * termometer_1_.width, y: termometer_1_.minY + 0.39102 * termometer_1_.height))
        bezier5Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.37187 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.43907 * termometer_1_.width, y: termometer_1_.minY + 0.37997 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.46748 * termometer_1_.width, y: termometer_1_.minY + 0.37187 * termometer_1_.height))
        bezier5Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.56215 * termometer_1_.width, y: termometer_1_.minY + 0.39102 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.53375 * termometer_1_.width, y: termometer_1_.minY + 0.37187 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.56215 * termometer_1_.width, y: termometer_1_.minY + 0.38071 * termometer_1_.height))
        bezier5Path.addLine(to: CGPoint(x: termometer_1_.minX + 0.56215 * termometer_1_.width, y: termometer_1_.minY + 0.77982 * termometer_1_.height))
        bezier5Path.addCurve(to: CGPoint(x: termometer_1_.minX + 0.50061 * termometer_1_.width, y: termometer_1_.minY + 0.79897 * termometer_1_.height), controlPoint1: CGPoint(x: termometer_1_.minX + 0.56215 * termometer_1_.width, y: termometer_1_.minY + 0.79013 * termometer_1_.height), controlPoint2: CGPoint(x: termometer_1_.minX + 0.53375 * termometer_1_.width, y: termometer_1_.minY + 0.79897 * termometer_1_.height))
        bezier5Path.close()
        fillColor.setFill()
        bezier5Path.fill()
    }

}
