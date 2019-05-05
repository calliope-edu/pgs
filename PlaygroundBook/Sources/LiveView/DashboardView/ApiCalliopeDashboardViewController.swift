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

public class ApiCalliopeDashboardViewController: ViewController_Base {

	var identifier:String = ""

	var stack: UIStackView_Dashboard!
	var connectionView = MatrixConnectionViewController<ApiCalliope>(nibName: "MatrixConnectionViewController", bundle: nil)
	var configurationView = DashBoardConfigurationViewController(nibName: "DashBoardConfigurationViewController", bundle: nil)

	//size constants
	let topMargin: CGFloat = 20.0
	let buttonSize: CGFloat = 50.0

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

		UISetup(output, input, sensor)
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
		LogNotify.log("ApiCalliopeDashboardViewController loaded")
	}

	func UISetup(_ output: [DashboardItemType.Output], _ input: [DashboardItemType.Input], _ sensor: [DashboardItemType.Sensor],
				 chapter: Int = 0, pageNumber: Int = 0) {

		self.view.backgroundColor = UIColor.gray

		configureDashboardItems(output, input, sensor)

		addConfigurationView()

		addConnectionView()

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
				logger.leftAnchor.constraint(equalTo: view.leftAnchor, constant: topMargin),
				logger.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -topMargin),
				logger.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 40.0),
				logger.heightAnchor.constraint(equalToConstant: 220.0)
				])
		}
	}

	func reconfigure(items: [DashboardItemType]) {
		collapseViews()
		configureDashboardItems(
			items.compactMap { DashboardItemType.Output(rawValue: $0.rawValue) },
			items.compactMap { DashboardItemType.Input(rawValue: $0.rawValue) },
			items.compactMap { DashboardItemType.Sensor(rawValue: $0.rawValue) })
	}

	private func configureDashboardItems(_ output: [DashboardItemType.Output], _ input: [DashboardItemType.Input], _ sensor: [DashboardItemType.Sensor]) {

		if stack != nil {
			stack.removeFromSuperview()
		}

		stack = UIStackView_Dashboard(output, input, sensor)
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.isLayoutMarginsRelativeArrangement = true
		stack.insetsLayoutMarginsFromSafeArea = true
		self.view.insertSubview(stack, at: 0)

		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
			stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
			stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
			])
	}

	private func addConfigurationView() {
		let dashBoardConfigController = self.configurationView
		dashBoardConfigController.willMove(toParent: self)
		self.addChild(dashBoardConfigController)
		let dashBoardConfigView = dashBoardConfigController.view!
		dashBoardConfigView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(dashBoardConfigView)
		NSLayoutConstraint.activate([
			dashBoardConfigView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: topMargin),
			dashBoardConfigView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -topMargin*2 - buttonSize)])
		dashBoardConfigController.didMove(toParent: self)

		dashBoardConfigController.selectionCallback = reconfigure
	}

	private func addConnectionView() {
		let matrixViewController = self.connectionView
		matrixViewController.willMove(toParent: self)
		self.addChild(matrixViewController)
		let matrixView = matrixViewController.view!
		matrixView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(matrixView)
		NSLayoutConstraint.activate([
			matrixView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: topMargin),
			matrixView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -topMargin)])
		matrixViewController.didMove(toParent: self)
	}

	func setStackViewInsets() {
		if stack != nil {
			//TODO: set property so subviews can be layouted
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

		coordinator.animate(alongsideTransition: { _ in
			stackView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
		}, completion: { _ in
			let ani = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5, animations: {
				stackView.transform = CGAffineTransform.identity
			})
			ani.startAnimation()
		})
	}

	@objc private func collapseViews() {
		self.connectionView.animate(expand: false)
		self.configurationView.animate(expand: false)
	}
}

//MARK: live view safe area changes

extension ApiCalliopeDashboardViewController {
	public override func viewLayoutMarginsDidChange() {
		self.setStackViewInsets()
	}
}

//MARK: collapse gesture recognizer delegate

extension ApiCalliopeDashboardViewController: UIGestureRecognizerDelegate {
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		//prevent gestures on connection view itself from collapsing the view
		let connectionViewController = self.connectionView
		return !(touch.view?.isDescendant(of: connectionViewController.view) ?? false)
	}
}

//MARK: - PlaygroundLiveViewMessageHandler
extension ApiCalliopeDashboardViewController: PlaygroundLiveViewMessageHandler {

	public func liveViewMessageConnectionOpened() {
		// We don't need to do anything in particular when the connection opens.
		LogNotify.log("live view connection openend")
	}

	public func liveViewMessageConnectionClosed() {
		// We don't need to do anything in particular when the connection closes.
		LogNotify.log("live view connection closed")
	}

	public func receive(_ message: PlaygroundValue) {

		LogNotify.log("live view received: \(message)")

		if case let .dictionary(dict) = message {
			if case let .data(callData)? = dict[PlaygroundValueKeys.apiCommandKey],
				let call = ApiCommand(data: callData) {
				LogNotify.log("live view received api command \(call)")
				TeachingApiImplementation.instance.handleApiCommand(call, calliope: connectionView.usageReadyCalliope)
			} else if case let .data(callData)? = dict[PlaygroundValueKeys.apiRequestKey],
				let call = ApiRequest(data: callData) {
				LogNotify.log("live view received api request \(call)")
				TeachingApiImplementation.instance.handleApiRequest(call, calliope: connectionView.usageReadyCalliope)
			} else if case let .dictionary(msg) = message,
				case let .dictionary(notificationInfo)? = msg[DebugConstants.logNotifyName],
				case let .string(text)? = notificationInfo["message"] {
				LogNotify.log(text)
			} else {
				LogNotify.log("live view cannot handle call \(dict)")
			}
		}
	}
}

