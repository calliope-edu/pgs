import UIKit
import QuartzCore

final class ActivityView: UIView {
    private static let shared: ActivityView = {
        let view = ActivityView(frame: .zero)
        return view
    }()
    
    private let _inset: CGFloat = 1.0
    private let _pathLayer: CAShapeLayer = CAShapeLayer()
    private var _timer:Timer?
    
    public static var active: Bool = false
    
    override func needsUpdateConstraints() -> Bool {
        return true
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = false
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        _pathLayer.frame = bounds
        _pathLayer.lineWidth = 1.4
        _pathLayer.fillColor = UIColor.clear.cgColor
        _pathLayer.strokeColor = UIColor.white.cgColor
        _pathLayer.lineCap = "round"
        layer.addSublayer(_pathLayer)
        backgroundColor = .clear
    }
    
    private func circlePath() -> UIBezierPath {
        var insetFrame = bounds.insetBy(dx: _inset, dy: _inset)
        insetFrame.origin.x = _inset
        insetFrame.origin.y = _inset
        return UIBezierPath(ovalIn: insetFrame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _pathLayer.frame = bounds
    }
    
    public class func layout(_ block: @escaping (ActivityView)->Void) {
        ActivityView.hide()
        
        let me = ActivityView.shared
        block(me)
        
        guard me.superview != nil else {
            fatalError("ActivityView has no superview - layout() might not be used as expected")
        }
    }
    
    public class func show(deadline: Double? = nil, timeout: @escaping ()->Void) {
        guard !ActivityView.active else {
            NSLog("oooops - ActivityView is already active.")
            return
        }
        
        let me = ActivityView.shared
        
        guard me.superview != nil else {
            fatalError("ActivityView has no superview - layout() might not be used as expected")
        }
        
        ActivityView.active = true
        
        if let max = deadline {
            var _current: Double = 0.0
            me._timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (t) in
                _current += 0.1
                if _current > max {
                    timeout()
                    ActivityView.hide()
                }
            })
        }
        
        me.layoutIfNeeded()
        
        let beginTime: Double = 0.4
        let strokeStartDuration: Double = 1.0
        let strokeEndDuration: Double = 0.5
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = strokeEndDuration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.duration = strokeStartDuration
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        strokeStartAnimation.fromValue = 0.0
        strokeStartAnimation.toValue = 1.0
        strokeStartAnimation.beginTime = beginTime
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [strokeEndAnimation, strokeStartAnimation]
        groupAnimation.duration = strokeStartDuration + beginTime
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        
        me._pathLayer.path = me.circlePath().cgPath
        me._pathLayer.add(groupAnimation, forKey: "animation")
        me.layoutIfNeeded()
    }
    
    public class func hide() {
        ActivityView.active = false
        let me = ActivityView.shared
        me._pathLayer.removeAllAnimations()
        me._pathLayer.path = nil
        me._timer?.invalidate()
        me._timer = nil
    }

    public class func removeFromSuperview() {
        let me = ActivityView.shared
        me.removeFromSuperview()
    }
}
