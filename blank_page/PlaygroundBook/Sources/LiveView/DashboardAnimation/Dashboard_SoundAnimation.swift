import UIKit

class Dashboard_SoundAnimation: UIView_DashboardItemAnimation, CAAnimationDelegate {
    private var animation_count:Int = 0
    private let max_rings:Int = 3
    
    //MARK: - animator
    
    override func run(_ completionBlock: @escaping ((Bool) -> Void)) {
        self.completionBlock = completionBlock
        let inner_bounds = self.bounds.insetBy(percentage: LayoutHelper.symbolInsetByPercentage)
        setUpAnimation(in: self.layer, size: inner_bounds.size, color: .white, duration: 1.4)
    }
    
	//MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayers()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		setupLayers()
	}
	
	func setupLayers(){
        self.backgroundColor = UIColor(red:1, green: 1, blue:1, alpha:DebugConstants.debugGridBgAlpha)
	}
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        animation_count += 1
        if let completionBlock = self.completionBlock {
            if flag && animation_count == max_rings {
                animation_count = 0
                self.layer.sublayers?.removeAll()
                completionBlock(true)
            }
        }
    }
    
	//MARK: - Animation Setup
	
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor, duration:CFTimeInterval) {
        let beginTime = CACurrentMediaTime()
//        let timingFunction = CAMediaTimingFunction(controlPoints: 0.65, -0.23, 0.28, 1.27)
		let timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        let startScale:CGFloat = 0.4
        let startLineWidth:CGFloat = 2.0
    
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0, 0.7, 0.8, 1]
        scaleAnimation.values = [startScale, 1.1, 1.0, 0.9]
        scaleAnimation.timingFunction = timingFunction
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.keyTimes = [0, 0.8, 1]
        opacityAnimation.values = [0, 0.5, 0]
        opacityAnimation.timingFunction = timingFunction
        opacityAnimation.duration = duration
        
        // LineWidth animation
        let lineWidthAnimation = CAKeyframeAnimation(keyPath: "lineWidth")
        lineWidthAnimation.keyTimes = [0, 0.6, 1]
        lineWidthAnimation.values = [startLineWidth, 12.0, 1.0]
        lineWidthAnimation.timingFunction = timingFunction
        lineWidthAnimation.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, opacityAnimation, lineWidthAnimation]
        animation.duration = duration
        animation.repeatCount = 0
        animation.timingFunction = timingFunction
        animation.isRemovedOnCompletion = true
        animation.delegate = self
        
        // Draw circles
        for i in 0 ..< max_rings {
            let circle: CAShapeLayer = CAShapeLayer()
            let path: UIBezierPath = UIBezierPath()
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 0,
                        endAngle: CGFloat(2 * Double.pi),
                        clockwise: false)
            path.close()
            circle.strokeColor = color.cgColor
            circle.fillColor = nil
            circle.backgroundColor = nil
            circle.lineWidth = startLineWidth
            circle.path = path.cgPath
            circle.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            circle.transform = CATransform3DMakeScale(startScale, startScale, 0.0)
            circle.opacity = 0.0
            
            let frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
                               y: (layer.bounds.size.height - size.height) / 2,
                               width: size.width,
                               height: size.height)
            
            let delayPortion:Double = duration / ( Double(max_rings) * 2 )
            //print("delayPortion: \(delayPortion)")
            let delayTime:CFTimeInterval = Double(i) * delayPortion
            animation.beginTime = beginTime + delayTime
            circle.frame = frame
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawCanvas1(frame: rect.insetBy(percentage: 0.6))
    }
    
    func drawCanvas1(frame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)) {
        //// Color Declarations
        let fillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.70700 * frame.width, y: frame.minY + 0.27050 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.70150 * frame.width, y: frame.minY + 0.25900 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.70700 * frame.width, y: frame.minY + 0.26650 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.70500 * frame.width, y: frame.minY + 0.26200 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.68950 * frame.width, y: frame.minY + 0.25500 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.69850 * frame.width, y: frame.minY + 0.25600 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.69350 * frame.width, y: frame.minY + 0.25500 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.41150 * frame.width, y: frame.minY + 0.28700 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.39750 * frame.width, y: frame.minY + 0.30200 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.40350 * frame.width, y: frame.minY + 0.28800 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.39750 * frame.width, y: frame.minY + 0.29450 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.39750 * frame.width, y: frame.minY + 0.60850 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.32450 * frame.width, y: frame.minY + 0.58400 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.37900 * frame.width, y: frame.minY + 0.59350 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.35300 * frame.width, y: frame.minY + 0.58400 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.22200 * frame.width, y: frame.minY + 0.66750 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.26800 * frame.width, y: frame.minY + 0.58400 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.22200 * frame.width, y: frame.minY + 0.62150 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.32450 * frame.width, y: frame.minY + 0.75100 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.22200 * frame.width, y: frame.minY + 0.71350 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.26800 * frame.width, y: frame.minY + 0.75100 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.42850 * frame.width, y: frame.minY + 0.66900 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.38500 * frame.width, y: frame.minY + 0.75100 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.42850 * frame.width, y: frame.minY + 0.71750 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.42850 * frame.width, y: frame.minY + 0.66400 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.42850 * frame.width, y: frame.minY + 0.66400 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.42850 * frame.width, y: frame.minY + 0.66750 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.42850 * frame.width, y: frame.minY + 0.31600 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.67600 * frame.width, y: frame.minY + 0.28750 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.67600 * frame.width, y: frame.minY + 0.57700 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.60200 * frame.width, y: frame.minY + 0.55150 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.65750 * frame.width, y: frame.minY + 0.56150 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.63100 * frame.width, y: frame.minY + 0.55150 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.49900 * frame.width, y: frame.minY + 0.63550 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.54500 * frame.width, y: frame.minY + 0.55150 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.49900 * frame.width, y: frame.minY + 0.58900 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.60200 * frame.width, y: frame.minY + 0.71950 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.49900 * frame.width, y: frame.minY + 0.68200 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.54550 * frame.width, y: frame.minY + 0.71950 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.70700 * frame.width, y: frame.minY + 0.63450 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.65450 * frame.width, y: frame.minY + 0.71950 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.70700 * frame.width, y: frame.minY + 0.68900 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.70700 * frame.width, y: frame.minY + 0.62350 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.70700 * frame.width, y: frame.minY + 0.62450 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.70700 * frame.width, y: frame.minY + 0.62800 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.70700 * frame.width, y: frame.minY + 0.27050 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.70700 * frame.width, y: frame.minY + 0.27050 * frame.height))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.32500 * frame.width, y: frame.minY + 0.72550 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.24850 * frame.width, y: frame.minY + 0.66800 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.28250 * frame.width, y: frame.minY + 0.72550 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.24850 * frame.width, y: frame.minY + 0.69950 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.32500 * frame.width, y: frame.minY + 0.61050 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.24850 * frame.width, y: frame.minY + 0.63600 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.28300 * frame.width, y: frame.minY + 0.61050 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.40150 * frame.width, y: frame.minY + 0.66800 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.36750 * frame.width, y: frame.minY + 0.61050 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.40150 * frame.width, y: frame.minY + 0.63650 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.32500 * frame.width, y: frame.minY + 0.72550 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.40150 * frame.width, y: frame.minY + 0.69950 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.36750 * frame.width, y: frame.minY + 0.72550 * frame.height))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.60200 * frame.width, y: frame.minY + 0.69350 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.52450 * frame.width, y: frame.minY + 0.63550 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.55900 * frame.width, y: frame.minY + 0.69350 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.52450 * frame.width, y: frame.minY + 0.66750 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.60200 * frame.width, y: frame.minY + 0.57750 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.52450 * frame.width, y: frame.minY + 0.60350 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.55900 * frame.width, y: frame.minY + 0.57750 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.67950 * frame.width, y: frame.minY + 0.63550 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.64500 * frame.width, y: frame.minY + 0.57750 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.67950 * frame.width, y: frame.minY + 0.60350 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.60200 * frame.width, y: frame.minY + 0.69350 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.67950 * frame.width, y: frame.minY + 0.66750 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.64500 * frame.width, y: frame.minY + 0.69350 * frame.height))
        bezierPath.close()
        fillColor.setFill()
        bezierPath.fill()
    }
	
}
