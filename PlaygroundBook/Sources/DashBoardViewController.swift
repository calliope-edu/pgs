import Foundation
import UIKit
import CoreBluetooth
import PlaygroundSupport
import PlaygroundBluetooth

//TODO: connectionview BLE
//TODO: assesments
//TODO: active dashboard_boxes
//TODO: source from plist?

// https://developer.apple.com/library/content/documentation/Xcode/Conceptual/swift_playgrounds_doc_format/PlaygroundLiveViewMessageHandlerProtocol.html#//apple_ref/doc/uid/TP40017343-CH42-SW1

public class DashBoardViewController: ViewController_Base {

    var identifier:String = ""
    
    var stack:UIStackView_Dashboard!
    var connectionView:DevicesConnectionView?
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init(_ ident:String = "", _ output:[DashboardItemGroup.Output], _ input:[DashboardItemGroup.Input], _ sensor:[DashboardItemGroup.Sensor]) {
        self.init(nibName: nil, bundle: nil)
        self.identifier = ident
        
        UISetup(output, input, sensor)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        //LogNotify.log("DashBoardViewController loaded")
    }

    func UISetup(_ output:[DashboardItemGroup.Output], _ input:[DashboardItemGroup.Input], _ sensor:[DashboardItemGroup.Sensor]) {
        self.view.backgroundColor = UIColor.gray
        
        stack = UIStackView_Dashboard(output, input, sensor)
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 0
        stack.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stack.isLayoutMarginsRelativeArrangement = true
        self.view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        // button
        let top_const:CGFloat = 20.0

        /*
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
        */
            
        let connectionView = DevicesConnectionView({ (state, data) in
            let array = [UInt8](data)
            //LogNotify.log("notify array: \(array)")
            
            if state == DevicesConnectionState.notify {
                if let type = DashboardItemType(rawValue:UInt16(array[1])) {
                    let value:UInt8 = array[3]

                    //TODO: apply temperature conversion to "value" (which is the value read from the calliope) in case the DashboardItemType is Thermometer
                    //TODO: check if temperature dashboard item graphic is suitable for Fahrenheit unit. Otherwise we need to make a new drawing.

                    //LogNotify.log("notify_type: \(type)")
                    //LogNotify.log("notify: \(type.rawValue) : \(value)")
                    if(type == DashboardItemType.ButtonAB)
                    {
                        NotificationCenter.default.post(name:UIView_DashboardItem.Ping, object: nil, userInfo:["type":DashboardItemType.ButtonA, "value":value])
                        NotificationCenter.default.post(name:UIView_DashboardItem.Ping, object: nil, userInfo:["type":DashboardItemType.ButtonB, "value":value])
                    }
                    else
                    {
                        NotificationCenter.default.post(name:UIView_DashboardItem.Ping, object: nil, userInfo:["type":type, "value":value])
                    }
                }
            }
        })
        connectionView.safeAreaBlock = { [weak self] in
            if let me = self {
                return me.liveViewSafeAreaGuide
            }
            return nil
        }
        // on notify ??
        self.view.addSubview(connectionView)

        NSLayoutConstraint.activate([
            connectionView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: top_const),
            connectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -top_const)
        ])

        self.connectionView = connectionView

        if Debug.debugView {
            let logger = UITextView()
            logger.isEditable = false
            logger.tag = 666
			logger.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            logger.textColor = .green
            logger.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
            logger.font = UIFont.systemFont(ofSize: 14)
            logger.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(logger)
            
            NSLayoutConstraint.activate([
                logger.leftAnchor.constraint(equalTo: view.leftAnchor, constant: top_const),
                logger.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -top_const),
                logger.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0),
                logger.heightAnchor.constraint(equalToConstant: 240.0)
            ])
        }
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if size.width > size.height {
            stack.axis = .horizontal
        } else {
            stack.axis = .vertical
        }
        
        guard let stackView = stack else { return }
        guard let connectionView = connectionView else { return }
        
        coordinator.animate(alongsideTransition:{ _ in
            stackView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            connectionView.setNeedsUpdateConstraints()
        }, completion: { _ in
            let ani = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5, animations: {
                stackView.transform = CGAffineTransform.identity
            })
            ani.startAnimation()
        })
    }
    
    func upload(_ data: Data) {
        let decoder = PropertyListDecoder()
        guard let prog:ProgramBuildResult = try? decoder.decode(ProgramBuildResult.self, from: data) else {
            LogNotify.log("failed to encode build result")
            return
        }
        connectionView?.uploadProgram(program: prog).done({ (msg, success) in
            LogNotify.log("upload worked: \(success) - \(msg)")
            if(!success) {
                let alert = UIAlertController(title: "alert.notconnected.title".localized, message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "alert.notconnected.button".localized, style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        })
    }
}

//MARK: - PlaygroundLiveViewMessageHandler
extension DashBoardViewController: PlaygroundLiveViewMessageHandler {

    public func liveViewMessageConnectionOpened() {
        // We don't need to do anything in particular when the connection opens.
        LogNotify.log("live view connection openend")
    }

    public func liveViewMessageConnectionClosed() {
        // We don't need to do anything in particular when the connection closes.
        LogNotify.log("live view connection closed")
    }

    public func receive(_ message: PlaygroundValue) {
        
//        if case let .string(msg) = message {
//            //LogNotify.log("live view receive string: \(msg)")
//        } else
        if case let .data(data) = message {
            //LogNotify.log("live view receive data: \(data)")
            upload(data)
            delay(time: 1.0) { [weak self] in
                let message: PlaygroundValue = .string(Keys.closeLiveProxyKey)
                self?.send(message)
            }
            return
        }
        
        delay(time: 1.0) { [weak self] in
            let message: PlaygroundValue = .string("ping from liveview")
            self?.send(message)
        }
    }
}

