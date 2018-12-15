//
//  MatrixConnectionViewController.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 14.12.18.
//

import UIKit
import PlaygroundSupport

@objc
class MatrixConnectionViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer
{
	private let collapsedSize: CGFloat = 40
	private let expandedSize: CGFloat = 500

	/// button to toggle whether connection view is open or not
	@IBOutlet var collapseButton: UIButton!

	/// the matrix in which to draw the calliope name pattern
	@IBOutlet var matrixView: MatrixView!

	/// button to trigger the connection with the calliope
	@IBOutlet var connectButton: UIButton!

	/// constraint to collapse view horizontally
	@IBOutlet var collapseWidthConstraint: NSLayoutConstraint!
	/// constraint to collapse view vertically
	@IBOutlet var collapseHeightConstraint: NSLayoutConstraint!


	private let connector = CalliopeBLEDiscovery()
	public var calliope: CalliopeBLEDevice? {
		return connector.discoveredCalliopes[Matrix.matrix2friendly(matrixView.matrix) ?? ""]
	}


	@IBAction func toggleOpen(_ sender: Any) {
		if collapseButton.isSelected {
			//button selected --> view in open state --> collapse!
			animate(expand: false)
		} else {
			animate(expand: true)
		}
	}

	@IBAction func connect(_ sender: Any) {
		//TODO: implement connection logic
		if self.connector.state == .initialized
			|| self.calliope == nil && self.connector.state == .discoveredAll {
			connector.startCalliopeDiscovery()
		} else if let calliope = self.calliope {
			if calliope.state == .discovered {
				connector.stopCalliopeDiscovery()
				calliope.updateBlock = evaluateCalliopeState
				connector.connectToCalliope(calliope)
			} else if calliope.state == .notPlaygroundReady {
				calliope.evaluateMode()
			}
		} else {
			fatalError("connect button must not be enabled in this state")
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		connector.updateBlock = updateDiscoveryState
		//TODO: set up proper reactions to matrix image drawing
		matrixView.updateBlock = updateDiscoveryState
		animate(expand: false)
	}

	private func updateDiscoveryState() {
		switch self.connector.state {
		case .initialized:
			self.connectButton.isEnabled = true
			self.connectButton.setTitle(NSLocalizedString("Start search", comment: "button label in connection view to start search"), for: .normal)
		case .discoveryStarted:
			self.connectButton.isEnabled = false
			self.connectButton.setTitle(NSLocalizedString("Waiting for Bluetooth", comment: "button label in connection view if Bluetooth is off"), for: .normal)
		case .discovering, .discovered:
			if self.calliope != nil {
				evaluateCalliopeState()
			} else {
				self.connectButton.isEnabled = false
				self.connectButton.setTitle(NSLocalizedString("Searching Calliope", comment: "button label in connection view for the discovery process"), for: .normal)
			}
		default:
			evaluateCalliopeState()
		}
	}

	private func evaluateCalliopeState() {

		guard let calliope = self.calliope else {
			animate(connected: false)
			connector.discoveredCalliopes
				.filter { (_, calliope) -> Bool in
					return calliope.state != .discovered }
				.forEach { (_, calliope) in
					calliope.updateBlock = {}
					connector.disconnectCalliope(calliope) }

			self.connectButton.isEnabled = true
			self.connectButton.setTitle(NSLocalizedString("Not found... Try again?", comment: "button label in connection view if calliope with specified pattern was not found"), for: .normal)
			return
		}

		if calliope.state == .playgroundReady {
			self.animate(connected: true)
		} else {
			animate(connected: false)
		}

		switch calliope.state {
		case .discovered:
			self.connectButton.isEnabled = true
			self.connectButton.setTitle(NSLocalizedString("Connect", comment: "button label in connection view if calliope with specified pattern was found and can be connected"), for: .normal)
		case .connecting:
			self.connectButton.isEnabled = false
			self.connectButton.setTitle(NSLocalizedString("Connecting...", comment: "button label in connection view if connection to calliope is attempted"), for: .normal)
		case .connected:
			self.connectButton.isEnabled = false
			self.connectButton.setTitle(NSLocalizedString("Connected", comment: "button label in connection view if calliope is connected"), for: .normal)
		case .evaluateMode:
			self.connectButton.isEnabled = false
			self.connectButton.setTitle(NSLocalizedString("Testing Calliope...", comment: "button label in connection view for calliope mode evaluation"), for: .normal)
		case .playgroundReady:
			self.connectButton.isEnabled = false
			self.connectButton.setTitle(NSLocalizedString("Ready to play!", comment: "button label in connection view if calliope is connected and in correct mode"), for: .normal)
		case .notPlaygroundReady:
			self.connectButton.isEnabled = true
			self.connectButton.setTitle(NSLocalizedString("Wrong program. retry?", comment: "button label in connection view if calliope is connected and not correct mode"), for: .normal)
		}
	}

	private func animate(expand: Bool, completion: () -> () = {}) {

		let size: CGFloat
		let completion: (_ completed: Bool) -> ()
		if expand {
			size = expandedSize
			completion = { _ in
				self.collapseButton.isSelected = true
				self.connector.startCalliopeDiscovery()
			}
		} else {
			size = collapsedSize
			completion = { _ in
				self.collapseButton.isSelected = false
				self.connector.stopCalliopeDiscovery()
			}
		}

		UIView.animate(withDuration: TimeInterval(0.5), animations: {
			self.collapseHeightConstraint.constant = size
			self.collapseWidthConstraint.constant = size
			self.view.superview?.layoutIfNeeded()
		}, completion: completion)
	}

	private func animate(connected: Bool, completion: @escaping () -> () = {}) {
		if connected {
			UIView.animate(withDuration: TimeInterval(0.2), animations: {
				//show that calliope is connected
				self.collapseButton.backgroundColor = UIColor.green
			}, completion: { _ in completion() })
		} else {
			UIView.animate(withDuration: TimeInterval(0.2), animations: {
				//show that no calliope is connected
				self.collapseButton.backgroundColor = UIColor.red
			}, completion: { _ in completion() })
		}
	}

	// MARK: LiveViewMessageHandler

	/*
	public func liveViewMessageConnectionOpened() {
	// Implement this method to be notified when the live view message connection is opened.
	// The connection will be opened when the process running Contents.swift starts running and listening for messages.
	}
	*/

	/*
	public func liveViewMessageConnectionClosed() {
	// Implement this method to be notified when the live view message connection is closed.
	// The connection will be closed when the process running Contents.swift exits and is no longer listening for messages.
	// This happens when the user's code naturally finishes running, if the user presses Stop, or if there is a crash.
	}
	*/

	public func receive(_ message: PlaygroundValue) {
		// Implement this method to receive messages sent from the process running Contents.swift.
		// This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
		// Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
	}

}
