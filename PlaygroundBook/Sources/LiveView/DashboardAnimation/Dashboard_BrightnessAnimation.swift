import UIKit

@IBDesignable
class Dashboard_BrightnessAnimation: UIView_DashboardItemAnimation, CAAnimationDelegate {
	
	var layers = [String: CALayer]()
	var completionBlocks = [CAAnimation: (Bool) -> Void]()
	var updateLayerValueForCompletedAnimation : Bool = false
	
	//MARK: - animator
    
    override func run(_ completionBlock: @escaping ((Bool) -> Void)) {
        addBrightnessAnimation(completionBlock: completionBlock)
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
        self.textLabel = LayoutHelper.animationLabel(in: self, center: false)
        textLabelXConstraint = self.textLabel?.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        textLabelYConstraint = self.textLabel?.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        textLabelXConstraint?.isActive = true
        textLabelYConstraint?.isActive = true
        addSwoosh()
	}
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let inner_bounds = self.bounds.insetBy(percentage: 0.78)
        drawCanvas1(frame: inner_bounds)
    }
    
    //MARK: - Animation Setup
    
    func addBrightnessAnimation(totalDuration: CFTimeInterval = 0.5, endTime: CFTimeInterval = 1, completionBlock: ((_ finished: Bool) -> Void)? = nil){
        delay(time: totalDuration) {
            if let completionBlock = completionBlock {
                completionBlock(true)
                
            }
        }
    }
	
    func drawCanvas1(frame: CGRect = CGRect(x: 0, y: 0, width: 120, height: 120)) {
        //// General Declarations
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Color Declarations
        let fillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        
        //// Subframes
        let group: CGRect = CGRect(x: frame.minX + fastFloor(frame.width * 0.23167 - 0.3) + 0.8, y: frame.minY + fastFloor(frame.height * 0.24000 - 0.3) + 0.8, width: fastFloor(frame.width * 0.75750 - 0.4) - fastFloor(frame.width * 0.23167 - 0.3) + 0.1, height: fastFloor(frame.height * 0.76500 - 0.3) - fastFloor(frame.height * 0.24000 - 0.3))
        
        
        //// Group
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: group.minX + 0.50051 * group.width, y: group.minY + 0.79184 * group.height))
        bezier2Path.addCurve(to: CGPoint(x: group.minX + 0.20897 * group.width, y: group.minY + 0.50000 * group.height), controlPoint1: CGPoint(x: group.minX + 0.33945 * group.width, y: group.minY + 0.79184 * group.height), controlPoint2: CGPoint(x: group.minX + 0.20897 * group.width, y: group.minY + 0.66122 * group.height))
        bezier2Path.addCurve(to: CGPoint(x: group.minX + 0.50051 * group.width, y: group.minY + 0.20816 * group.height), controlPoint1: CGPoint(x: group.minX + 0.20897 * group.width, y: group.minY + 0.33878 * group.height), controlPoint2: CGPoint(x: group.minX + 0.33945 * group.width, y: group.minY + 0.20816 * group.height))
        bezier2Path.addCurve(to: CGPoint(x: group.minX + 0.79205 * group.width, y: group.minY + 0.50000 * group.height), controlPoint1: CGPoint(x: group.minX + 0.66157 * group.width, y: group.minY + 0.20816 * group.height), controlPoint2: CGPoint(x: group.minX + 0.79205 * group.width, y: group.minY + 0.33878 * group.height))
        bezier2Path.addCurve(to: CGPoint(x: group.minX + 0.50051 * group.width, y: group.minY + 0.79184 * group.height), controlPoint1: CGPoint(x: group.minX + 0.79205 * group.width, y: group.minY + 0.66122 * group.height), controlPoint2: CGPoint(x: group.minX + 0.66055 * group.width, y: group.minY + 0.79184 * group.height))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: group.minX + 0.50051 * group.width, y: group.minY + 0.26020 * group.height))
        bezier2Path.addCurve(to: CGPoint(x: group.minX + 0.26096 * group.width, y: group.minY + 0.50000 * group.height), controlPoint1: CGPoint(x: group.minX + 0.36799 * group.width, y: group.minY + 0.26020 * group.height), controlPoint2: CGPoint(x: group.minX + 0.26096 * group.width, y: group.minY + 0.36735 * group.height))
        bezier2Path.addCurve(to: CGPoint(x: group.minX + 0.50051 * group.width, y: group.minY + 0.73980 * group.height), controlPoint1: CGPoint(x: group.minX + 0.26096 * group.width, y: group.minY + 0.63265 * group.height), controlPoint2: CGPoint(x: group.minX + 0.36799 * group.width, y: group.minY + 0.73980 * group.height))
        bezier2Path.addCurve(to: CGPoint(x: group.minX + 0.74006 * group.width, y: group.minY + 0.50000 * group.height), controlPoint1: CGPoint(x: group.minX + 0.63303 * group.width, y: group.minY + 0.73980 * group.height), controlPoint2: CGPoint(x: group.minX + 0.74006 * group.width, y: group.minY + 0.63265 * group.height))
        bezier2Path.addCurve(to: CGPoint(x: group.minX + 0.50051 * group.width, y: group.minY + 0.26020 * group.height), controlPoint1: CGPoint(x: group.minX + 0.74006 * group.width, y: group.minY + 0.36735 * group.height), controlPoint2: CGPoint(x: group.minX + 0.63201 * group.width, y: group.minY + 0.26020 * group.height))
        bezier2Path.close()
        fillColor.setFill()
        bezier2Path.fill()
        
        
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: group.minX + 0.50079 * group.width, y: group.minY + 0.12449 * group.height))
        bezier4Path.addCurve(to: CGPoint(x: group.minX + 0.46910 * group.width, y: group.minY + 0.09898 * group.height), controlPoint1: CGPoint(x: group.minX + 0.48304 * group.width, y: group.minY + 0.12449 * group.height), controlPoint2: CGPoint(x: group.minX + 0.46910 * group.width, y: group.minY + 0.11327 * group.height))
        bezier4Path.addLine(to: CGPoint(x: group.minX + 0.46910 * group.width, y: group.minY + 0.02551 * group.height))
        bezier4Path.addCurve(to: CGPoint(x: group.minX + 0.50079 * group.width, y: group.minY + 0.00000 * group.height), controlPoint1: CGPoint(x: group.minX + 0.46910 * group.width, y: group.minY + 0.01122 * group.height), controlPoint2: CGPoint(x: group.minX + 0.48304 * group.width, y: group.minY + 0.00000 * group.height))
        bezier4Path.addCurve(to: CGPoint(x: group.minX + 0.53249 * group.width, y: group.minY + 0.02551 * group.height), controlPoint1: CGPoint(x: group.minX + 0.51854 * group.width, y: group.minY + 0.00000 * group.height), controlPoint2: CGPoint(x: group.minX + 0.53249 * group.width, y: group.minY + 0.01122 * group.height))
        bezier4Path.addLine(to: CGPoint(x: group.minX + 0.53249 * group.width, y: group.minY + 0.09898 * group.height))
        bezier4Path.addCurve(to: CGPoint(x: group.minX + 0.50079 * group.width, y: group.minY + 0.12449 * group.height), controlPoint1: CGPoint(x: group.minX + 0.53249 * group.width, y: group.minY + 0.11224 * group.height), controlPoint2: CGPoint(x: group.minX + 0.51854 * group.width, y: group.minY + 0.12449 * group.height))
        bezier4Path.close()
        fillColor.setFill()
        bezier4Path.fill()
        
        
        //// Bezier 5 Drawing
        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: group.minX + 0.50079 * group.width, y: group.minY + 1.00000 * group.height))
        bezier5Path.addCurve(to: CGPoint(x: group.minX + 0.46910 * group.width, y: group.minY + 0.97449 * group.height), controlPoint1: CGPoint(x: group.minX + 0.48304 * group.width, y: group.minY + 1.00000 * group.height), controlPoint2: CGPoint(x: group.minX + 0.46910 * group.width, y: group.minY + 0.98878 * group.height))
        bezier5Path.addLine(to: CGPoint(x: group.minX + 0.46910 * group.width, y: group.minY + 0.90102 * group.height))
        bezier5Path.addCurve(to: CGPoint(x: group.minX + 0.50079 * group.width, y: group.minY + 0.87551 * group.height), controlPoint1: CGPoint(x: group.minX + 0.46910 * group.width, y: group.minY + 0.88673 * group.height), controlPoint2: CGPoint(x: group.minX + 0.48304 * group.width, y: group.minY + 0.87551 * group.height))
        bezier5Path.addCurve(to: CGPoint(x: group.minX + 0.53249 * group.width, y: group.minY + 0.90102 * group.height), controlPoint1: CGPoint(x: group.minX + 0.51854 * group.width, y: group.minY + 0.87551 * group.height), controlPoint2: CGPoint(x: group.minX + 0.53249 * group.width, y: group.minY + 0.88673 * group.height))
        bezier5Path.addLine(to: CGPoint(x: group.minX + 0.53249 * group.width, y: group.minY + 0.97449 * group.height))
        bezier5Path.addCurve(to: CGPoint(x: group.minX + 0.50079 * group.width, y: group.minY + 1.00000 * group.height), controlPoint1: CGPoint(x: group.minX + 0.53249 * group.width, y: group.minY + 0.98878 * group.height), controlPoint2: CGPoint(x: group.minX + 0.51854 * group.width, y: group.minY + 1.00000 * group.height))
        bezier5Path.close()
        fillColor.setFill()
        bezier5Path.fill()
        
        
        //// Bezier 6 Drawing
        let bezier6Path = UIBezierPath()
        bezier6Path.move(to: CGPoint(x: group.minX + 0.97452 * group.width, y: group.minY + 0.55714 * group.height))
        bezier6Path.addLine(to: CGPoint(x: group.minX + 0.90112 * group.width, y: group.minY + 0.55714 * group.height))
        bezier6Path.addCurve(to: CGPoint(x: group.minX + 0.87564 * group.width, y: group.minY + 0.53333 * group.height), controlPoint1: CGPoint(x: group.minX + 0.88685 * group.width, y: group.minY + 0.55714 * group.height), controlPoint2: CGPoint(x: group.minX + 0.87564 * group.width, y: group.minY + 0.54667 * group.height))
        bezier6Path.addCurve(to: CGPoint(x: group.minX + 0.90112 * group.width, y: group.minY + 0.50952 * group.height), controlPoint1: CGPoint(x: group.minX + 0.87564 * group.width, y: group.minY + 0.52000 * group.height), controlPoint2: CGPoint(x: group.minX + 0.88685 * group.width, y: group.minY + 0.50952 * group.height))
        bezier6Path.addLine(to: CGPoint(x: group.minX + 0.97452 * group.width, y: group.minY + 0.50952 * group.height))
        bezier6Path.addCurve(to: CGPoint(x: group.minX + 1.00000 * group.width, y: group.minY + 0.53333 * group.height), controlPoint1: CGPoint(x: group.minX + 0.98879 * group.width, y: group.minY + 0.50952 * group.height), controlPoint2: CGPoint(x: group.minX + 1.00000 * group.width, y: group.minY + 0.52000 * group.height))
        bezier6Path.addCurve(to: CGPoint(x: group.minX + 0.97452 * group.width, y: group.minY + 0.55714 * group.height), controlPoint1: CGPoint(x: group.minX + 1.00000 * group.width, y: group.minY + 0.54667 * group.height), controlPoint2: CGPoint(x: group.minX + 0.98879 * group.width, y: group.minY + 0.55714 * group.height))
        bezier6Path.close()
        fillColor.setFill()
        bezier6Path.fill()
        
        
        //// Rectangle 3 Drawing
        let rectangle3Path = UIBezierPath()
        rectangle3Path.move(to: CGPoint(x: group.minX + 0.03119 * group.width, y: group.minY + 0.50952 * group.height))
        rectangle3Path.addLine(to: CGPoint(x: group.minX + 0.06696 * group.width, y: group.minY + 0.50952 * group.height))
        rectangle3Path.addCurve(to: CGPoint(x: group.minX + 0.11447 * group.width, y: group.minY + 0.51108 * group.height), controlPoint1: CGPoint(x: group.minX + 0.10452 * group.width, y: group.minY + 0.50952 * group.height), controlPoint2: CGPoint(x: group.minX + 0.10975 * group.width, y: group.minY + 0.50952 * group.height))
        rectangle3Path.addLine(to: CGPoint(x: group.minX + 0.11539 * group.width, y: group.minY + 0.51131 * group.height))
        rectangle3Path.addCurve(to: CGPoint(x: group.minX + 0.12995 * group.width, y: group.minY + 0.53214 * group.height), controlPoint1: CGPoint(x: group.minX + 0.12413 * group.width, y: group.minY + 0.51450 * group.height), controlPoint2: CGPoint(x: group.minX + 0.12995 * group.width, y: group.minY + 0.52282 * group.height))
        rectangle3Path.addCurve(to: CGPoint(x: group.minX + 0.12995 * group.width, y: group.minY + 0.53333 * group.height), controlPoint1: CGPoint(x: group.minX + 0.12995 * group.width, y: group.minY + 0.53333 * group.height), controlPoint2: CGPoint(x: group.minX + 0.12995 * group.width, y: group.minY + 0.53333 * group.height))
        rectangle3Path.addLine(to: CGPoint(x: group.minX + 0.12995 * group.width, y: group.minY + 0.53333 * group.height))
        rectangle3Path.addLine(to: CGPoint(x: group.minX + 0.12995 * group.width, y: group.minY + 0.53333 * group.height))
        rectangle3Path.addLine(to: CGPoint(x: group.minX + 0.12995 * group.width, y: group.minY + 0.53452 * group.height))
        rectangle3Path.addCurve(to: CGPoint(x: group.minX + 0.11539 * group.width, y: group.minY + 0.55536 * group.height), controlPoint1: CGPoint(x: group.minX + 0.12995 * group.width, y: group.minY + 0.54385 * group.height), controlPoint2: CGPoint(x: group.minX + 0.12413 * group.width, y: group.minY + 0.55217 * group.height))
        rectangle3Path.addCurve(to: CGPoint(x: group.minX + 0.09406 * group.width, y: group.minY + 0.55714 * group.height), controlPoint1: CGPoint(x: group.minX + 0.10975 * group.width, y: group.minY + 0.55714 * group.height), controlPoint2: CGPoint(x: group.minX + 0.10452 * group.width, y: group.minY + 0.55714 * group.height))
        rectangle3Path.addLine(to: CGPoint(x: group.minX + 0.06299 * group.width, y: group.minY + 0.55714 * group.height))
        rectangle3Path.addCurve(to: CGPoint(x: group.minX + 0.01548 * group.width, y: group.minY + 0.55558 * group.height), controlPoint1: CGPoint(x: group.minX + 0.02543 * group.width, y: group.minY + 0.55714 * group.height), controlPoint2: CGPoint(x: group.minX + 0.02020 * group.width, y: group.minY + 0.55714 * group.height))
        rectangle3Path.addLine(to: CGPoint(x: group.minX + 0.01457 * group.width, y: group.minY + 0.55536 * group.height))
        rectangle3Path.addCurve(to: CGPoint(x: group.minX + 0.00000 * group.width, y: group.minY + 0.53452 * group.height), controlPoint1: CGPoint(x: group.minX + 0.00582 * group.width, y: group.minY + 0.55217 * group.height), controlPoint2: CGPoint(x: group.minX + -0.00000 * group.width, y: group.minY + 0.54385 * group.height))
        rectangle3Path.addCurve(to: CGPoint(x: group.minX + 0.00000 * group.width, y: group.minY + 0.53333 * group.height), controlPoint1: CGPoint(x: group.minX + 0.00000 * group.width, y: group.minY + 0.53333 * group.height), controlPoint2: CGPoint(x: group.minX + 0.00000 * group.width, y: group.minY + 0.53333 * group.height))
        rectangle3Path.addLine(to: CGPoint(x: group.minX + 0.00000 * group.width, y: group.minY + 0.53333 * group.height))
        rectangle3Path.addLine(to: CGPoint(x: group.minX + 0.00000 * group.width, y: group.minY + 0.53333 * group.height))
        rectangle3Path.addLine(to: CGPoint(x: group.minX + 0.00000 * group.width, y: group.minY + 0.53214 * group.height))
        rectangle3Path.addCurve(to: CGPoint(x: group.minX + 0.01457 * group.width, y: group.minY + 0.51131 * group.height), controlPoint1: CGPoint(x: group.minX + 0.00000 * group.width, y: group.minY + 0.52282 * group.height), controlPoint2: CGPoint(x: group.minX + 0.00582 * group.width, y: group.minY + 0.51450 * group.height))
        rectangle3Path.addCurve(to: CGPoint(x: group.minX + 0.03589 * group.width, y: group.minY + 0.50952 * group.height), controlPoint1: CGPoint(x: group.minX + 0.02020 * group.width, y: group.minY + 0.50952 * group.height), controlPoint2: CGPoint(x: group.minX + 0.02543 * group.width, y: group.minY + 0.50952 * group.height))
        rectangle3Path.addLine(to: CGPoint(x: group.minX + 0.06299 * group.width, y: group.minY + 0.50952 * group.height))
        rectangle3Path.addLine(to: CGPoint(x: group.minX + 0.03119 * group.width, y: group.minY + 0.50952 * group.height))
        rectangle3Path.close()
        fillColor.setFill()
        rectangle3Path.fill()
        
        
        //// Bezier 7 Drawing
        let bezier7Path = UIBezierPath()
        bezier7Path.move(to: CGPoint(x: group.minX + 0.83832 * group.width, y: group.minY + 0.86508 * group.height))
        bezier7Path.addCurve(to: CGPoint(x: group.minX + 0.81984 * group.width, y: group.minY + 0.85804 * group.height), controlPoint1: CGPoint(x: group.minX + 0.83113 * group.width, y: group.minY + 0.86508 * group.height), controlPoint2: CGPoint(x: group.minX + 0.82497 * group.width, y: group.minY + 0.86307 * group.height))
        bezier7Path.addLine(to: CGPoint(x: group.minX + 0.77466 * group.width, y: group.minY + 0.81379 * group.height))
        bezier7Path.addCurve(to: CGPoint(x: group.minX + 0.77466 * group.width, y: group.minY + 0.77759 * group.height), controlPoint1: CGPoint(x: group.minX + 0.76439 * group.width, y: group.minY + 0.80374 * group.height), controlPoint2: CGPoint(x: group.minX + 0.76439 * group.width, y: group.minY + 0.78765 * group.height))
        bezier7Path.addCurve(to: CGPoint(x: group.minX + 0.81162 * group.width, y: group.minY + 0.77759 * group.height), controlPoint1: CGPoint(x: group.minX + 0.78493 * group.width, y: group.minY + 0.76753 * group.height), controlPoint2: CGPoint(x: group.minX + 0.80135 * group.width, y: group.minY + 0.76753 * group.height))
        bezier7Path.addLine(to: CGPoint(x: group.minX + 0.85680 * group.width, y: group.minY + 0.82184 * group.height))
        bezier7Path.addCurve(to: CGPoint(x: group.minX + 0.85680 * group.width, y: group.minY + 0.85804 * group.height), controlPoint1: CGPoint(x: group.minX + 0.86707 * group.width, y: group.minY + 0.83189 * group.height), controlPoint2: CGPoint(x: group.minX + 0.86707 * group.width, y: group.minY + 0.84798 * group.height))
        bezier7Path.addCurve(to: CGPoint(x: group.minX + 0.83832 * group.width, y: group.minY + 0.86508 * group.height), controlPoint1: CGPoint(x: group.minX + 0.85167 * group.width, y: group.minY + 0.86307 * group.height), controlPoint2: CGPoint(x: group.minX + 0.84551 * group.width, y: group.minY + 0.86508 * group.height))
        bezier7Path.close()
        fillColor.setFill()
        bezier7Path.fill()
        
        
        //// Bezier 8 Drawing
        let bezier8Path = UIBezierPath()
        bezier8Path.move(to: CGPoint(x: group.minX + 0.20686 * group.width, y: group.minY + 0.24662 * group.height))
        bezier8Path.addCurve(to: CGPoint(x: group.minX + 0.18838 * group.width, y: group.minY + 0.23958 * group.height), controlPoint1: CGPoint(x: group.minX + 0.19967 * group.width, y: group.minY + 0.24662 * group.height), controlPoint2: CGPoint(x: group.minX + 0.19351 * group.width, y: group.minY + 0.24461 * group.height))
        bezier8Path.addLine(to: CGPoint(x: group.minX + 0.14320 * group.width, y: group.minY + 0.19533 * group.height))
        bezier8Path.addCurve(to: CGPoint(x: group.minX + 0.14320 * group.width, y: group.minY + 0.15913 * group.height), controlPoint1: CGPoint(x: group.minX + 0.13293 * group.width, y: group.minY + 0.18528 * group.height), controlPoint2: CGPoint(x: group.minX + 0.13293 * group.width, y: group.minY + 0.16919 * group.height))
        bezier8Path.addCurve(to: CGPoint(x: group.minX + 0.18016 * group.width, y: group.minY + 0.15913 * group.height), controlPoint1: CGPoint(x: group.minX + 0.15347 * group.width, y: group.minY + 0.14907 * group.height), controlPoint2: CGPoint(x: group.minX + 0.16990 * group.width, y: group.minY + 0.14907 * group.height))
        bezier8Path.addLine(to: CGPoint(x: group.minX + 0.22534 * group.width, y: group.minY + 0.20338 * group.height))
        bezier8Path.addCurve(to: CGPoint(x: group.minX + 0.22534 * group.width, y: group.minY + 0.23958 * group.height), controlPoint1: CGPoint(x: group.minX + 0.23561 * group.width, y: group.minY + 0.21343 * group.height), controlPoint2: CGPoint(x: group.minX + 0.23561 * group.width, y: group.minY + 0.22952 * group.height))
        bezier8Path.addCurve(to: CGPoint(x: group.minX + 0.20686 * group.width, y: group.minY + 0.24662 * group.height), controlPoint1: CGPoint(x: group.minX + 0.22021 * group.width, y: group.minY + 0.24360 * group.height), controlPoint2: CGPoint(x: group.minX + 0.21302 * group.width, y: group.minY + 0.24662 * group.height))
        bezier8Path.close()
        fillColor.setFill()
        bezier8Path.fill()
        
        
        //// Bezier 9 Drawing
        let bezier9Path = UIBezierPath()
        bezier9Path.move(to: CGPoint(x: group.minX + 0.16168 * group.width, y: group.minY + 0.86508 * group.height))
        bezier9Path.addCurve(to: CGPoint(x: group.minX + 0.14320 * group.width, y: group.minY + 0.85804 * group.height), controlPoint1: CGPoint(x: group.minX + 0.15449 * group.width, y: group.minY + 0.86508 * group.height), controlPoint2: CGPoint(x: group.minX + 0.14833 * group.width, y: group.minY + 0.86307 * group.height))
        bezier9Path.addCurve(to: CGPoint(x: group.minX + 0.14320 * group.width, y: group.minY + 0.82184 * group.height), controlPoint1: CGPoint(x: group.minX + 0.13293 * group.width, y: group.minY + 0.84798 * group.height), controlPoint2: CGPoint(x: group.minX + 0.13293 * group.width, y: group.minY + 0.83189 * group.height))
        bezier9Path.addLine(to: CGPoint(x: group.minX + 0.18838 * group.width, y: group.minY + 0.77759 * group.height))
        bezier9Path.addCurve(to: CGPoint(x: group.minX + 0.22534 * group.width, y: group.minY + 0.77759 * group.height), controlPoint1: CGPoint(x: group.minX + 0.19865 * group.width, y: group.minY + 0.76753 * group.height), controlPoint2: CGPoint(x: group.minX + 0.21507 * group.width, y: group.minY + 0.76753 * group.height))
        bezier9Path.addCurve(to: CGPoint(x: group.minX + 0.22534 * group.width, y: group.minY + 0.81379 * group.height), controlPoint1: CGPoint(x: group.minX + 0.23561 * group.width, y: group.minY + 0.78765 * group.height), controlPoint2: CGPoint(x: group.minX + 0.23561 * group.width, y: group.minY + 0.80374 * group.height))
        bezier9Path.addLine(to: CGPoint(x: group.minX + 0.18016 * group.width, y: group.minY + 0.85804 * group.height))
        bezier9Path.addCurve(to: CGPoint(x: group.minX + 0.16168 * group.width, y: group.minY + 0.86508 * group.height), controlPoint1: CGPoint(x: group.minX + 0.17503 * group.width, y: group.minY + 0.86307 * group.height), controlPoint2: CGPoint(x: group.minX + 0.16784 * group.width, y: group.minY + 0.86508 * group.height))
        bezier9Path.close()
        fillColor.setFill()
        bezier9Path.fill()
        
        
        //// Bezier 10 Drawing
        let bezier10Path = UIBezierPath()
        bezier10Path.move(to: CGPoint(x: group.minX + 0.79314 * group.width, y: group.minY + 0.24662 * group.height))
        bezier10Path.addCurve(to: CGPoint(x: group.minX + 0.77466 * group.width, y: group.minY + 0.23958 * group.height), controlPoint1: CGPoint(x: group.minX + 0.78595 * group.width, y: group.minY + 0.24662 * group.height), controlPoint2: CGPoint(x: group.minX + 0.77979 * group.width, y: group.minY + 0.24461 * group.height))
        bezier10Path.addCurve(to: CGPoint(x: group.minX + 0.77466 * group.width, y: group.minY + 0.20338 * group.height), controlPoint1: CGPoint(x: group.minX + 0.76439 * group.width, y: group.minY + 0.22952 * group.height), controlPoint2: CGPoint(x: group.minX + 0.76439 * group.width, y: group.minY + 0.21343 * group.height))
        bezier10Path.addLine(to: CGPoint(x: group.minX + 0.81984 * group.width, y: group.minY + 0.15913 * group.height))
        bezier10Path.addCurve(to: CGPoint(x: group.minX + 0.85680 * group.width, y: group.minY + 0.15913 * group.height), controlPoint1: CGPoint(x: group.minX + 0.83010 * group.width, y: group.minY + 0.14907 * group.height), controlPoint2: CGPoint(x: group.minX + 0.84653 * group.width, y: group.minY + 0.14907 * group.height))
        bezier10Path.addCurve(to: CGPoint(x: group.minX + 0.85680 * group.width, y: group.minY + 0.19533 * group.height), controlPoint1: CGPoint(x: group.minX + 0.86707 * group.width, y: group.minY + 0.16919 * group.height), controlPoint2: CGPoint(x: group.minX + 0.86707 * group.width, y: group.minY + 0.18528 * group.height))
        bezier10Path.addLine(to: CGPoint(x: group.minX + 0.81162 * group.width, y: group.minY + 0.23958 * group.height))
        bezier10Path.addCurve(to: CGPoint(x: group.minX + 0.79314 * group.width, y: group.minY + 0.24662 * group.height), controlPoint1: CGPoint(x: group.minX + 0.80649 * group.width, y: group.minY + 0.24360 * group.height), controlPoint2: CGPoint(x: group.minX + 0.80033 * group.width, y: group.minY + 0.24662 * group.height))
        bezier10Path.close()
        fillColor.setFill()
        bezier10Path.fill()
    }



}
