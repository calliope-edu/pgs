import UIKit

@IBDesignable
class Dashboard_ShakeAnimation: UIView_DashboardItemAnimation, CAAnimationDelegate {
	
    //MARK: - animator
    
    override func run(_ completion: @escaping ((Bool) -> Void)) {
        self.completionBlock = completion
        
        let duration = 0.5
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
		translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        
        /*
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
            (degrees: Double) -> Double in
            let radians: Double = (Double.pi * degrees) / 180.0
            return radians
        }
        */
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation]
        //shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = duration
        shakeGroup.delegate = self
        self.layer.add(shakeGroup, forKey: "shakeIt")
        
    }
	
	//MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayers()
        // print("frame: \(frame)")
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		setupLayers()
	}
    
	func setupLayers(){
	}
	
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let inner_bounds = self.bounds.insetBy(percentage: 0.48)
        drawCanvas1(frame: inner_bounds)
        
        layer.cornerRadius = rect.height/2
        clipsToBounds = true
    }
    
    func drawCanvas1(frame: CGRect = CGRect(x: 0, y: 0, width: 120, height: 120)) {
        //// General Declarations
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Color Declarations
        let fillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        
        //// Subframes
        let ebene_2: CGRect = CGRect(x: frame.minX + fastFloor(frame.width * 0.04162 - 0.49) + 0.99, y: frame.minY + fastFloor(frame.height * 0.09173 + 0.49) + 0.01, width: fastFloor(frame.width * 0.96199 + 0.06) - fastFloor(frame.width * 0.04162 - 0.49) - 0.55, height: fastFloor(frame.height * 0.90976 + 0.33) - fastFloor(frame.height * 0.09173 + 0.49) + 0.16)
        
        
        //// Ebene_2
        //// Ebene_1-2
        //// connect
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: ebene_2.minX + 0.28400 * ebene_2.width, y: ebene_2.minY + 0.99998 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.28375 * ebene_2.width, y: ebene_2.minY + 0.99999 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.24288 * ebene_2.width, y: ebene_2.minY + 0.98505 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.26903 * ebene_2.width, y: ebene_2.minY + 1.00028 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.25464 * ebene_2.width, y: ebene_2.minY + 0.99502 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.21365 * ebene_2.width, y: ebene_2.minY + 0.89353 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.22007 * ebene_2.width, y: ebene_2.minY + 0.96484 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.20939 * ebene_2.width, y: ebene_2.minY + 0.93183 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.16521 * ebene_2.width, y: ebene_2.minY + 0.68052 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.21709 * ebene_2.width, y: ebene_2.minY + 0.86297 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.22370 * ebene_2.width, y: ebene_2.minY + 0.75825 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.05574 * ebene_2.width, y: ebene_2.minY + 0.58293 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.11251 * ebene_2.width, y: ebene_2.minY + 0.61115 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.08154 * ebene_2.width, y: ebene_2.minY + 0.59240 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.05510 * ebene_2.width, y: ebene_2.minY + 0.58271 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.00058 * ebene_2.width, y: ebene_2.minY + 0.50961 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.02569 * ebene_2.width, y: ebene_2.minY + 0.57259 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.00432 * ebene_2.width, y: ebene_2.minY + 0.54395 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.04822 * ebene_2.width, y: ebene_2.minY + 0.41810 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + -0.00221 * ebene_2.width, y: ebene_2.minY + 0.48197 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.00377 * ebene_2.width, y: ebene_2.minY + 0.44275 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.17498 * ebene_2.width, y: ebene_2.minY + 0.30309 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.08734 * ebene_2.width, y: ebene_2.minY + 0.39650 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.14112 * ebene_2.width, y: ebene_2.minY + 0.35891 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.21347 * ebene_2.width, y: ebene_2.minY + 0.09772 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.22442 * ebene_2.width, y: ebene_2.minY + 0.22159 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.21700 * ebene_2.width, y: ebene_2.minY + 0.12533 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.23827 * ebene_2.width, y: ebene_2.minY + 0.01785 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.20930 * ebene_2.width, y: ebene_2.minY + 0.06420 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.21854 * ebene_2.width, y: ebene_2.minY + 0.03436 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.23827 * ebene_2.width, y: ebene_2.minY + 0.01785 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.23869 * ebene_2.width, y: ebene_2.minY + 0.01751 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.33216 * ebene_2.width, y: ebene_2.minY + 0.01567 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.26641 * ebene_2.width, y: ebene_2.minY + -0.00515 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.30376 * ebene_2.width, y: ebene_2.minY + -0.00588 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.49958 * ebene_2.width, y: ebene_2.minY + 0.08723 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.36703 * ebene_2.width, y: ebene_2.minY + 0.04220 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.43575 * ebene_2.width, y: ebene_2.minY + 0.08723 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.66799 * ebene_2.width, y: ebene_2.minY + 0.01592 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.56731 * ebene_2.width, y: ebene_2.minY + 0.08723 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.63422 * ebene_2.width, y: ebene_2.minY + 0.04240 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.66778 * ebene_2.width, y: ebene_2.minY + 0.01608 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.73527 * ebene_2.width, y: ebene_2.minY + 0.00541 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.68746 * ebene_2.width, y: ebene_2.minY + 0.00058 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.71255 * ebene_2.width, y: ebene_2.minY + -0.00339 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.73798 * ebene_2.width, y: ebene_2.minY + 0.00655 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.73773 * ebene_2.width, y: ebene_2.minY + 0.00645 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.78836 * ebene_2.width, y: ebene_2.minY + 0.09587 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.77105 * ebene_2.width, y: ebene_2.minY + 0.01936 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.79205 * ebene_2.width, y: ebene_2.minY + 0.05644 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.82572 * ebene_2.width, y: ebene_2.minY + 0.30584 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.78280 * ebene_2.width, y: ebene_2.minY + 0.15456 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.78062 * ebene_2.width, y: ebene_2.minY + 0.23962 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.95112 * ebene_2.width, y: ebene_2.minY + 0.42340 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.87868 * ebene_2.width, y: ebene_2.minY + 0.38357 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.92314 * ebene_2.width, y: ebene_2.minY + 0.41270 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.95116 * ebene_2.width, y: ebene_2.minY + 0.42341 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.99983 * ebene_2.width, y: ebene_2.minY + 0.49479 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.97864 * ebene_2.width, y: ebene_2.minY + 0.43406 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.99781 * ebene_2.width, y: ebene_2.minY + 0.46216 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.94731 * ebene_2.width, y: ebene_2.minY + 0.58099 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 1.00200 * ebene_2.width, y: ebene_2.minY + 0.53057 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.98290 * ebene_2.width, y: ebene_2.minY + 0.56204 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.81974 * ebene_2.width, y: ebene_2.minY + 0.70161 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.90548 * ebene_2.width, y: ebene_2.minY + 0.60300 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.85342 * ebene_2.width, y: ebene_2.minY + 0.63682 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.78551 * ebene_2.width, y: ebene_2.minY + 0.91217 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.77583 * ebene_2.width, y: ebene_2.minY + 0.78585 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.78117 * ebene_2.width, y: ebene_2.minY + 0.87692 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.78546 * ebene_2.width, y: ebene_2.minY + 0.91173 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.75645 * ebene_2.width, y: ebene_2.minY + 0.98335 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.78898 * ebene_2.width, y: ebene_2.minY + 0.93992 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.77767 * ebene_2.width, y: ebene_2.minY + 0.96785 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.66292 * ebene_2.width, y: ebene_2.minY + 0.97788 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.74006 * ebene_2.width, y: ebene_2.minY + 0.99530 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.70629 * ebene_2.width, y: ebene_2.minY + 1.00997 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.65251 * ebene_2.width, y: ebene_2.minY + 0.97003 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.65212 * ebene_2.width, y: ebene_2.minY + 0.96972 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.59877 * ebene_2.width, y: ebene_2.minY + 0.93644 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.63561 * ebene_2.width, y: ebene_2.minY + 0.95622 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.61769 * ebene_2.width, y: ebene_2.minY + 0.94505 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.59919 * ebene_2.width, y: ebene_2.minY + 0.93661 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.54119 * ebene_2.width, y: ebene_2.minY + 0.91790 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.58061 * ebene_2.width, y: ebene_2.minY + 0.92774 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.56113 * ebene_2.width, y: ebene_2.minY + 0.92145 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.54091 * ebene_2.width, y: ebene_2.minY + 0.91786 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.50481 * ebene_2.width, y: ebene_2.minY + 0.88726 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.52467 * ebene_2.width, y: ebene_2.minY + 0.91626 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.51066 * ebene_2.width, y: ebene_2.minY + 0.90438 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.49949 * ebene_2.width, y: ebene_2.minY + 0.88120 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.50275 * ebene_2.width, y: ebene_2.minY + 0.88120 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.50121 * ebene_2.width, y: ebene_2.minY + 0.88120 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.49451 * ebene_2.width, y: ebene_2.minY + 0.88762 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.49777 * ebene_2.width, y: ebene_2.minY + 0.88120 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.49641 * ebene_2.width, y: ebene_2.minY + 0.88120 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.49440 * ebene_2.width, y: ebene_2.minY + 0.88795 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.45532 * ebene_2.width, y: ebene_2.minY + 0.91818 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.48844 * ebene_2.width, y: ebene_2.minY + 0.90638 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.47274 * ebene_2.width, y: ebene_2.minY + 0.91852 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.45670 * ebene_2.width, y: ebene_2.minY + 0.91805 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.39774 * ebene_2.width, y: ebene_2.minY + 0.93707 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.43628 * ebene_2.width, y: ebene_2.minY + 0.92087 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.41639 * ebene_2.width, y: ebene_2.minY + 0.92729 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.39674 * ebene_2.width, y: ebene_2.minY + 0.93762 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.33744 * ebene_2.width, y: ebene_2.minY + 0.97930 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.37573 * ebene_2.width, y: ebene_2.minY + 0.94914 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.35586 * ebene_2.width, y: ebene_2.minY + 0.96312 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.33581 * ebene_2.width, y: ebene_2.minY + 0.98073 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.28313 * ebene_2.width, y: ebene_2.minY + 0.99999 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.32050 * ebene_2.width, y: ebene_2.minY + 0.99325 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.30206 * ebene_2.width, y: ebene_2.minY + 0.99999 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.28400 * ebene_2.width, y: ebene_2.minY + 0.99998 * ebene_2.height))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: ebene_2.minX + 0.26544 * ebene_2.width, y: ebene_2.minY + 0.05881 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.25846 * ebene_2.width, y: ebene_2.minY + 0.09059 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.25810 * ebene_2.width, y: ebene_2.minY + 0.06492 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.25711 * ebene_2.width, y: ebene_2.minY + 0.07969 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.21247 * ebene_2.width, y: ebene_2.minY + 0.33192 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.26263 * ebene_2.width, y: ebene_2.minY + 0.12278 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.27168 * ebene_2.width, y: ebene_2.minY + 0.23555 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.06823 * ebene_2.width, y: ebene_2.minY + 0.46384 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.17290 * ebene_2.width, y: ebene_2.minY + 0.39722 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.11215 * ebene_2.width, y: ebene_2.minY + 0.43949 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.04560 * ebene_2.width, y: ebene_2.minY + 0.50459 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.04605 * ebene_2.width, y: ebene_2.minY + 0.47617 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.04424 * ebene_2.width, y: ebene_2.minY + 0.49084 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.06986 * ebene_2.width, y: ebene_2.minY + 0.53423 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.04768 * ebene_2.width, y: ebene_2.minY + 0.52496 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.06760 * ebene_2.width, y: ebene_2.minY + 0.53342 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.19970 * ebene_2.width, y: ebene_2.minY + 0.64761 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.10192 * ebene_2.width, y: ebene_2.minY + 0.54605 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.13976 * ebene_2.width, y: ebene_2.minY + 0.56795 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.25856 * ebene_2.width, y: ebene_2.minY + 0.89995 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.27014 * ebene_2.width, y: ebene_2.minY + 0.74113 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.26254 * ebene_2.width, y: ebene_2.minY + 0.86439 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.27087 * ebene_2.width, y: ebene_2.minY + 0.94477 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.25729 * ebene_2.width, y: ebene_2.minY + 0.91146 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.25711 * ebene_2.width, y: ebene_2.minY + 0.93275 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.30890 * ebene_2.width, y: ebene_2.minY + 0.93988 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.27866 * ebene_2.width, y: ebene_2.minY + 0.95160 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.29803 * ebene_2.width, y: ebene_2.minY + 0.94915 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.30844 * ebene_2.width, y: ebene_2.minY + 0.94029 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.37775 * ebene_2.width, y: ebene_2.minY + 0.89155 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.32996 * ebene_2.width, y: ebene_2.minY + 0.92136 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.35319 * ebene_2.width, y: ebene_2.minY + 0.90503 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.37984 * ebene_2.width, y: ebene_2.minY + 0.89043 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.45257 * ebene_2.width, y: ebene_2.minY + 0.86697 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.40284 * ebene_2.width, y: ebene_2.minY + 0.87837 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.42738 * ebene_2.width, y: ebene_2.minY + 0.87045 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.45368 * ebene_2.width, y: ebene_2.minY + 0.86694 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.45357 * ebene_2.width, y: ebene_2.minY + 0.86728 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.51664 * ebene_2.width, y: ebene_2.minY + 0.83267 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.46249 * ebene_2.width, y: ebene_2.minY + 0.83812 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.49073 * ebene_2.width, y: ebene_2.minY + 0.82263 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.54711 * ebene_2.width, y: ebene_2.minY + 0.86636 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.53079 * ebene_2.width, y: ebene_2.minY + 0.83815 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.54199 * ebene_2.width, y: ebene_2.minY + 0.85053 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.54700 * ebene_2.width, y: ebene_2.minY + 0.86689 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.61891 * ebene_2.width, y: ebene_2.minY + 0.89009 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.57172 * ebene_2.width, y: ebene_2.minY + 0.87129 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.59587 * ebene_2.width, y: ebene_2.minY + 0.87908 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.61556 * ebene_2.width, y: ebene_2.minY + 0.88852 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.67926 * ebene_2.width, y: ebene_2.minY + 0.92825 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.63815 * ebene_2.width, y: ebene_2.minY + 0.89879 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.65954 * ebene_2.width, y: ebene_2.minY + 0.91213 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.68818 * ebene_2.width, y: ebene_2.minY + 0.93499 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.73246 * ebene_2.width, y: ebene_2.minY + 0.94039 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.71109 * ebene_2.width, y: ebene_2.minY + 0.95180 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.72440 * ebene_2.width, y: ebene_2.minY + 0.94609 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.73244 * ebene_2.width, y: ebene_2.minY + 0.94040 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.74153 * ebene_2.width, y: ebene_2.minY + 0.91896 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.73892 * ebene_2.width, y: ebene_2.minY + 0.93585 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.74246 * ebene_2.width, y: ebene_2.minY + 0.92749 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.78153 * ebene_2.width, y: ebene_2.minY + 0.67563 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.73653 * ebene_2.width, y: ebene_2.minY + 0.87804 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.73055 * ebene_2.width, y: ebene_2.minY + 0.77363 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.92902 * ebene_2.width, y: ebene_2.minY + 0.53433 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.82146 * ebene_2.width, y: ebene_2.minY + 0.59882 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.88113 * ebene_2.width, y: ebene_2.minY + 0.55970 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.95619 * ebene_2.width, y: ebene_2.minY + 0.49756 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.94188 * ebene_2.width, y: ebene_2.minY + 0.52751 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.95682 * ebene_2.width, y: ebene_2.minY + 0.51559 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.95618 * ebene_2.width, y: ebene_2.minY + 0.49747 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.93793 * ebene_2.width, y: ebene_2.minY + 0.47071 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.95542 * ebene_2.width, y: ebene_2.minY + 0.48524 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.94823 * ebene_2.width, y: ebene_2.minY + 0.47470 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.78995 * ebene_2.width, y: ebene_2.minY + 0.33610 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.90286 * ebene_2.width, y: ebene_2.minY + 0.45834 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.84980 * ebene_2.width, y: ebene_2.minY + 0.42421 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.74350 * ebene_2.width, y: ebene_2.minY + 0.09038 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.73499 * ebene_2.width, y: ebene_2.minY + 0.25562 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.73707 * ebene_2.width, y: ebene_2.minY + 0.15731 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.74351 * ebene_2.width, y: ebene_2.minY + 0.09026 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.72298 * ebene_2.width, y: ebene_2.minY + 0.05399 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.74501 * ebene_2.width, y: ebene_2.minY + 0.07427 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.73649 * ebene_2.width, y: ebene_2.minY + 0.05923 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.72114 * ebene_2.width, y: ebene_2.minY + 0.05330 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.72102 * ebene_2.width, y: ebene_2.minY + 0.05325 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.69374 * ebene_2.width, y: ebene_2.minY + 0.05757 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.71185 * ebene_2.width, y: ebene_2.minY + 0.04950 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.70163 * ebene_2.width, y: ebene_2.minY + 0.05112 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.49949 * ebene_2.width, y: ebene_2.minY + 0.13816 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.65577 * ebene_2.width, y: ebene_2.minY + 0.08794 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.57971 * ebene_2.width, y: ebene_2.minY + 0.13816 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.30636 * ebene_2.width, y: ebene_2.minY + 0.05768 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.42706 * ebene_2.width, y: ebene_2.minY + 0.13816 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.35462 * ebene_2.width, y: ebene_2.minY + 0.09436 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.30642 * ebene_2.width, y: ebene_2.minY + 0.05773 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.26500 * ebene_2.width, y: ebene_2.minY + 0.05895 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.29379 * ebene_2.width, y: ebene_2.minY + 0.04815 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.27716 * ebene_2.width, y: ebene_2.minY + 0.04864 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.26544 * ebene_2.width, y: ebene_2.minY + 0.05881 * ebene_2.height))
        bezierPath.close()
        fillColor.setFill()
        bezierPath.fill()
        
        
        //// smile
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.32311 - 0.19) + 0.69, y: ebene_2.minY + fastFloor(ebene_2.height * 0.30156 - 0.1) + 0.6, width: fastFloor(ebene_2.width * 0.38341 + 0.15) - fastFloor(ebene_2.width * 0.32311 - 0.19) - 0.34, height: fastFloor(ebene_2.height * 0.36941 + 0.24) - fastFloor(ebene_2.height * 0.30156 - 0.1) - 0.34))
        fillColor.setFill()
        ovalPath.fill()
        
        
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.42054 + 0.05) + 0.45, y: ebene_2.minY + fastFloor(ebene_2.height * 0.30156 - 0.1) + 0.6, width: fastFloor(ebene_2.width * 0.48084 + 0.39) - fastFloor(ebene_2.width * 0.42054 + 0.05) - 0.34, height: fastFloor(ebene_2.height * 0.36941 + 0.24) - fastFloor(ebene_2.height * 0.30156 - 0.1) - 0.34))
        fillColor.setFill()
        oval2Path.fill()
        
        
        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.51796 + 0.29) + 0.21, y: ebene_2.minY + fastFloor(ebene_2.height * 0.30156 - 0.1) + 0.6, width: fastFloor(ebene_2.width * 0.57826 - 0.37) - fastFloor(ebene_2.width * 0.51796 + 0.29) + 0.66, height: fastFloor(ebene_2.height * 0.36941 + 0.24) - fastFloor(ebene_2.height * 0.30156 - 0.1) - 0.34))
        fillColor.setFill()
        oval3Path.fill()
        
        
        //// Oval 4 Drawing
        let oval4Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.61538 - 0.47) + 0.97, y: ebene_2.minY + fastFloor(ebene_2.height * 0.30156 - 0.1) + 0.6, width: fastFloor(ebene_2.width * 0.67569 - 0.13) - fastFloor(ebene_2.width * 0.61538 - 0.47) - 0.34, height: fastFloor(ebene_2.height * 0.36941 + 0.24) - fastFloor(ebene_2.height * 0.30156 - 0.1) - 0.34))
        fillColor.setFill()
        oval4Path.fill()
        
        
        
        
        //// smile-2
        //// Oval 5 Drawing
        let oval5Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.32311 - 0.19) + 0.69, y: ebene_2.minY + fastFloor(ebene_2.height * 0.40873 + 0.38) + 0.12, width: fastFloor(ebene_2.width * 0.38341 + 0.15) - fastFloor(ebene_2.width * 0.32311 - 0.19) - 0.34, height: fastFloor(ebene_2.height * 0.47657 - 0.28) - fastFloor(ebene_2.height * 0.40873 + 0.38) + 0.66))
        fillColor.setFill()
        oval5Path.fill()
        
        
        //// Oval 6 Drawing
        let oval6Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.42054 + 0.05) + 0.45, y: ebene_2.minY + fastFloor(ebene_2.height * 0.40873 + 0.38) + 0.12, width: fastFloor(ebene_2.width * 0.48084 + 0.39) - fastFloor(ebene_2.width * 0.42054 + 0.05) - 0.34, height: fastFloor(ebene_2.height * 0.47657 - 0.28) - fastFloor(ebene_2.height * 0.40873 + 0.38) + 0.66))
        fillColor.setFill()
        oval6Path.fill()
        
        
        //// Oval 7 Drawing
        let oval7Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.51796 + 0.29) + 0.21, y: ebene_2.minY + fastFloor(ebene_2.height * 0.40873 + 0.38) + 0.12, width: fastFloor(ebene_2.width * 0.57826 - 0.37) - fastFloor(ebene_2.width * 0.51796 + 0.29) + 0.66, height: fastFloor(ebene_2.height * 0.47657 - 0.28) - fastFloor(ebene_2.height * 0.40873 + 0.38) + 0.66))
        fillColor.setFill()
        oval7Path.fill()
        
        
        //// Oval 8 Drawing
        let oval8Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.61538 - 0.47) + 0.97, y: ebene_2.minY + fastFloor(ebene_2.height * 0.40873 + 0.38) + 0.12, width: fastFloor(ebene_2.width * 0.67569 - 0.13) - fastFloor(ebene_2.width * 0.61538 - 0.47) - 0.34, height: fastFloor(ebene_2.height * 0.47657 - 0.28) - fastFloor(ebene_2.height * 0.40873 + 0.38) + 0.66))
        fillColor.setFill()
        oval8Path.fill()
        
        
        
        
        //// smile-3
        //// Oval 9 Drawing
        let oval9Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.32311 - 0.19) + 0.69, y: ebene_2.minY + fastFloor(ebene_2.height * 0.51600 - 0.15) + 0.65, width: fastFloor(ebene_2.width * 0.38341 + 0.15) - fastFloor(ebene_2.width * 0.32311 - 0.19) - 0.34, height: fastFloor(ebene_2.height * 0.58384 + 0.19) - fastFloor(ebene_2.height * 0.51600 - 0.15) - 0.34))
        fillColor.setFill()
        oval9Path.fill()
        
        
        //// Oval 10 Drawing
        let oval10Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.42054 + 0.05) + 0.45, y: ebene_2.minY + fastFloor(ebene_2.height * 0.51600 - 0.15) + 0.65, width: fastFloor(ebene_2.width * 0.48084 + 0.39) - fastFloor(ebene_2.width * 0.42054 + 0.05) - 0.34, height: fastFloor(ebene_2.height * 0.58384 + 0.19) - fastFloor(ebene_2.height * 0.51600 - 0.15) - 0.34))
        fillColor.setFill()
        oval10Path.fill()
        
        
        //// Oval 11 Drawing
        let oval11Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.51796 + 0.29) + 0.21, y: ebene_2.minY + fastFloor(ebene_2.height * 0.51600 - 0.15) + 0.65, width: fastFloor(ebene_2.width * 0.57826 - 0.37) - fastFloor(ebene_2.width * 0.51796 + 0.29) + 0.66, height: fastFloor(ebene_2.height * 0.58384 + 0.19) - fastFloor(ebene_2.height * 0.51600 - 0.15) - 0.34))
        fillColor.setFill()
        oval11Path.fill()
        
        
        //// Oval 12 Drawing
        let oval12Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.61538 - 0.47) + 0.97, y: ebene_2.minY + fastFloor(ebene_2.height * 0.51600 - 0.15) + 0.65, width: fastFloor(ebene_2.width * 0.67569 - 0.13) - fastFloor(ebene_2.width * 0.61538 - 0.47) - 0.34, height: fastFloor(ebene_2.height * 0.58384 + 0.19) - fastFloor(ebene_2.height * 0.51600 - 0.15) - 0.34))
        fillColor.setFill()
        oval12Path.fill()
        
        
        
        
        //// smile-4
        //// Oval 13 Drawing
        let oval13Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.32311 - 0.19) + 0.69, y: ebene_2.minY + fastFloor(ebene_2.height * 0.62327 + 0.32) + 0.18, width: fastFloor(ebene_2.width * 0.38341 + 0.15) - fastFloor(ebene_2.width * 0.32311 - 0.19) - 0.34, height: fastFloor(ebene_2.height * 0.69111 - 0.34) - fastFloor(ebene_2.height * 0.62327 + 0.32) + 0.66))
        fillColor.setFill()
        oval13Path.fill()
        
        
        //// Oval 14 Drawing
        let oval14Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.42054 + 0.05) + 0.45, y: ebene_2.minY + fastFloor(ebene_2.height * 0.62327 + 0.32) + 0.18, width: fastFloor(ebene_2.width * 0.48084 + 0.39) - fastFloor(ebene_2.width * 0.42054 + 0.05) - 0.34, height: fastFloor(ebene_2.height * 0.69111 - 0.34) - fastFloor(ebene_2.height * 0.62327 + 0.32) + 0.66))
        fillColor.setFill()
        oval14Path.fill()
        
        
        //// Oval 15 Drawing
        let oval15Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.51796 + 0.29) + 0.21, y: ebene_2.minY + fastFloor(ebene_2.height * 0.62327 + 0.32) + 0.18, width: fastFloor(ebene_2.width * 0.57826 - 0.37) - fastFloor(ebene_2.width * 0.51796 + 0.29) + 0.66, height: fastFloor(ebene_2.height * 0.69111 - 0.34) - fastFloor(ebene_2.height * 0.62327 + 0.32) + 0.66))
        fillColor.setFill()
        oval15Path.fill()
        
        
        //// Oval 16 Drawing
        let oval16Path = UIBezierPath(ovalIn: CGRect(x: ebene_2.minX + fastFloor(ebene_2.width * 0.61538 - 0.47) + 0.97, y: ebene_2.minY + fastFloor(ebene_2.height * 0.62327 + 0.32) + 0.18, width: fastFloor(ebene_2.width * 0.67569 - 0.13) - fastFloor(ebene_2.width * 0.61538 - 0.47) - 0.34, height: fastFloor(ebene_2.height * 0.69111 - 0.34) - fastFloor(ebene_2.height * 0.62327 + 0.32) + 0.66))
        fillColor.setFill()
        oval16Path.fill()
    }

	//MARK: - Animation Cleanup
	
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        if let completionBlock = self.completionBlock {
            self.layer.removeAnimation(forKey: "shakeIt")
            completionBlock(flag)
        }
    }
	
}
