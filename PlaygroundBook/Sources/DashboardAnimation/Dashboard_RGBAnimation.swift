import UIKit

class Dashboard_RGBAnimation: UIView_DashboardItemAnimation, CAAnimationDelegate {
    private var animation_count:Int = 0
    private let colors:[String] = ["805bca",
                                   "e6007e",
                                   "e73f4b",
                                   "e6007e",
                                   "ff4e00",
                                   "ffcd9a",
                                   "f9c626",
                                   "bbdf6e",
                                   "46df6e",
                                   "43c9c9",
                                   "3573e5",
                                   "6150e8"]
    
    //MARK: - animator
    
    override func run(_ completionBlock: @escaping ((Bool) -> Void)) {
        self.completionBlock = completionBlock
        let inner_bounds = self.bounds.insetBy(percentage: 0.78)
        setUpAnimation(in: self.layer, size: inner_bounds.size, colors: colors, duration: 1.0)
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
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        //print("___ animationDidStop", URL(fileURLWithPath: #file).lastPathComponent)
        animation_count += 1
        if let completionBlock = self.completionBlock {
            //print("     block: \(flag), animation_count: \(animation_count)")
        
            if flag && animation_count == colors.count {
                animation_count = 0
                self.layer.sublayers?.removeAll()
                completionBlock(true)
            }
        }
    }
    
    //MARK: - Animation Setup
    
