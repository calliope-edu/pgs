import UIKit

public class ActionButton: UIButton
{
    public typealias ActionBlock = (()-> Void)
    fileprivate var _block:ActionBlock?
    
	public func addAction(_ action: @escaping ActionBlock, controlEvent: UIControl.Event)
    {
        _block = action
        self.addTarget(self, action: #selector(ActionButton.callActionBlock(_:)), for: controlEvent)
    }
    
    @objc func callActionBlock(_ sender: AnyObject)
    {
        if let action = _block
        {
            action()
        }
    }
    
    deinit
    {
        _block = nil
    }
    
    public func toggleLabel(_ visible:Bool) {
        UIView.animate(withDuration: 0.3) {
            self.titleLabel?.alpha = visible ? 1.0 : 0.0
        }
    }
    
    public func toggle(_ visible:Bool) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = visible ? 1.0 : 0.0
        }
    }
    
	public func setImageSmooth(_ image: UIImage?, for state: UIControl.State) {
        UIView.animate(withDuration: 0.6) {
            self.imageView?.alpha = 0.0
            self.setImage(image, for: state)
            self.imageView?.alpha = 1.0
        }
    }
    
	public func setTitleSmooth(_ title: String?, for state: UIControl.State) {
        UIView.animate(withDuration: 0.6) {
            self.titleLabel?.alpha = 0.0
            self.setTitle(title, for: state)
            self.titleLabel?.alpha = 1.0
        }
    }
    
    public convenience init(_ title: String, bgColor: UIColor = .clear, textColor: UIColor, width: CGFloat, height: CGFloat, corner: CGFloat = 0.0) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.backgroundColor = bgColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        self.setTitleColor(textColor, for: .normal)
        self.layer.cornerRadius = corner
        self.clipsToBounds = true
    }
}
