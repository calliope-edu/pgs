import UIKit
import QuartzCore

final class Swoosh: UIView {
    private let _inset: CGFloat = 8.0
    private let _pathLayer: CAShapeLayer = CAShapeLayer()
    private var _timer:Timer?
    
    public var active: Bool = false
    public var _heightConstraint:NSLayoutConstraint!
    public var _widthConstraint:NSLayoutConstraint!
    
    override func needsUpdateConstraints() -> Bool {
        return true
    }
    
    override init(frame: CGRect = .zero) {
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
        _pathLayer.lineWidth = _inset * 1.2
        _pathLayer.fillColor = UIColor.clear.cgColor
        _pathLayer.strokeColor = UIColor(white: 1.0, alpha: 0.6).cgColor
        _pathLayer.lineCap = "round"
        layer.addSublayer(_pathLayer)
        backgroundColor = .clear
    }
    
    private func circlePath() -> UIBezierPath {
        var insetFrame = bounds.insetBy(dx: _inset, dy: _inset)
        insetFrame.origin.x = _inset
        insetFrame.origin.y = _inset
        // TODO: rotation?
        return UIBezierPath(ovalIn: insetFrame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _pathLayer.frame = bounds
        _pathLayer.path = circlePath().cgPath
    }
    
    public func layout(_ block: @escaping (Swoosh)->Void) {
        self.hide()
        
        block(self)
        
        guard self.superview != nil else {
            fatalError("Swoosh has no superview - layout() might not be used as expected")
        }
    }
    
    public func show(deadline: Double? = nil, timeout: @escaping ()->Void) {
        guard !self.active else {
            NSLog("oooops - Swoosh is already active.")
            return
        }
        
        let me = self
        
        guard me.superview != nil else {
            fatalError("Swoosh has no superview - layout() might not be used as expected")
        }
        
        me.active = true
        
        if let max = deadline {
            var _current: Double = 0.0
            me._timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (t) in
                _current += 0.1
                if _current > max {
                    timeout()
                    self?.hide()
                }
            })
        }
        
        me.layoutIfNeeded()
        
        let beginTime: Double = 0.3
        let strokeStartDuration: Double = 2.0
        let strokeEndDuration: Double = strokeStartDuration - 0.3
        
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
        
        
        // LineWidth animation
        let l1 = _pathLayer.lineWidth
        let l2 = l1 * 2
        let l3 = l1
        let lineWidthAnimation = CAKeyframeAnimation(keyPath: "lineWidth")
        lineWidthAnimation.keyTimes = [0, 0.6, 1]
        lineWidthAnimation.values = [l1, l2, l3]
        lineWidthAnimation.duration = strokeStartDuration + beginTime
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [strokeEndAnimation, strokeStartAnimation, lineWidthAnimation]
        groupAnimation.duration = strokeStartDuration + beginTime
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        
        me._pathLayer.path = me.circlePath().cgPath
        me._pathLayer.add(groupAnimation, forKey: "animation")
        me.layoutIfNeeded()
    }
    
    public func hide() {
        self.active = false
        let me = self
        me._pathLayer.removeAllAnimations()
        me._pathLayer.path = nil
        me._timer?.invalidate()
        me._timer = nil
    }
    
}