    func setUpAnimation(in layer: CALayer, size: CGSize, colors: [String], duration: CFTimeInterval) {
        let circleSpacing: CGFloat = -6
        let circleSize = (size.width - 4 * circleSpacing) / 6
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let beginTime = CACurrentMediaTime()
        
        // Scale animation
        let startScale:CGFloat = 0.3
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0, 0.7, 0.9, 1]
        scaleAnimation.values = [startScale, 1.03, 1, 0.9]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimaton.keyTimes = [0, 0.5, 0.9, 1]
        opacityAnimaton.values = [0, 1, 0.9, 0]
        opacityAnimaton.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, opacityAnimaton]
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = duration
        animation.repeatCount = 0
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        
        // Draw circles
        for (i, colorString) in colors.enumerated() {
            let color = UIColor(hex: colorString)
            let circle:CALayer = circleAt(angle: CGFloat(Double.pi / 6) * CGFloat(i),
                                  size: circleSize,
                                  origin: CGPoint(x: x, y: y),
                                  containerSize: size,
                                  color: color)
            
            let delayTime:CFTimeInterval = Double(i) * 0.12
            //print("delayTime: \(delayTime) : \(i)")
            animation.beginTime = beginTime + delayTime
            circle.transform = CATransform3DMakeScale(startScale, startScale, 0.0)
            circle.opacity = 0.0
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }
    
    func circleAt(angle: CGFloat, size: CGFloat, origin: CGPoint, containerSize: CGSize, color: UIColor) -> CALayer {
        let radius = containerSize.width / 2 - size / 2
        let circle: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: size / 2, y: size / 2),
                    radius: size / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        
        circle.fillColor = color.cgColor
        circle.backgroundColor = nil
        circle.path = path.cgPath
        circle.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        let frame = CGRect(
            x: origin.x + radius * (cos(angle) + 1),
            y: origin.y + radius * (sin(angle) + 1),
            width: size,
            height: size)
        
        circle.frame = frame
        
        return circle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawCanvas1(frame: rect.insetBy(percentage: 0.6))
    }
    
    func drawCanvas1(frame: CGRect = CGRect(x: 0, y: 0, width: 120, height: 120)) {
        //// General Declarations
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Color Declarations
        let fillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        
        //// Subframes
        let ebene_2: CGRect = CGRect(x: frame.minX + fastFloor(frame.width * 0.22500 - 0.5) + 1, y: frame.minY + fastFloor(frame.height * 0.25833 - 0.5) + 1, width: fastFloor(frame.width * 0.76417 - 0.2) - fastFloor(frame.width * 0.22500 - 0.5) - 0.3, height: fastFloor(frame.height * 0.75425 - 0.01) - fastFloor(frame.height * 0.25833 - 0.5) - 0.49)
        
        
        //// Ebene_2
        //// Flächen
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: ebene_2.minX + 1.00000 * ebene_2.width, y: ebene_2.minY + 0.34038 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 1.00000 * ebene_2.width, y: ebene_2.minY + 0.34038 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.68709 * ebene_2.width, y: ebene_2.minY + 0.00000 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 1.00000 * ebene_2.width, y: ebene_2.minY + 0.15239 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.85991 * ebene_2.width, y: ebene_2.minY + 0.00000 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.68709 * ebene_2.width, y: ebene_2.minY + 0.00000 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.50019 * ebene_2.width, y: ebene_2.minY + 0.06803 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.61965 * ebene_2.width, y: ebene_2.minY + 0.00000 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.55404 * ebene_2.width, y: ebene_2.minY + 0.02388 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.49903 * ebene_2.width, y: ebene_2.minY + 0.06803 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.31213 * ebene_2.width, y: ebene_2.minY + 0.00000 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.44517 * ebene_2.width, y: ebene_2.minY + 0.02388 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.37957 * ebene_2.width, y: ebene_2.minY + 0.00000 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.31291 * ebene_2.width, y: ebene_2.minY + 0.00000 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.00000 * ebene_2.width, y: ebene_2.minY + 0.34038 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.14009 * ebene_2.width, y: ebene_2.minY + 0.00000 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.00000 * ebene_2.width, y: ebene_2.minY + 0.15239 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.00000 * ebene_2.width, y: ebene_2.minY + 0.34043 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.18564 * ebene_2.width, y: ebene_2.minY + 0.65138 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.00000 * ebene_2.width, y: ebene_2.minY + 0.47486 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.07274 * ebene_2.width, y: ebene_2.minY + 0.59670 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.18774 * ebene_2.width, y: ebene_2.minY + 0.65962 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.18774 * ebene_2.width, y: ebene_2.minY + 0.65480 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.18774 * ebene_2.width, y: ebene_2.minY + 0.65707 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.18774 * ebene_2.width, y: ebene_2.minY + 0.65962 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.50065 * ebene_2.width, y: ebene_2.minY + 1.00000 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.18774 * ebene_2.width, y: ebene_2.minY + 0.84761 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.32784 * ebene_2.width, y: ebene_2.minY + 1.00000 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.50065 * ebene_2.width, y: ebene_2.minY + 1.00000 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.81356 * ebene_2.width, y: ebene_2.minY + 0.65962 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.67347 * ebene_2.width, y: ebene_2.minY + 1.00000 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.81356 * ebene_2.width, y: ebene_2.minY + 0.84761 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.81356 * ebene_2.width, y: ebene_2.minY + 0.65239 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.81356 * ebene_2.width, y: ebene_2.minY + 0.65707 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.81356 * ebene_2.width, y: ebene_2.minY + 0.65480 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.81436 * ebene_2.width, y: ebene_2.minY + 0.65200 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 1.00000 * ebene_2.width, y: ebene_2.minY + 0.34105 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.92726 * ebene_2.width, y: ebene_2.minY + 0.59732 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 1.00000 * ebene_2.width, y: ebene_2.minY + 0.47548 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 1.00000 * ebene_2.width, y: ebene_2.minY + 0.34038 * ebene_2.height))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: ebene_2.minX + 0.03911 * ebene_2.width, y: ebene_2.minY + 0.34038 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.03911 * ebene_2.width, y: ebene_2.minY + 0.34038 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.31291 * ebene_2.width, y: ebene_2.minY + 0.04255 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.03911 * ebene_2.width, y: ebene_2.minY + 0.17589 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.16170 * ebene_2.width, y: ebene_2.minY + 0.04255 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.31253 * ebene_2.width, y: ebene_2.minY + 0.04255 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.46845 * ebene_2.width, y: ebene_2.minY + 0.09603 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.36831 * ebene_2.width, y: ebene_2.minY + 0.04255 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.42275 * ebene_2.width, y: ebene_2.minY + 0.06122 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.46994 * ebene_2.width, y: ebene_2.minY + 0.09611 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.37484 * ebene_2.width, y: ebene_2.minY + 0.33984 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.40916 * ebene_2.width, y: ebene_2.minY + 0.15996 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.37484 * ebene_2.width, y: ebene_2.minY + 0.24793 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.37484 * ebene_2.width, y: ebene_2.minY + 0.34761 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.37484 * ebene_2.width, y: ebene_2.minY + 0.34279 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.37484 * ebene_2.width, y: ebene_2.minY + 0.34520 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.37299 * ebene_2.width, y: ebene_2.minY + 0.34850 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.19121 * ebene_2.width, y: ebene_2.minY + 0.60620 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.27620 * ebene_2.width, y: ebene_2.minY + 0.39538 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.20779 * ebene_2.width, y: ebene_2.minY + 0.49236 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.19288 * ebene_2.width, y: ebene_2.minY + 0.60766 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.03911 * ebene_2.width, y: ebene_2.minY + 0.33997 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.09880 * ebene_2.width, y: ebene_2.minY + 0.55774 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.03911 * ebene_2.width, y: ebene_2.minY + 0.45384 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.03911 * ebene_2.width, y: ebene_2.minY + 0.34038 * ebene_2.height))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: ebene_2.minX + 0.58566 * ebene_2.width, y: ebene_2.minY + 0.33244 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.58477 * ebene_2.width, y: ebene_2.minY + 0.33216 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.49938 * ebene_2.width, y: ebene_2.minY + 0.31910 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.55701 * ebene_2.width, y: ebene_2.minY + 0.32350 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.52827 * ebene_2.width, y: ebene_2.minY + 0.31910 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.50062 * ebene_2.width, y: ebene_2.minY + 0.31910 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.41523 * ebene_2.width, y: ebene_2.minY + 0.33216 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.47173 * ebene_2.width, y: ebene_2.minY + 0.31910 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.44299 * ebene_2.width, y: ebene_2.minY + 0.32350 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.41440 * ebene_2.width, y: ebene_2.minY + 0.33048 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.50130 * ebene_2.width, y: ebene_2.minY + 0.12305 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.41693 * ebene_2.width, y: ebene_2.minY + 0.25154 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.44819 * ebene_2.width, y: ebene_2.minY + 0.17693 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.49871 * ebene_2.width, y: ebene_2.minY + 0.12307 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.58561 * ebene_2.width, y: ebene_2.minY + 0.33049 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.55182 * ebene_2.width, y: ebene_2.minY + 0.17694 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.58308 * ebene_2.width, y: ebene_2.minY + 0.25155 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.58566 * ebene_2.width, y: ebene_2.minY + 0.33244 * ebene_2.height))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: ebene_2.minX + 0.50000 * ebene_2.width, y: ebene_2.minY + 0.55638 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.50070 * ebene_2.width, y: ebene_2.minY + 0.55709 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.41624 * ebene_2.width, y: ebene_2.minY + 0.37678 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.45394 * ebene_2.width, y: ebene_2.minY + 0.50965 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.42403 * ebene_2.width, y: ebene_2.minY + 0.44581 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.41562 * ebene_2.width, y: ebene_2.minY + 0.37631 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.49906 * ebene_2.width, y: ebene_2.minY + 0.36193 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.44257 * ebene_2.width, y: ebene_2.minY + 0.36678 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.47073 * ebene_2.width, y: ebene_2.minY + 0.36193 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.50023 * ebene_2.width, y: ebene_2.minY + 0.36194 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.58508 * ebene_2.width, y: ebene_2.minY + 0.37655 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.52904 * ebene_2.width, y: ebene_2.minY + 0.36194 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.55767 * ebene_2.width, y: ebene_2.minY + 0.36687 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.58384 * ebene_2.width, y: ebene_2.minY + 0.37604 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.49918 * ebene_2.width, y: ebene_2.minY + 0.55679 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.57603 * ebene_2.width, y: ebene_2.minY + 0.44524 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.54606 * ebene_2.width, y: ebene_2.minY + 0.50924 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.50000 * ebene_2.width, y: ebene_2.minY + 0.55638 * ebene_2.height))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: ebene_2.minX + 0.62099 * ebene_2.width, y: ebene_2.minY + 0.39285 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.61959 * ebene_2.width, y: ebene_2.minY + 0.39210 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.77132 * ebene_2.width, y: ebene_2.minY + 0.62350 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.70292 * ebene_2.width, y: ebene_2.minY + 0.43632 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.76002 * ebene_2.width, y: ebene_2.minY + 0.52340 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.77256 * ebene_2.width, y: ebene_2.minY + 0.62302 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.68771 * ebene_2.width, y: ebene_2.minY + 0.63764 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.74516 * ebene_2.width, y: ebene_2.minY + 0.63271 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.71652 * ebene_2.width, y: ebene_2.minY + 0.63764 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.68809 * ebene_2.width, y: ebene_2.minY + 0.63764 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.53210 * ebene_2.width, y: ebene_2.minY + 0.58414 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.63228 * ebene_2.width, y: ebene_2.minY + 0.63764 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.57782 * ebene_2.width, y: ebene_2.minY + 0.61896 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.52949 * ebene_2.width, y: ebene_2.minY + 0.58495 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.62072 * ebene_2.width, y: ebene_2.minY + 0.39431 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.57812 * ebene_2.width, y: ebene_2.minY + 0.53387 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.61015 * ebene_2.width, y: ebene_2.minY + 0.46695 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.62099 * ebene_2.width, y: ebene_2.minY + 0.39285 * ebene_2.height))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: ebene_2.minX + 0.46936 * ebene_2.width, y: ebene_2.minY + 0.58318 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.47124 * ebene_2.width, y: ebene_2.minY + 0.58171 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.31612 * ebene_2.width, y: ebene_2.minY + 0.63817 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.42608 * ebene_2.width, y: ebene_2.minY + 0.61740 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.37193 * ebene_2.width, y: ebene_2.minY + 0.63711 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.31268 * ebene_2.width, y: ebene_2.minY + 0.63821 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.22783 * ebene_2.width, y: ebene_2.minY + 0.62359 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.28387 * ebene_2.width, y: ebene_2.minY + 0.63821 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.25523 * ebene_2.width, y: ebene_2.minY + 0.63327 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.22907 * ebene_2.width, y: ebene_2.minY + 0.62406 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.38080 * ebene_2.width, y: ebene_2.minY + 0.39267 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.24037 * ebene_2.width, y: ebene_2.minY + 0.52396 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.29747 * ebene_2.width, y: ebene_2.minY + 0.43688 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.37948 * ebene_2.width, y: ebene_2.minY + 0.39397 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.47071 * ebene_2.width, y: ebene_2.minY + 0.58461 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.39006 * ebene_2.width, y: ebene_2.minY + 0.46660 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.42208 * ebene_2.width, y: ebene_2.minY + 0.53352 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.46936 * ebene_2.width, y: ebene_2.minY + 0.58318 * ebene_2.height))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: ebene_2.minX + 0.49987 * ebene_2.width, y: ebene_2.minY + 0.95618 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.50055 * ebene_2.width, y: ebene_2.minY + 0.95618 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.22692 * ebene_2.width, y: ebene_2.minY + 0.66874 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.35305 * ebene_2.width, y: ebene_2.minY + 0.95618 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.23207 * ebene_2.width, y: ebene_2.minY + 0.82909 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.22526 * ebene_2.width, y: ebene_2.minY + 0.66605 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.31042 * ebene_2.width, y: ebene_2.minY + 0.68072 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.25288 * ebene_2.width, y: ebene_2.minY + 0.67523 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.28154 * ebene_2.width, y: ebene_2.minY + 0.68017 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.31270 * ebene_2.width, y: ebene_2.minY + 0.68075 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.49968 * ebene_2.width, y: ebene_2.minY + 0.61270 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.38016 * ebene_2.width, y: ebene_2.minY + 0.68075 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.44579 * ebene_2.width, y: ebene_2.minY + 0.65687 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.50111 * ebene_2.width, y: ebene_2.minY + 0.61270 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.68809 * ebene_2.width, y: ebene_2.minY + 0.68076 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.55499 * ebene_2.width, y: ebene_2.minY + 0.65687 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.62062 * ebene_2.width, y: ebene_2.minY + 0.68076 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.68676 * ebene_2.width, y: ebene_2.minY + 0.68076 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.77211 * ebene_2.width, y: ebene_2.minY + 0.66771 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.71563 * ebene_2.width, y: ebene_2.minY + 0.68076 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.74435 * ebene_2.width, y: ebene_2.minY + 0.67636 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.77297 * ebene_2.width, y: ebene_2.minY + 0.66874 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.49934 * ebene_2.width, y: ebene_2.minY + 0.95618 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.76782 * ebene_2.width, y: ebene_2.minY + 0.82909 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.64684 * ebene_2.width, y: ebene_2.minY + 0.95618 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.49987 * ebene_2.width, y: ebene_2.minY + 0.95618 * ebene_2.height))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: ebene_2.minX + 0.80834 * ebene_2.width, y: ebene_2.minY + 0.60630 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.80827 * ebene_2.width, y: ebene_2.minY + 0.60577 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.62648 * ebene_2.width, y: ebene_2.minY + 0.34807 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.79169 * ebene_2.width, y: ebene_2.minY + 0.49193 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.72328 * ebene_2.width, y: ebene_2.minY + 0.39495 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.62464 * ebene_2.width, y: ebene_2.minY + 0.33995 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.62464 * ebene_2.width, y: ebene_2.minY + 0.34477 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.62464 * ebene_2.width, y: ebene_2.minY + 0.34236 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.62464 * ebene_2.width, y: ebene_2.minY + 0.33997 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.52954 * ebene_2.width, y: ebene_2.minY + 0.09625 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.62464 * ebene_2.width, y: ebene_2.minY + 0.24806 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.59031 * ebene_2.width, y: ebene_2.minY + 0.16010 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.53090 * ebene_2.width, y: ebene_2.minY + 0.09603 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.68682 * ebene_2.width, y: ebene_2.minY + 0.04255 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.57660 * ebene_2.width, y: ebene_2.minY + 0.06122 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.63103 * ebene_2.width, y: ebene_2.minY + 0.04255 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.68644 * ebene_2.width, y: ebene_2.minY + 0.04255 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.96023 * ebene_2.width, y: ebene_2.minY + 0.34038 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.83765 * ebene_2.width, y: ebene_2.minY + 0.04255 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.96023 * ebene_2.width, y: ebene_2.minY + 0.17589 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.96023 * ebene_2.width, y: ebene_2.minY + 0.33962 * ebene_2.height))
        bezierPath.addCurve(to: CGPoint(x: ebene_2.minX + 0.81074 * ebene_2.width, y: ebene_2.minY + 0.60498 * ebene_2.height), controlPoint1: CGPoint(x: ebene_2.minX + 0.96023 * ebene_2.width, y: ebene_2.minY + 0.45161 * ebene_2.height), controlPoint2: CGPoint(x: ebene_2.minX + 0.90248 * ebene_2.width, y: ebene_2.minY + 0.55414 * ebene_2.height))
        bezierPath.addLine(to: CGPoint(x: ebene_2.minX + 0.80834 * ebene_2.width, y: ebene_2.minY + 0.60630 * ebene_2.height))
        bezierPath.close()
        fillColor.setFill()
        bezierPath.fill()
    }

}

