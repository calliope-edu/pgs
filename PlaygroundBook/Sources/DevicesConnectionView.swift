import Foundation
import UIKit
import PlaygroundSupport

public enum DevicesConnectionState: String {
    case connected = "connected"
    case scanning = "scanning"
    case disconnected = "disconnected"
    case error = "error"
    case notify = "notify"
}

public class DevicesConnectionView: UIView, PlaygroundLiveViewSafeAreaContainer {
    typealias DeviceTuple = (uuid: UUID, name: String)
    let latestDeviceKey = "cc.calliope.latestDeviceKey"
    
    var device:Calliope?
    private let scanTime:Double = 5.0
    
    private var state:DevicesConnectionState = .disconnected {
        didSet {
            switch state {
            case .connected:
                self._btn_toggle.setImageSmooth(Layout.iconMiniGreen, for: .normal)
            case .scanning:
                self._btn_toggle.setImageSmooth(Layout.iconMiniYellow, for: .normal)
            case .disconnected:
                self._btn_toggle.setImageSmooth(Layout.iconMiniRed, for: .normal)
            default:
                LogNotify.log("state default: \(state)")
            }
            
            if let block = self._stateBlock {
                block(state, Data())
            }
        }
    }
    
    private var _height:CGFloat = 50.0
    private var _width:CGFloat {
        get {
            if let block = safeAreaBlock, let guide = block() {
                _ = guide
                //LogNotify.log("--> \(String(describing: guide)) : \(String(describing: superview?.bounds.size.width))")
            }
            if let w = superview?.bounds.size.width {
                return (w*0.5)-10.0
            }
            return 200.0
        }
    }
    public var safeAreaBlock: (() -> UILayoutGuide?)?
    private var _height_opened:CGFloat {
        get {
            if let block = safeAreaBlock, let guide = block(), let h = superview?.safeAreaLayoutGuide.layoutFrame.size.height {
                let _offset = guide.layoutFrame.origin.y > 0 ? guide.layoutFrame.origin.y + 56.0 : (h-guide.layoutFrame.size.height) + 36.0
                return guide.layoutFrame.size.height - _offset
            }
            return 160.0
        }
    }
    private var _tapGesture:UITapGestureRecognizer?
    private var _expand_animation:UIViewPropertyAnimator?
    private var _stateBlock: ((DevicesConnectionState, Data) -> Void)?
    private let _stack = UIStackView()
    private var _btn_toggle:ActionButton!
    private var _btn_retry:ActionButton!
    private var _tableView: UITableView = UITableView()
    private var _data: [(uuid: UUID, name: String)] = []
    private var _widthConstraint:NSLayoutConstraint?
    private var _tableHeightConstraint:NSLayoutConstraint?
    
    private var _hidables:[UIView] = []
    private let queue = DispatchQueue(label: "bluetooth")
    
