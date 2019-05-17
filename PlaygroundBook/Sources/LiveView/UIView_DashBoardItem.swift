import UIKit

public enum DashboardItemType : UInt16 {
    case Display = 0x0000
    case ButtonA = 0x0001
    case ButtonB = 0x0002
    case ButtonAB = 0x0003
    case RGB = 0x004
    case Sound = 0x005
    case Pin = 0x006
    case Shake = 0x007
    case Thermometer = 0x008
    case Noise = 0x009
    case Brightness = 0x00a
    
    static func random() -> DashboardItemType {
        let types:[DashboardItemType] = [.Display, .RGB, .Sound, .ButtonA, .ButtonB, .Pin, .Shake, .Noise, .Brightness, .Thermometer]
        let index = Int(arc4random_uniform(UInt32(types.count)))
        return types[index]
    }
}

//enum DashboardItemGroup {
//    static let Input:[DashboardItemType] = [.Display, .RGB, .Sound]
//    static let Output:[DashboardItemType] = [.ButtonA, .ButtonB, .Pin, .Shake]
//    static let Sensor:[DashboardItemType] = [.Thermometer, .Noise, .Brightness]
//}

//FIXME: not nice to repeat enum...
public enum DashboardItemGroup {
    public enum Output : UInt16 {
        case Display = 0x01
        case RGB = 0x02
        case Sound = 0x03
    }
    public enum Input : UInt16 {
        case ButtonA = 0x04
        case ButtonB = 0x05
        case Pin = 0x06
        case Shake = 0x07
    }
    public enum Sensor : UInt16 {
        case Noise = 0x08
        case Brightness = 0x09
        case Thermometer = 0x10
    }
}

typealias DashboardItemStyle = [ DashboardItemType : [String:String] ]

fileprivate let dashboardItemStyles:DashboardItemStyle = [
    DashboardItemType.Display     : ["color": "calliope-purple"],
    DashboardItemType.RGB         : ["color": "calliope-purple"],
    DashboardItemType.Sound       : ["color": "calliope-purple"],
    DashboardItemType.ButtonA     : ["color": "calliope-turqoise"],
    DashboardItemType.ButtonB     : ["color": "calliope-turqoise"],
    DashboardItemType.Pin         : ["color": "calliope-turqoise"],
    DashboardItemType.Shake       : ["color": "calliope-turqoise"],
    DashboardItemType.Noise       : ["color": "calliope-orange"],
    DashboardItemType.Thermometer : ["color": "calliope-darkgreen"],
    DashboardItemType.Brightness  : ["color": "calliope-yellow"]
]

// state AWAITING, RUNNING = colors
// names...

public class UIView_DashboardItem: UIView {
    
    static let Ping = Notification.Name("cc.calliope.mini.dashboardnotification")
    
    public var type:DashboardItemType!
    private var highlight:UIView!
    lazy var symbolBackgroundLayer: CAShapeLayer = {
        let symbolBackgroundLayer = CAShapeLayer()
        symbolBackgroundLayer.backgroundColor = UIColor.clear.cgColor
        symbolBackgroundLayer.fillColor = UIColor(white: 1.0, alpha: Debug.debugSymbolBgAlpha).cgColor
        return symbolBackgroundLayer
    }()
    private var container:UIView_DashboardItemAnimation!
    private var observer_animation:NotificationToken!
    private var isAnimating:Bool = false
    
    private var bg_color:UIColor {
        if let bg_color = dashboardItemStyles[self.type]?["color"] {
            return UIColor(named: bg_color) ?? UIColor.white
        } else {
            return .red
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // add type and animation
    convenience init(type: DashboardItemType, ani:UIView_DashboardItemAnimation) {
        self.init(frame: CGRect())
        
        self.type = type
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        
        // highlight
        highlight = UIView()
        highlight.translatesAutoresizingMaskIntoConstraints = false
        addSubview(highlight)
        
        NSLayoutConstraint.activate([
            highlight.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            highlight.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            highlight.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            highlight.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
            ])
        
        highlight.backgroundColor = self.bg_color
        
        // symbol bg
        self.highlight.layer.addSublayer(self.symbolBackgroundLayer)
        
        // container
        container = ani
        container.base_color = self.bg_color
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            container.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            container.constraint_width, container.constraint_height
            ])
        
        // ping notification
        observer_animation = NotificationCenter.default.observe(name: UIView_DashboardItem.Ping, object: nil, queue: .main, using: { [weak self] (note) in
            guard let userInfo = note.userInfo, let type = userInfo["type"] as? DashboardItemType else {
                //LogNotify.log("No userInfo found in notification")
                return
            }
            
            if let this = self {
                guard this.type == type else { return }
                
                // LogNotify.log("before ani: \(this.type!) : isAnimating: \(this.isAnimating)")
                
                if let ani = this.container {
                    
                    if let value = userInfo["value"] as? UInt8 {
                        ani.updateLabel(value: value)
                    }
                    
                    guard !this.isAnimating else { return }
                    
                    this.isAnimating = true
                    ani.run({ (finished) in
                        DispatchQueue.main.async {
                            this.isAnimating = false
                            //LogNotify.log("after ani: \(this.type!)")
                        }
                    })
                }
            }
            
        })
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        for view in subviews {
            if view is UIView_DashboardItemAnimation {
                view.setNeedsLayout()
                view.layoutIfNeeded()
                
                self.symbolBackgroundLayer.frame = view.frame
                let symbol_bg_path = UIBezierPath(ovalIn: view.bounds.insetBy(percentage: Layout.symbolInsetByPercentage))
                self.symbolBackgroundLayer.path = symbol_bg_path.cgPath
            }
        }
        
    }
    
}

