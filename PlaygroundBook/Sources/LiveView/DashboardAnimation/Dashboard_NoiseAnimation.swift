import UIKit

@IBDesignable
class Dashboard_NoiseAnimation: UIView_DashboardItemAnimation, CAAnimationDelegate {
	
	var layers = [String: CALayer]()
	var completionBlocks = [CAAnimation: (Bool) -> Void]()
	var updateLayerValueForCompletedAnimation : Bool = false
	
    //MARK: - animator
    
    override func run(_ completionBlock: @escaping ((Bool) -> Void)) {
        addNoiseAnimation(completionBlock: completionBlock)
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
	
	func setupLayers(){
        self.textLabel = Layout.animationLabel(in: self, center: false)
        textLabelXConstraint = self.textLabel?.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        textLabelYConstraint = self.textLabel?.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        textLabelXConstraint?.isActive = true
        textLabelYConstraint?.isActive = true
        addSwoosh()
	}
	
	
	//MARK: - Animation Setup
	
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let inner_bounds = self.bounds.insetBy(percentage: 0.7)
        drawCanvas1(frame: inner_bounds)
    }
    
    //MARK: - Animation Setup
    
    func addNoiseAnimation(totalDuration: CFTimeInterval = 0.5, endTime: CFTimeInterval = 1, completionBlock: ((_ finished: Bool) -> Void)? = nil){
        delay(time: totalDuration) {
            if let completionBlock = completionBlock {
                completionBlock(true)
                
            }
        }
    }
	
