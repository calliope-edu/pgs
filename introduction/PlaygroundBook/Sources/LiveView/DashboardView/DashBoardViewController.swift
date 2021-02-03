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
	var connectionView = MatrixConnectionViewController<ProgrammableCalliope>(nibName: "MatrixConnectionViewController", bundle: nil)

	public required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	public convenience init(_ ident:String = "",
							_ output: [DashboardItemType.Output],
							_ input: [DashboardItemType.Input],
							_ sensor: [DashboardItemType.Sensor]) {
		self.init(nibName: nil, bundle: nil)
		self.identifier = ident

		self.setUpUI(output, input, sensor)
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
		LogNotify.log("ProgrammableCalliopeDashboardViewController loaded")
	}

	func setUpUI(_ output: [DashboardItemType.Output], _ input: [DashboardItemType.Input], _ sensor: [DashboardItemType.Sensor],
				 chapter: Int = 0, pageNumber: Int = 0) {
		self.view.backgroundColor = UIColor.clear

		let top_const: CGFloat = 20.0

		stack = UIStackView_Dashboard(output, input, sensor)
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		stack.isLayoutMarginsRelativeArrangement = true
		self.view.addSubview(stack)

		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 0),
			stack.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor, constant: 0),
			stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
			stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
			])

		let matrixViewController = self.connectionView
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
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(collapseViews))
		gestureRecognizer.delegate = self
		self.view.addGestureRecognizer(gestureRecognizer)

		if DebugConstants.debugView {
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
				logger.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 40.0),
				logger.heightAnchor.constraint(equalToConstant: 220.0)
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
		connectionView.uploadProgram(program: prog).done({ (msg, success) in
			LogNotify.log("upload worked: \(success) - \(msg)")
			if(!success) {
				let alert = UIAlertController(title: "alert.notconnected.title".localized, message: msg, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "alert.notconnected.button".localized, style: .default, handler: nil))
				self.present(alert, animated: true)
			}
		})
	}

	@objc private func collapseViews() {
		self.connectionView.animate(expand: false)
	}
}

//MARK: collapse gesture recognizer delegate

extension DashBoardViewController: UIGestureRecognizerDelegate {
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		//prevent gestures on connection view itself from collapsing the view
		let connectionViewController = self.connectionView
		return !(touch.view?.isDescendant(of: connectionViewController.view) ?? false)
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
			LogNotify.log("live view received string: \(msg)")
		} else if case let .dictionary(msg) = message,
			case let .data(program)? = msg[PlaygroundValueKeys.programKey] {
			LogNotify.log("live view receive program: \(program.hexEncodedString())")
			upload(program)
		} else if case let .dictionary(msg) = message,
			case let .dictionary(notificationInfo)? = msg[DebugConstants.logNotifyName],
			case let .string(text)? = notificationInfo["message"] {
			LogNotify.log(text)
		} else {
			LogNotify.log("live view received unknown message: \(message)")
		}
	}
}