    private var _expanded:Bool = false {
        didSet {
            if let ani = _expand_animation {
                ani.stopAnimation(true)
                ani.finishAnimation(at: .end)
            }
            
            self._data = []
            self._tableView.reloadData()
            
            _btn_retry.toggle(false)
            
            self.setNeedsUpdateConstraints()
            
            let damp:CGFloat = _expanded ? 0.8 : 0.9
            
            _expand_animation = UIViewPropertyAnimator(duration:1.0, dampingRatio: damp, animations: { [unowned self] in
                for view in self._hidables {
                    view.isHidden = !self._expanded
                }
                self.superview?.layoutIfNeeded()
            })
            
            _expand_animation?.addCompletion({ [weak self] (pos) in
                if let me = self {
                    if me._expanded {
                        me.scanStart()
                    }
                }
            })
            
            _expand_animation?.startAnimation()
            
            if !_expanded, let _tap = _tapGesture {
                if let view = _tap.view {
                    view.removeGestureRecognizer(_tap)
                    _tapGesture = nil
                }
                if self.device == nil {
                    self.state = .disconnected
                } else {
                    self.state = .connected
                }
                self.scanStop()
                self._data = []
            } else {
                _tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOnBackgroundView(recognizer:)))
                _tapGesture?.delegate = self
                self.superview?.addGestureRecognizer(_tapGesture!)
            }
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ changeBlog: @escaping ((DevicesConnectionState, Data) -> Void)) {
        self.init(frame: .zero)
        self.backgroundColor = Layout.colorYellow
        self.layer.cornerRadius = _height * 0.5
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.preservesSuperviewLayoutMargins = true
        
        _stack.axis  = .vertical
        _stack.distribution = .equalSpacing
        _stack.alignment = .fill
        _stack.spacing = 0.0
        _stack.isUserInteractionEnabled = true
        _stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(_stack)
        
        self._stateBlock = changeBlog
        
        NSLayoutConstraint.activate([
            self.trailingAnchor.constraint(equalTo: _stack.trailingAnchor),
            self.leadingAnchor.constraint(equalTo: _stack.leadingAnchor),
            self.topAnchor.constraint(equalTo: _stack.topAnchor),
            self.bottomAnchor.constraint(equalTo: _stack.bottomAnchor),
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: _height)
        ])
        
        let widthConstraint = self.widthAnchor.constraint(equalToConstant: _width)
        widthConstraint.priority = UILayoutPriority.higherPriority(plus: 1)
        widthConstraint.isActive = true
        self._widthConstraint = widthConstraint
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupUI()
        if let deviceTuple = self.lastConnectedDevice {
            deviceConnect(uuid: deviceTuple.uuid, name: deviceTuple.name)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        //LogNotify.log("layoutSubviews")
        self._tableView.reloadData()
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        self._widthConstraint?.constant = _expanded ? self._width : self._height
        self._tableHeightConstraint?.constant = self._height_opened
        //LogNotify.log("updateConstraints")
    }
    
    private func setupUI() {
        _btn_toggle = ActionButton("", textColor: .red, width: 0.0, height: _height)
        _btn_toggle.addAction({ [unowned self] in
            self._expanded = !self._expanded
            }, controlEvent: .touchUpInside)
        _btn_toggle.contentEdgeInsets = .zero
        _btn_toggle.setImage(Layout.iconMiniRed, for: .normal)
        _btn_toggle.imageView?.translatesAutoresizingMaskIntoConstraints = false
        _btn_toggle.imageView?.trailingAnchor.constraint(equalTo: _btn_toggle.trailingAnchor, constant: 0.0).isActive = true
        _btn_toggle.imageView?.centerYAnchor.constraint(equalTo: _btn_toggle.centerYAnchor, constant: 0.0).isActive = true
        _stack.addArrangedSubview(_btn_toggle)
        
        _tableView.frame = .zero
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.separatorStyle = .none
        // _tableView.layoutMargins = .zero
		_tableView.contentInset = UIEdgeInsets(top: 2.0, left: 0, bottom: 2.0, right: 0)
        _tableView.separatorInset = .zero
        _tableView.estimatedRowHeight = _height
        //_tableView.rowHeight = UITableViewAutomaticDimension
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        _tableView.backgroundColor = Layout.colorYellow
        _tableView.register(UITableViewCell_DeviceMatrix.self, forCellReuseIdentifier: "MatrixCell")
        _stack.addArrangedSubview(_tableView)
        _hidables.append(_tableView)
        
        let tableHeightConstraint = _tableView.heightAnchor.constraint(equalToConstant: self._height_opened)
        tableHeightConstraint.priority = UILayoutPriority.defaultLow
        tableHeightConstraint.isActive = true
        self._tableHeightConstraint = tableHeightConstraint
        
        _btn_retry = ActionButton("", textColor: .red, width: 0.0, height: _height)
        _btn_retry.addAction({ [unowned self] in
            self.scanStart()
            }, controlEvent: .touchUpInside)
        _btn_retry.setImage(Layout.iconMiniReload, for: .normal)
        _btn_retry.contentEdgeInsets = .zero
        _stack.addArrangedSubview(_btn_retry)
        _hidables.append(_btn_retry)
        
        ActivityView.layout { [unowned self] (av) in
            self.addSubview(av)
            NSLayoutConstraint.activate([
                av.widthAnchor.constraint(equalToConstant: self._height-5.0),
                av.heightAnchor.constraint(equalToConstant: self._height-5.0),
                av.bottomAnchor.constraint(equalTo: self._stack.bottomAnchor, constant: -2.0),
                av.centerXAnchor.constraint(equalTo: self._stack.centerXAnchor, constant: 0.0)
            ])
        }
        
        for view in _hidables {
            view.isHidden = !self._expanded
        }
        self.state = .disconnected
    }
    
    private func scanStart() {
        LogNotify.log("scanStart")

        guard !ActivityView.active else {
            LogNotify.log("ActivityView not active")
            return
        }
        
        ActivityView.show(deadline: scanTime) { [weak self] in
            // LogNotify.log("ActivityView timeout")
            self?.scanStop()
        }
        
        self.state = .scanning
        _btn_retry.toggle(false)
        
        let lastDevice = self.lastConnectedDevice
        
        scanning(queue).done { [weak self] (result, success) in

            guard result.count > 0 else {
                // LogNotify.log("no need to update, no result")
                return
            }
            
            var data = result
                .sorted(by: { (first: (uuid: UUID, discovery: BluetoothDiscovery), second:(uuid: UUID, discovery: BluetoothDiscovery)) -> Bool in
                    let _first = first.discovery.rssi.intValue
                    let _second = second.discovery.rssi.intValue
                    return _first > _second
                })
                .map({ (uuid, discovery) -> DeviceTuple in
                    let ble_name = discovery.name ?? "ble.name.unknown".localized
                    return DeviceTuple(uuid: uuid, name: ble_name)
                })

            // add connected-device if missing or move to 0
            if let lastDevice = lastDevice {
                if let index = data.index(where: { $0.uuid == lastDevice.uuid }) {
                    if index != 0 {
                        let elem = data.remove(at: index)
                        data.insert(elem, at: 0)
                    }
                } else {
                    data.insert(lastDevice, at: 0)
                }
            }
            
            if let _data = self?._data {
                let removed = data.filter {
                    let dict = $0
                    return !_data.contains{ dict == $0 }
                }
                
                self?._tableView.performBatchUpdates({
                    let count = _data.count
                    self?._data.append(contentsOf: removed)
                    for (index,_) in removed.enumerated() {
                        let row = IndexPath(item: count+index, section: 0)
                        self?._tableView.insertRows(at: [row], with: .none)
                    }
                }, completion: { (completed) in
                    //
                })
            }
            
        }
    }
    
    private func scanStop() {
        LogNotify.log("scanStop")

        ActivityView.hide()
        
        if _expanded {
            _btn_retry.toggle(true)
        }
        Calliope.scanStop()
    }
    
    private func deviceConnect(uuid: UUID, name: String) {
        if self.device != nil {
            self.deviceDisconnect()
            self.lastConnectedDevice = nil
        }
        
        let device = Calliope(uuid: uuid)

        device.onDisconnect = { [weak self] _ in
            LogNotify.log("disconnected \(device)")
            self?.state = .disconnected
			//TODO: this is not the best place to nil out the device.
			if let assignedDevice = self?.device, assignedDevice.uuid == device.uuid {
				self?.device = nil
			}
        }
        
        device.onNotify = { [weak self] (_, data) in
            if let block = self?._stateBlock {
                block(.notify, data)
            }
        }
        
        async(queue) {
            LogNotify.log("connecting to device \(device)")

            try device.connect()
        }.done { [weak self] (_, success) in
            self?.state = success ? .connected : .error
            if success {
                LogNotify.log("connected")
                self?.device = device
                self?.lastConnectedDevice = DeviceTuple(uuid: device.uuid, name: name)
            } else {
                LogNotify.log("failed to connect")
            }
        }
    }
    
    private func deviceDisconnect() {
        self.device?.disconnect()
        self.device = nil
        self.lastConnectedDevice = nil
        self.state = .disconnected
    }
    
    @objc func didTappedOnBackgroundView(recognizer: UITapGestureRecognizer){
        self._expanded = !self._expanded
    }
}

