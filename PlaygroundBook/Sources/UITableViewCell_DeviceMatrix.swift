import UIKit

class UITableViewCell_DeviceMatrix: UITableViewCell {
    
    public var isAnimated:Bool = false
    public var deviceFriendly:String? {
        didSet {
            _matrix.image = UIImage()
            if deviceFriendly != nil {
                DispatchQueue.main.async { [weak self] in
                    self?.asyncDrawMatrix()
                }
            }
        }
    }
    public var isConnected:Bool = false {
        didSet {
            let _isConnected = isConnected
            let image = _isConnected ? Layout.iconCheck : UIImage()
            DispatchQueue.main.async { [weak self] in
                self?._connected.image = image
            }
        }
    }
    private var _matrix = UIImageView()
    private var _connected = UIImageView()
    
    override var textLabel: UILabel? {
        return nil
    }
    
    override var imageView: UIImageView? {
        return nil
    }
    
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        //self.preservesSuperviewLayoutMargins = true
        self.backgroundColor = Layout.colorYellow
        
        self.contentView.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.clipsToBounds = true
        
        let marginGuide = contentView.layoutMarginsGuide
        
        _matrix.contentMode = .scaleAspectFit
        contentView.addSubview(_matrix)
        
        _connected.contentMode = .center
        contentView.addSubview(_connected)
        
        _matrix.translatesAutoresizingMaskIntoConstraints = false
        _matrix.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        _matrix.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        _matrix.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        _matrix.trailingAnchor.constraint(equalTo: marginGuide.centerXAnchor).isActive = true
        let matrixHeightConstraint = _matrix.heightAnchor.constraint(greaterThanOrEqualToConstant: 80.0)
        matrixHeightConstraint.priority = UILayoutPriority.defaultHigh
        matrixHeightConstraint.isActive = true
        
        _connected.translatesAutoresizingMaskIntoConstraints = false
        _connected.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        _connected.leadingAnchor.constraint(equalTo: marginGuide.centerXAnchor).isActive = true
        _connected.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        let connectedHeightConstraint = _connected.heightAnchor.constraint(equalTo: _matrix.heightAnchor)
        connectedHeightConstraint.priority = UILayoutPriority.defaultLow
        connectedHeightConstraint.isActive = true
        
        /*
        guard let label = textLabel else { return }
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: _matrix.bottomAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        label.textAlignment = .center
        */
        
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
		contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7))
    }
    

    private func asyncDrawMatrix() {
        guard let deviceFriendly = self.deviceFriendly else {
            print("no deviceFriendly")
            return
        }
        let heights = Matrix.friendly2Heights(deviceFriendly)
        let rect = _matrix.bounds
        guard rect != .zero else {
            print ("no rect yet")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let image = Matrix.heights2MatrixImage(heights: heights, rect: rect) {
                DispatchQueue.main.async { [weak self] in
                    self?._matrix.image = image
                }
            }
        }
    }
    
}
