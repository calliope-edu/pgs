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
    
    var stack: UIStackView_Dashboard!
    var connectionView: MatrixConnectionViewController?

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

		let matrixViewController = MatrixConnectionViewController()
		connectionView = matrixViewController
		matrixViewController.willMove(toParent: self)
		self.addChild(matrixViewController)
		let matrixView = matrixViewController.view!
		matrixView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(matrixView)
		NSLayoutConstraint.activate([
			matrixView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: top_const),
			matrixView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -top_const)])
		matrixViewController.didMove(toParent: self)

		//set up gesture recognizer to collapse connection view
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(collapseConnectionViewController))
		gestureRecognizer.delegate = self
		self.view.addGestureRecognizer(gestureRecognizer)

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

        coordinator.animate(alongsideTransition:{ _ in
            stackView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
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

	@objc private func collapseConnectionViewController() {
		self.connectionView?.animate(expand: false)
	}
}

//MARK: collapse gesture recognizer delegate

extension DashBoardViewController: UIGestureRecognizerDelegate {
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		//prevent gestures on connection view itself from collapsing the view
		if let connectionViewController = self.connectionView {
			return !(touch.view?.isDescendant(of: connectionViewController.view) ?? false)
		} else {
			return false
		}
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

        if case let .string(msg) = message {
            LogNotify.log("live view receive string: \(msg)")
		} else if case let .dictionary(msg) = message,
			case let .data(program)? = msg[PlaygroundValueKeys.programKey] {
            //LogNotify.log("live view receive data: \(data)")
            upload(program)
            delay(time: 1.0) { [weak self] in
                let message: PlaygroundValue = .string(Keys.closeLiveProxyKey)
                self?.send(message)
            }
		} else if case let .dictionary(msg) = message,
			case let .data(callData)? = msg[PlaygroundValueKeys.apiCallKey] {
			//this is the case where we call the api of the calliope
			//TODO: the api call must only be invoked on certain pages.
			let call = ApiCall(data: callData)

			guard let apiCall = call else {
				LogNotify.log("live view received undecodable api call")
				return
			}
			LogNotify.log("live view received api call \(apiCall)")

			handleApiCall(apiCall)
		} else {
			delay(time: 1.0) { [weak self] in
				let message: PlaygroundValue = .string("ping from liveview")
				self?.send(message)
			}
		}
    }

	private func handleApiCall(_ apiCall: ApiCall) {
		//TODO: working so far is button notifications, button state requests, sleep, forever, start, led matrix calls, temperature request.
		//TODO: not working: rgb led, pins, shake callback, clap callback, sound api, noise request, brightness request

		//respond with a message back (either with value or just as a kind of "return" call)
		let calliope = connectionView?.apiReadyCalliope

		let response: ApiCall
		switch apiCall {
		case .registerCallbacks():
			registerCallbacks(calliope)
			response = .finished()
		case .rgbOn(let color):
			response = .finished()
		case .rgbOff:
			response = .finished()
		case .displayClear:
			calliope?.ledMatrixState = [[false, false, false, false, false],
										[false, false, false, false, false],
										[false, false, false, false, false],
										[false, false, false, false, false],
										[false, false, false, false, false]]
			response = .finished()
		case .displayShowGrid(let grid):
			//TODO: decode grid
			calliope?.ledMatrixState = interpretGrid(grid)
			response = .finished()
		case .displayShowImage(let image):
			calliope?.ledMatrixState = interpretGrid(image.grid)
			response = .finished()
		case .displayShowText(let text):
			calliope?.displayLedText(text)
			response = .finished()
		case .soundOff:
			response = .finished()
		case .soundOnNote(let note):
			response = .finished()
		case .soundOnFreq(let freq):
			response = .finished()
		case .requestButtonState(let button):
			var buttonPressed: Bool?
			if button == .A {
				let buttonState = calliope?.buttonAAction
				buttonPressed = buttonState == .Down || buttonState == .Long
			} else if button == .B {
				let buttonState = calliope?.buttonBAction
				buttonPressed = buttonState == .Down || buttonState == .Long
			} else {
				let buttonState1 = calliope?.buttonAAction
				let buttonState2 = calliope?.buttonBAction
				let buttonPressed1 = buttonState1 == .Down || buttonState1 == .Long
				let buttonPressed2 = buttonState2 == .Down || buttonState2 == .Long
				buttonPressed = buttonPressed1 && buttonPressed2
			}
			response = .respondButtonState(isPressed: buttonPressed == true)
		case .requestPinState(let pin):
			response = .respondPinState(isPressed: false)
		case .requestNoise:
			response = .respondNoise(level: 42)
		case .requestTemperature:
			response = .respondTemperature(degrees: Int16(calliope?.temperature ?? 42))
		case .requestBrightness:
			response = .respondBrightness(level: 42)
		default:
			if case .sleep(_) = apiCall {
			} else {
				LogNotify.log("cannot handle this api call")
			}
			response = .finished()
		}

		let t: Double
		if case .sleep(let time) = apiCall {
			t = Double(time)
		} else {
			t = 0.0
		}

		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + t) {
			self.send(apiCall: response)
		}
	}

	func interpretGrid(_ grid: [UInt8]) -> [[Bool]] {
		return (0..<5).map { row in (0..<5).map { column in grid[row * 5 + column] == 1 } }
	}

	func registerCallbacks(_ calliope: CalliopeBLEDevice?) {
		guard let calliope = calliope else { return }

		calliope.buttonAActionNotification = { action in
			guard let action = action else { return }
			let other = calliope.buttonBAction
			if action == .Down {
				let bothButtons = other == .Down || other == .Long
				self.send(apiCall: bothButtons ? .buttonAB() : .buttonA())
			} else if action == .Long {
				let bothButtons = other == .Long
				self.send(apiCall: bothButtons ? .buttonABLongPress() : .buttonALongPress())
			}
		}
		calliope.buttonBActionNotification = { action in
			guard let action = action else { return }
			let other = calliope.buttonAAction
			if action == .Down {
				let bothButtons = other == .Down || other == .Long
				self.send(apiCall: bothButtons ? .buttonAB() : .buttonB())
			} else if action == .Long {
				let bothButtons = other == .Long
				self.send(apiCall: bothButtons ? .buttonABLongPress() : .buttonBLongPress())
			}
		}
		//TODO: other callbacks to calliope
	}

	func send(apiCall: ApiCall) {
		LogNotify.log("sendig \(apiCall) to page")
		let data = apiCall.data
		let message: PlaygroundValue = .dictionary([PlaygroundValueKeys.apiCallKey: .data(data)])
		self.send(message)
	}
}