protocol UIView_DashboardItemAnimation_Animator {
    func run(_ completionBlock:  @escaping ((_ finished: Bool) -> Void))
    func updateLabel(value: UInt8)
}

public class UIView_DashboardItemAnimation: UIView, UIView_DashboardItemAnimation_Animator {
    private let _scale:CGFloat = 0.9
    private var _width_constant:CGFloat = 0.0
    private var _ratio:CGFloat {
        if let sv = self.superview {
            return min(sv.bounds.size.width, sv.bounds.size.height)
        }
        return 0.0
    }
    
    var base_color:UIColor?
    
    fileprivate lazy var constraint_width:NSLayoutConstraint = {
        return self.widthAnchor.constraint(equalToConstant: self._ratio*self._scale)
    }()
    
    fileprivate lazy var constraint_height:NSLayoutConstraint = {
        return self.heightAnchor.constraint(equalToConstant: self._ratio*self._scale)
    }()
    
    var textLabel:UILabel?
    var textLabelXConstraint:NSLayoutConstraint?
    var textLabelYConstraint:NSLayoutConstraint?
    var swoosh:Swoosh?
    var completionBlock: ((Bool) -> Void)?
    var canUpdateLabel:Bool = true
    
    convenience init() {
        self.init(frame:CGRect())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red:1, green: 0, blue:0, alpha:Debug.debugGridBgAlpha)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var frame: CGRect{
        didSet{
            adjustFrames()
        }
    }
    
    override public var bounds: CGRect{
        didSet{
            adjustFrames()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.updateCustomConstraints()
        let _width = min(self.bounds.size.width, self.bounds.size.height)
        let radius: CGFloat = _width / 2.0
        self.layer.cornerRadius = radius
    }
    
    func updateCustomConstraints() {
        //self.layoutIfNeeded()
        if _width_constant != _ratio {
            _width_constant = _ratio
            constraint_width.constant = _ratio*_scale
            constraint_height.constant = _ratio*_scale
            //self.layoutIfNeeded()
        }
    }
    
    func run(_ completionBlock:  @escaping ((_ finished: Bool) -> Void)) {
    }
    
    func updateLabel(value: UInt8) {
        guard let lbl = textLabel else { return }
        guard canUpdateLabel else { return }
        
        canUpdateLabel = false
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            lbl.alpha = 0
            lbl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: { (finished) in
            lbl.text = "\(value)"
        })
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            lbl.alpha = 1.0
            lbl.transform = .identity
        }, completion: { [weak self] (finished) in
            self?.canUpdateLabel = true
        })
        
    }
    
    func adjustFrames() {
        //print("*** adjustFrames \(frame) \(bounds)")
        if let sw = self.swoosh {
            sw._heightConstraint.constant = bounds.size.height * Layout.symbolInsetByPercentage
            sw._widthConstraint.constant = bounds.size.width * Layout.symbolInsetByPercentage
            sw.setNeedsLayout()
            sw.layoutIfNeeded()
        }
        
        // text label layout
        guard let sv = superview?.bounds, let tXc = textLabelXConstraint, let tYc = textLabelYConstraint else {
            return
        }
        let horizontal:Bool = (sv.size.width > sv.size.height)
        let w = bounds.size.width * 0.5
        tXc.constant = horizontal ? w*1.08 : 0
        tYc.constant = horizontal ? 0 : w
    }
    
    func addSwoosh() {
        let _swoosh = Swoosh()
        self.addSubview(_swoosh)
        
        _swoosh._widthConstraint = _swoosh.widthAnchor.constraint(equalToConstant: 100)
        _swoosh._heightConstraint = _swoosh.heightAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([
            _swoosh._widthConstraint,
            _swoosh._heightConstraint,
            _swoosh.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0),
            _swoosh.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0)
        ])
        
//        _swoosh.layout { (av) in
//
//        }
        
        _swoosh.show(deadline: .greatestFiniteMagnitude) { [weak self] in
            _ = self
            // print("ActivityView timeout \(self!)")
        }
        
        self.swoosh = _swoosh
    }
    
    func removeSwoosh() {
        self.swoosh?.hide()
        self.swoosh?.removeFromSuperview()
    }
    
    deinit {
        self.removeSwoosh()
        print("deinit")
    }
}
