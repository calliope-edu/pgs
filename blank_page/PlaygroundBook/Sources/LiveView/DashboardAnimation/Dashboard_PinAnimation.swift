import UIKit

class Dashboard_PinAnimation: UIView_DashboardItemAnimation, CAAnimationDelegate {
    
    private let ring_border_scale:CGFloat = 0.1
    
    private lazy var ring_view:UIView = {
        let ring = UIView(frame: CGRect.zero)
        ring.translatesAutoresizingMaskIntoConstraints = false
        ring.backgroundColor = .white
        return ring
    }()
    
    private lazy var ring_inner_view:UIView = {
        let ring = UIView(frame: CGRect.zero)
        ring.translatesAutoresizingMaskIntoConstraints = false
        return ring
    }()
    
    override var base_color: UIColor? {
        didSet {
            ring_inner_view.backgroundColor = base_color
        }
    }
    
    //MARK: - animator
    
    override func run(_ completionBlock: @escaping ((Bool) -> Void)) {
        let animation_duration:Double = 0.6
        let a_duration:Double = animation_duration * 0.35
        let b_duration:Double = animation_duration * 0.65
            
        UIView.animate(withDuration: a_duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: { [weak self] in
                        
                        self?.ring_view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                        self?.ring_inner_view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                        
        }, completion: nil)
        
        UIView.animate(withDuration: b_duration,
                       delay: a_duration,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.7,
                       options: [],
                       animations: { [weak self] in
                        
                        self?.ring_view.transform = .identity
                        self?.ring_inner_view.transform = .identity
                        
            }, completion: completionBlock)
    }
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.addSubview(ring_view)
        NSLayoutConstraint.activate([
            ring_view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            ring_view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            ring_view.centerXAnchor.constraint(equalTo: centerXAnchor),
            ring_view.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        self.addSubview(ring_inner_view)
        NSLayoutConstraint.activate([
            ring_inner_view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            ring_inner_view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            ring_inner_view.centerXAnchor.constraint(equalTo: centerXAnchor),
            ring_inner_view.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        self.textLabel = LayoutHelper.animationLabel(in: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ring_view.layer.cornerRadius = ring_view.frame.height * 0.5
        ring_inner_view.layer.cornerRadius = ring_inner_view.frame.height * 0.5
    }
}