//MARK: - tableview
extension DevicesConnectionView: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _data.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row_height:CGFloat = bounds.size.width > 200.0 ? 130.0 : 100.0
        return row_height
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatrixCell", for: indexPath as IndexPath) as! UITableViewCell_DeviceMatrix
        let (uuid, name) = _data[indexPath.row]
        //cell.textLabel?.text = "\(name) :: \(uuid.hashValue)"
        cell.deviceFriendly = Matrix.full2Friendly(fullName: name)
        cell.isConnected = self.device?.uuid == uuid
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! UITableViewCell_DeviceMatrix
        if cell.isAnimated { return }
        cell.isAnimated = true
        cell.alpha = 0.0
        cell.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        let ani = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5, animations: {
            cell.alpha = 1.0
            cell.transform = CGAffineTransform.identity
        })
        ani.addCompletion { (_) in
            cell.isAnimated = true
        }
        ani.startAnimation(afterDelay: 0.3)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! UITableViewCell_DeviceMatrix
        cell.isAnimated = false
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (uuid, name) = _data[indexPath.row]
        let connected = self.device?.uuid == uuid
        self._expanded = false
        if connected {
            self.deviceDisconnect()
            return
        }
        self.deviceConnect(uuid: uuid, name: name)
    }
    
}

//MARK: UIGestureRecognizerDelegate
extension DevicesConnectionView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let host = gestureRecognizer.view else {
            LogNotify.log("gesture recognizer has no hostview")
            return false
        }
        let locationInView = touch.location(in: host)
        if (self.frame.contains(locationInView) ) {
            return false
        } else {
            return true
        }
    }
}

