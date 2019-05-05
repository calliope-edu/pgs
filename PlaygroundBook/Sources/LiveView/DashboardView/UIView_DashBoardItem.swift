import UIKit

public struct DashboardItemType: Hashable {

	let rawValue: UInt16

	var intrinsicContentSize: CGSize {
		switch self {
		case .ButtonA, .ButtonB:
			return CGSize(width: 100, height: 50)
		case .Thermometer, .Noise, .Brightness:
			return CGSize(width: 150, height: 150)
		default:
			return CGSize(width: 100, height: 100)
		}
	}

	static let Display = DashboardItemType(rawValue: Output.Display.rawValue)
	static let RGB = DashboardItemType(rawValue: Output.RGB.rawValue)
	static let Sound = DashboardItemType(rawValue: Output.Sound.rawValue)

	static let ButtonA = DashboardItemType(rawValue: Input.ButtonA.rawValue)
	static let ButtonB = DashboardItemType(rawValue: Input.ButtonB.rawValue)
	static let ButtonAB = DashboardItemType(rawValue: Input.ButtonA.rawValue + Input.ButtonB.rawValue)
	static let Pin = DashboardItemType(rawValue: Input.Pin.rawValue)
	static let Shake = DashboardItemType(rawValue: Input.Shake.rawValue)

	static let Thermometer = DashboardItemType(rawValue: Sensor.Thermometer.rawValue)
	static let Noise = DashboardItemType(rawValue: Sensor.Noise.rawValue)
	static let Brightness = DashboardItemType(rawValue: Sensor.Brightness.rawValue)

	static let types: [DashboardItemType] = [.Display, .RGB, .Sound, .ButtonA, .ButtonB, .Pin, .Shake, .Noise, .Brightness, .Thermometer]

	static func random() -> DashboardItemType {
		let index = Int(arc4random_uniform(UInt32(types.count)))
		return types[index]
	}

	private init(rawValue: UInt16) {
		self.rawValue = rawValue
	}

	init?(value: UInt16) {
		guard (DashboardItemType.types.map { $0.rawValue }).contains(value) else { return nil }
		self.init(rawValue: value)
	}

	public enum Output: UInt16, CaseIterable {
		case Display = 0x0000
		case RGB = 0x004
		case Sound = 0x005
	}
	public enum Input: UInt16, CaseIterable {
		case ButtonA = 0x0001
		case ButtonB = 0x0002
		case Pin = 0x006
		case Shake = 0x007
	}
	public enum Sensor: UInt16, CaseIterable {
		case Thermometer = 0x008
		case Noise = 0x009
		case Brightness = 0x00a
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
        symbolBackgroundLayer.fillColor = UIColor(white: 1.0, alpha: DebugConstants.debugSymbolBgAlpha).cgColor
        return symbolBackgroundLayer
    }()
    private var container: UIView_DashboardItemAnimation!
    private var observer_animation: NotificationToken!
    private var isAnimating:Bool = false

	public override var intrinsicContentSize: CGSize {
		return type.intrinsicContentSize
	}
    
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
        observer_animation = subscribeToUiUpdateNotifications()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        for view in subviews {
            if view is UIView_DashboardItemAnimation {
                view.setNeedsLayout()
                view.layoutIfNeeded()

                self.symbolBackgroundLayer.frame = view.frame
                let symbol_bg_path = UIBezierPath(ovalIn: view.bounds.insetBy(percentage: LayoutHelper.symbolInsetByPercentage))
                self.symbolBackgroundLayer.path = symbol_bg_path.cgPath
            }
        }

    }

	func subscribeToUiUpdateNotifications() -> NotificationToken {
		return NotificationCenter.default.observe(name: UIView_DashboardItem.Ping, object: nil, queue: .main)
		{ [weak self] (note) in
			guard let this = self,
				let userInfo = note.userInfo,
				let typeValue = userInfo["type"] as? UInt16,
				let type = DashboardItemType(value: typeValue),
				this.type == type,
				let ani = this.container
				else { return }

			if let value = userInfo["value"] as? Int {
				LogNotify.log("update label of \(type) to \(value)")
				DispatchQueue.main.async {
					ani.updateLabel(value: value)
				}
			} else {
				LogNotify.log("cannot read value for dashboard item label of \(type)")
			}

			guard !this.isAnimating else { return }

			this.isAnimating = true
			ani.run { finished in
				DispatchQueue.main.async {
					this.isAnimating = false
					//LogNotify.log("after ani: \(this.type!)")
				}
			}
		}
	}
}

protocol UIView_DashboardItemAnimation_Animator {
    func run(_ completionBlock:  @escaping ((_ finished: Bool) -> Void))
    func updateLabel(value: Int)
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
    var textLabelXConstraint: NSLayoutConstraint?
    var textLabelYConstraint: NSLayoutConstraint?
    var swoosh: Swoosh?
    var completionBlock: ((Bool) -> Void)?
    var canUpdateLabel: Bool = true

    convenience init() {
        self.init(frame:CGRect())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red:1, green: 0, blue:0, alpha:DebugConstants.debugGridBgAlpha)
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

    func updateLabel(value: Int) {
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
            sw._heightConstraint.constant = bounds.size.height * LayoutHelper.symbolInsetByPercentage
            sw._widthConstraint.constant = bounds.size.width * LayoutHelper.symbolInsetByPercentage
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