    func drawCanvas1(frame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)) {
    //// General Declarations
    // This non-generic function dramatically improves compilation times of complex expressions.
    func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }

    //// Color Declarations
    let fillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)


    //// Subframes
    let micro_3_: CGRect = CGRect(x: frame.minX + fastFloor(frame.width * 0.31500 + 0.5), y: frame.minY + fastFloor(frame.height * 0.24800 - 0.1) + 0.6, width: fastFloor(frame.width * 0.67600 + 0.3) - fastFloor(frame.width * 0.31500 + 0.5) + 0.2, height: fastFloor(frame.height * 0.76100 + 0.3) - fastFloor(frame.height * 0.24800 - 0.1) - 0.4)


    //// micro_3_
    //// Bezier Drawing
    let bezierPath = UIBezierPath()
    bezierPath.move(to: CGPoint(x: micro_3_.minX + 0.96399 * micro_3_.width, y: micro_3_.minY + 0.30214 * micro_3_.height))
    bezierPath.addCurve(to: CGPoint(x: micro_3_.minX + 0.92798 * micro_3_.width, y: micro_3_.minY + 0.32749 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.94460 * micro_3_.width, y: micro_3_.minY + 0.30214 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.92798 * micro_3_.width, y: micro_3_.minY + 0.31384 * micro_3_.height))
    bezierPath.addLine(to: CGPoint(x: micro_3_.minX + 0.92798 * micro_3_.width, y: micro_3_.minY + 0.45029 * micro_3_.height))
    bezierPath.addCurve(to: CGPoint(x: micro_3_.minX + 0.50000 * micro_3_.width, y: micro_3_.minY + 0.75146 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.92798 * micro_3_.width, y: micro_3_.minY + 0.61598 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.73546 * micro_3_.width, y: micro_3_.minY + 0.75146 * micro_3_.height))
    bezierPath.addCurve(to: CGPoint(x: micro_3_.minX + 0.07202 * micro_3_.width, y: micro_3_.minY + 0.45029 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.26454 * micro_3_.width, y: micro_3_.minY + 0.75146 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.07202 * micro_3_.width, y: micro_3_.minY + 0.61598 * micro_3_.height))
    bezierPath.addLine(to: CGPoint(x: micro_3_.minX + 0.07202 * micro_3_.width, y: micro_3_.minY + 0.32749 * micro_3_.height))
    bezierPath.addCurve(to: CGPoint(x: micro_3_.minX + 0.03601 * micro_3_.width, y: micro_3_.minY + 0.30214 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.07202 * micro_3_.width, y: micro_3_.minY + 0.31384 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.05540 * micro_3_.width, y: micro_3_.minY + 0.30214 * micro_3_.height))
    bezierPath.addCurve(to: CGPoint(x: micro_3_.minX + 0.00000 * micro_3_.width, y: micro_3_.minY + 0.32749 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.01662 * micro_3_.width, y: micro_3_.minY + 0.30214 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.00000 * micro_3_.width, y: micro_3_.minY + 0.31384 * micro_3_.height))
    bezierPath.addLine(to: CGPoint(x: micro_3_.minX + 0.00000 * micro_3_.width, y: micro_3_.minY + 0.45029 * micro_3_.height))
    bezierPath.addCurve(to: CGPoint(x: micro_3_.minX + 0.44321 * micro_3_.width, y: micro_3_.minY + 0.79922 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.00000 * micro_3_.width, y: micro_3_.minY + 0.63060 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.19391 * micro_3_.width, y: micro_3_.minY + 0.77973 * micro_3_.height))
    bezierPath.addLine(to: CGPoint(x: micro_3_.minX + 0.43213 * micro_3_.width, y: micro_3_.minY + 0.79922 * micro_3_.height))
    bezierPath.addLine(to: CGPoint(x: micro_3_.minX + 0.43213 * micro_3_.width, y: micro_3_.minY + 1.00000 * micro_3_.height))
    bezierPath.addLine(to: CGPoint(x: micro_3_.minX + 0.51801 * micro_3_.width, y: micro_3_.minY + 1.00000 * micro_3_.height))
    bezierPath.addLine(to: CGPoint(x: micro_3_.minX + 0.51801 * micro_3_.width, y: micro_3_.minY + 0.80117 * micro_3_.height))
    bezierPath.addCurve(to: CGPoint(x: micro_3_.minX + 1.00000 * micro_3_.width, y: micro_3_.minY + 0.45029 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.78532 * micro_3_.width, y: micro_3_.minY + 0.79435 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 1.00000 * micro_3_.width, y: micro_3_.minY + 0.63938 * micro_3_.height))
    bezierPath.addLine(to: CGPoint(x: micro_3_.minX + 1.00000 * micro_3_.width, y: micro_3_.minY + 0.32749 * micro_3_.height))
    bezierPath.addCurve(to: CGPoint(x: micro_3_.minX + 0.96399 * micro_3_.width, y: micro_3_.minY + 0.30214 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 1.00000 * micro_3_.width, y: micro_3_.minY + 0.31384 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.98338 * micro_3_.width, y: micro_3_.minY + 0.30214 * micro_3_.height))
    bezierPath.close()
    fillColor.setFill()
    bezierPath.fill()


    //// Bezier 2 Drawing
    let bezier2Path = UIBezierPath()
    bezier2Path.move(to: CGPoint(x: micro_3_.minX + 0.50277 * micro_3_.width, y: micro_3_.minY + 0.00000 * micro_3_.height))
    bezier2Path.addCurve(to: CGPoint(x: micro_3_.minX + 0.16343 * micro_3_.width, y: micro_3_.minY + 0.23879 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.31579 * micro_3_.width, y: micro_3_.minY + 0.00000 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.16343 * micro_3_.width, y: micro_3_.minY + 0.10721 * micro_3_.height))
    bezier2Path.addLine(to: CGPoint(x: micro_3_.minX + 0.16343 * micro_3_.width, y: micro_3_.minY + 0.43762 * micro_3_.height))
    bezier2Path.addCurve(to: CGPoint(x: micro_3_.minX + 0.50277 * micro_3_.width, y: micro_3_.minY + 0.67641 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.16343 * micro_3_.width, y: micro_3_.minY + 0.56920 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.31579 * micro_3_.width, y: micro_3_.minY + 0.67641 * micro_3_.height))
    bezier2Path.addLine(to: CGPoint(x: micro_3_.minX + 0.50277 * micro_3_.width, y: micro_3_.minY + 0.67641 * micro_3_.height))
    bezier2Path.addCurve(to: CGPoint(x: micro_3_.minX + 0.84211 * micro_3_.width, y: micro_3_.minY + 0.43762 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.68975 * micro_3_.width, y: micro_3_.minY + 0.67641 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.84211 * micro_3_.width, y: micro_3_.minY + 0.56920 * micro_3_.height))
    bezier2Path.addLine(to: CGPoint(x: micro_3_.minX + 0.84211 * micro_3_.width, y: micro_3_.minY + 0.23782 * micro_3_.height))
    bezier2Path.addCurve(to: CGPoint(x: micro_3_.minX + 0.50277 * micro_3_.width, y: micro_3_.minY + 0.00000 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.84211 * micro_3_.width, y: micro_3_.minY + 0.10624 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.68975 * micro_3_.width, y: micro_3_.minY + 0.00000 * micro_3_.height))
    bezier2Path.close()
    bezier2Path.move(to: CGPoint(x: micro_3_.minX + 0.50277 * micro_3_.width, y: micro_3_.minY + 0.04971 * micro_3_.height))
    bezier2Path.addCurve(to: CGPoint(x: micro_3_.minX + 0.77008 * micro_3_.width, y: micro_3_.minY + 0.23782 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.64958 * micro_3_.width, y: micro_3_.minY + 0.04971 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.77008 * micro_3_.width, y: micro_3_.minY + 0.13450 * micro_3_.height))
    bezier2Path.addLine(to: CGPoint(x: micro_3_.minX + 0.77008 * micro_3_.width, y: micro_3_.minY + 0.30799 * micro_3_.height))
    bezier2Path.addLine(to: CGPoint(x: micro_3_.minX + 0.23546 * micro_3_.width, y: micro_3_.minY + 0.30799 * micro_3_.height))
    bezier2Path.addLine(to: CGPoint(x: micro_3_.minX + 0.23546 * micro_3_.width, y: micro_3_.minY + 0.23782 * micro_3_.height))
    bezier2Path.addCurve(to: CGPoint(x: micro_3_.minX + 0.50277 * micro_3_.width, y: micro_3_.minY + 0.04971 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.23546 * micro_3_.width, y: micro_3_.minY + 0.13450 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.35596 * micro_3_.width, y: micro_3_.minY + 0.04971 * micro_3_.height))
    bezier2Path.close()
    bezier2Path.move(to: CGPoint(x: micro_3_.minX + 0.50277 * micro_3_.width, y: micro_3_.minY + 0.62476 * micro_3_.height))
    bezier2Path.addLine(to: CGPoint(x: micro_3_.minX + 0.50277 * micro_3_.width, y: micro_3_.minY + 0.62476 * micro_3_.height))
    bezier2Path.addCurve(to: CGPoint(x: micro_3_.minX + 0.23546 * micro_3_.width, y: micro_3_.minY + 0.43665 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.35457 * micro_3_.width, y: micro_3_.minY + 0.62476 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.23546 * micro_3_.width, y: micro_3_.minY + 0.53996 * micro_3_.height))
    bezier2Path.addLine(to: CGPoint(x: micro_3_.minX + 0.23546 * micro_3_.width, y: micro_3_.minY + 0.36842 * micro_3_.height))
    bezier2Path.addLine(to: CGPoint(x: micro_3_.minX + 0.77008 * micro_3_.width, y: micro_3_.minY + 0.36842 * micro_3_.height))
    bezier2Path.addLine(to: CGPoint(x: micro_3_.minX + 0.77008 * micro_3_.width, y: micro_3_.minY + 0.43665 * micro_3_.height))
    bezier2Path.addCurve(to: CGPoint(x: micro_3_.minX + 0.50277 * micro_3_.width, y: micro_3_.minY + 0.62476 * micro_3_.height), controlPoint1: CGPoint(x: micro_3_.minX + 0.77008 * micro_3_.width, y: micro_3_.minY + 0.53996 * micro_3_.height), controlPoint2: CGPoint(x: micro_3_.minX + 0.65097 * micro_3_.width, y: micro_3_.minY + 0.62476 * micro_3_.height))
    bezier2Path.close()
    fillColor.setFill()
    bezier2Path.fill()
}


}