//MARK: - lastConnectedDevice
extension DevicesConnectionView {
    private var lastConnectedDevice:DeviceTuple? {
        get {
            let store = PlaygroundKeyValueStore.current
            guard case let .dictionary(_deviceDict)? = store[latestDeviceKey] else {
                //LogNotify.log("defaults missing");
                return nil
            }
            guard case let .string(_uuidString)?  = _deviceDict["uuid"] else { LogNotify.log("_uuidString missing"); return nil }
            guard let _uuid = UUID(uuidString: _uuidString) else { LogNotify.log("_uuid issue"); return nil }
            guard case let .string(_name)? = _deviceDict["name"] else { LogNotify.log("_name missing"); return nil }
            return DeviceTuple(uuid: _uuid, name: _name)
        }
        set {
            if let val = newValue {
                let dict = ["uuid":PlaygroundValue.string(val.uuid.uuidString), "name":PlaygroundValue.string(val.name)]
                PlaygroundKeyValueStore.current[latestDeviceKey] = .dictionary(dict)
            } else {
                PlaygroundKeyValueStore.current[latestDeviceKey] = nil
            }
        }
    }
}

//MARK: scanning worker
extension DevicesConnectionView {
    func scanning(_ queue: DispatchQueue) -> Worker<[UUID: BluetoothDiscovery]> {
        return Worker { resolve in
            queue.async {
                do {
                    try Calliope.scanStart() { discoveries in

                        var uniq: [UUID: BluetoothDiscovery] = [:]
                        for discovery in discoveries {
                            uniq[discovery.key] = discovery.value
                        }

//                        let uniq = Dictionary<UUID, BluetoothDiscovery>(discoveries, uniquingKeysWith: { (first, _) in first })

                        let names = uniq.map { (key: UUID, value: BluetoothDiscovery) in
                            return value.name ?? key.uuidString
                        }
                        LogNotify.log("discoveries \(names)")

                        DispatchQueue.main.async {
                            resolve(Result(uniq, true))
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        resolve(Result([:], false))
                    }
                }
            }
        }
    }
}

//MARK: - Upload
extension DevicesConnectionView {
    func uploadProgram(program: ProgramBuildResult) -> Worker<String>  {
        return Worker { [weak self] resolve in
            guard let queue = self?.queue else { LogNotify.log("no object to work on...)"); return }
            guard let device = self?.device else {
                resolve(Result("result.upload.missing".localized, false))
                return
            }
            queue.async {
                do {
                    LogNotify.log("trying to upload \(program.length()) bytes")
                    try device.upload(program:program)
                    DispatchQueue.main.async {
                        resolve(Result("result.upload.success".localized, true))
                    }
                } catch {
                    DispatchQueue.main.async {
                        resolve(Result("result.upload.failed".localized, false))
                    }
                }
            }
        }
    }
}
