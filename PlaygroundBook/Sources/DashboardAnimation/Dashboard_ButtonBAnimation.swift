import UIKit

class Dashboard_ButtonBAnimation: UIView_DashboardItemAnimation, CAAnimationDelegate {
    
    private lazy var bg_view:UIView = {
        let bg = UIView(frame: CGRect.zero)
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.backgroundColor = Layout.colorButtonAnimationBg
        return bg
    }()
    
    private lazy var container_view:UIView = {
        let cont = UIView(frame: CGRect.zero)
        cont.translatesAutoresizingMaskIntoConstraints = false
        cont.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0)
        return cont
    }()
    
    private lazy var dot_view:UIView = {
        let dot = UIView(frame: CGRect.zero)
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        return dot
    }()
    
    private var button_labelA:UILabel?
    private var button_labelB:UILabel?
    
    private let dot_initial_pos:Int = 1
    private let button_name:String = "B"
    
    //MARK: - animator
    
    override func run(_ completionBlock: @escaping ((Bool) -> Void)) {
        dot_animate(pos: dot_initial_pos, dur: 0.5, completionBlock: completionBlock)
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
        self.addSubview(bg_view)
        NSLayoutConstraint.activate([
            bg_view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            bg_view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65),
            bg_view.centerXAnchor.constraint(equalTo: centerXAnchor),
            bg_view.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        bg_view.addSubview(container_view)
        NSLayoutConstraint.activate([
            container_view.heightAnchor.constraint(equalTo: bg_view.heightAnchor, multiplier: 0.9),
            container_view.widthAnchor.constraint(equalTo: bg_view.widthAnchor, multiplier: 0.96),
            container_view.centerXAnchor.constraint(equalTo: bg_view.centerXAnchor),
            container_view.centerYAnchor.constraint(equalTo: bg_view.centerYAnchor)
            ])
        
        container_view.addSubview(dot_view)
        NSLayoutConstraint.activate([
            dot_view.heightAnchor.constraint(equalTo: container_view.heightAnchor),
            dot_view.widthAnchor.constraint(equalTo: container_view.heightAnchor),
            dot_view.centerXAnchor.constraint(equalTo: container_view.centerXAnchor),
            dot_view.centerYAnchor.constraint(equalTo: bg_view.centerYAnchor)
            ])
        
        let charA = Layout.buttonLabel(in: container_view)
        charA.text = button_name
        NSLayoutConstraint.activate([
            charA.heightAnchor.constraint(equalTo: container_view.heightAnchor, multiplier: 0.84),
            charA.widthAnchor.constraint(equalTo: container_view.heightAnchor, multiplier: 1.0),
            charA.leadingAnchor.constraint(equalTo: container_view.leadingAnchor, constant: 0),
            charA.centerYAnchor.constraint(equalTo: container_view.centerYAnchor)
            ])
        self.button_labelA = charA
        
        let charB = Layout.buttonLabel(in: container_view)
        charB.text = button_name
        charB.textColor = Layout.colorButtonAnimationBg
        charB.alpha = 0.0
        NSLayoutConstraint.activate([
            charB.heightAnchor.constraint(equalTo: container_view.heightAnchor, multiplier: 0.84),
            charB.widthAnchor.constraint(equalTo: container_view.heightAnchor, multiplier: 1.0),
            charB.leadingAnchor.constraint(equalTo: container_view.leadingAnchor, constant: 0),
            charB.centerYAnchor.constraint(equalTo: container_view.centerYAnchor)
            ])
        self.button_labelB = charB
        
    }
    
    override func adjustFrames() {
        super.adjustFrames()
        bg_view.layer.cornerRadius = bg_view.bounds.size.height * 0.5
        container_view.layer.cornerRadius = container_view.bounds.size.height * 0.5
        dot_view.layer.cornerRadius = dot_view.bounds.size.height * 0.5
        dot_view.transform = dot_transform(for: dot_initial_pos).initial
    }
    
    fileprivate func dot_transform(for pos: Int) -> (initial: CGAffineTransform, ani: CGAffineTransform) {
        let w = container_view.bounds.size.width * 0.5
        let d = dot_view.bounds.size.width * 0.5
        
        var trans_initial:CGAffineTransform = .identity
        var trans_ani:CGAffineTransform = .identity
        
        switch pos {
        case -1:
            trans_initial = trans_initial.translatedBy(x: -w + d, y: 0) //CGAffineTransform(translationX: -100, y: 0)
            trans_ani = trans_ani.translatedBy(x: w - d, y: 0)
        case 1:
            trans_initial = CGAffineTransform(translationX: w - d, y: 0)
            trans_ani = CGAffineTransform(translationX: -w + d, y: 0)
        default:
            print("dot_transform failed...")
        }
        
        return (trans_initial, trans_ani)
    }
    
    fileprivate func dot_animate(pos:Int, dur:CFTimeInterval, completionBlock: ((Bool) -> Void)? = nil) {
        let trans = dot_transform(for: pos)
        
        UIView.animate(withDuration: dur*0.5, delay: 0, options: .curveEaseOut, animations: {
            self.button_labelB?.alpha = 1.0
            self.dot_view.transform = trans.ani
        }, completion: nil)
        
        UIView.animate(withDuration: dur*0.3, delay: dur*0.7, options: .curveEaseOut, animations: {
            self.button_labelB?.alpha = 0.0
            self.dot_view.transform = trans.initial
        }) { (finished) in
            if let block = completionBlock {
                block(finished)
            }
        }
        
    }
    
}
