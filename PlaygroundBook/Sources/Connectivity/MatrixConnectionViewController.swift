//
//  MatrixConnectionViewController.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 14.12.18.
//

import UIKit
import PlaygroundSupport

@objc
public class MatrixConnectionViewController: UIViewController
{
	private let collapsedWidth: CGFloat = 28
	private let collapsedHeight: CGFloat = 28
	private let expandedWidth: CGFloat = 270
	private let expandedHeight: CGFloat = 500

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

	///TODO: review if these asynchronized do any harm
	private let queue = DispatchQueue(label: "bluetooth")

	private let connector = CalliopeBLEDiscovery()
	public var calliopeWithCurrentMatrix: CalliopeBLEDevice? {
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

	override public func viewDidLoad() {
		super.viewDidLoad()
		connector.updateBlock = updateDiscoveryState
		matrixView.updateBlock = {
			//matrix has been changed manually, this always triggers a disconnect
			self.connector.disconnectFromCalliope()
			self.updateDiscoveryState()
		}
		animate(expand: false)
	}

	public func animate(expand: Bool, completion: () -> () = {}) {

		let width: CGFloat
		let height: CGFloat
		let completion: (_ completed: Bool) -> ()
		if expand {
			width = expandedWidth
			height = expandedHeight
			completion = { _ in
				self.collapseButton.isSelected = true
				if self.connector.state != .connected {
					self.connector.startCalliopeDiscovery()
				}
			}
		} else {
			width = collapsedWidth
			height = collapsedHeight
			completion = { _ in
				self.collapseButton.isSelected = false
				self.connector.stopCalliopeDiscovery()
			}
		}

		UIView.animate(withDuration: TimeInterval(0.5), animations: {
			self.collapseHeightConstraint.constant = height
			self.collapseWidthConstraint.constant = width
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
}

// MARK: calliope connection

public extension MatrixConnectionViewController {
	@IBAction func connect(_ sender: Any) {
		//TODO: implement connection logic
		if self.connector.state == .initialized
			|| self.calliopeWithCurrentMatrix == nil && self.connector.state == .discoveredAll {
			connector.startCalliopeDiscovery()
		} else if let calliope = self.calliopeWithCurrentMatrix, calliope.state == .discovered {
			connector.stopCalliopeDiscovery()
			calliope.updateBlock = updateDiscoveryState
			connector.connectToCalliope(calliope)
		} else {
			fatalError("connect button must not be enabled in this state")
		}
	}

	private func updateDiscoveryState() {

		switch self.connector.state {
		case .initialized:
			matrixView.isUserInteractionEnabled = true
			connectButton.isEnabled = true
			connectButton.setTitle("connect.startSearch".localized, for: .normal)
		case .discoveryStarted:
			matrixView.isUserInteractionEnabled = true
			connectButton.isEnabled = false
			connectButton.setTitle("connect.waitForBluetooth".localized, for: .normal)
		case .discovering, .discovered:
			if let calliope = self.calliopeWithCurrentMatrix {
				evaluateCalliopeState(calliope)
			} else {
				matrixView.isUserInteractionEnabled = true
				connectButton.isEnabled = false
				connectButton.setTitle("connect.searching".localized, for: .normal)
			}
		case .discoveredAll:
			animate(connected: false)
			matrixView.isUserInteractionEnabled = true
			connectButton.isEnabled = true
			connectButton.setTitle("connect.notFoundRetry".localized, for: .normal)
		case .connecting:
			matrixView.isUserInteractionEnabled = false
			connectButton.isEnabled = false
			connectButton.setTitle("connect.connecting".localized, for: .normal)
		case .connected:
			if let connectedCalliope = connector.connectedCalliope {
				//set matrix in case of auto-reconnect, where we do not have corresponding matrix yet
				matrixView.matrix = Matrix.friendly2Matrix(Matrix.full2Friendly(fullName: connectedCalliope.peripheral.name!)!)
				connectedCalliope.updateBlock = updateDiscoveryState
			}
			evaluateCalliopeState(calliopeWithCurrentMatrix!)
		}
	}

	private func evaluateCalliopeState(_ calliope: CalliopeBLEDevice) {

		if calliope.state == .playgroundReady {
			animate(connected: true)
		} else {
			animate(connected: false)
		}

		switch calliope.state {
		case .discovered:
			matrixView.isUserInteractionEnabled = true
			connectButton.isEnabled = true
			connectButton.setTitle("connect.connect".localized, for: .normal)
		case .connected:
			matrixView.isUserInteractionEnabled = false
			connectButton.isEnabled = false
			connectButton.setTitle("connect.connected".localized, for: .normal)
		case .evaluateMode:
			matrixView.isUserInteractionEnabled = false
			connectButton.isEnabled = false
			connectButton.setTitle("connect.testMode".localized, for: .normal)
		case .playgroundReady:
			matrixView.isUserInteractionEnabled = true
			connectButton.isEnabled = false
			connectButton.setTitle("connect.readyToPlay".localized, for: .normal)
		case .notPlaygroundReady:
			matrixView.isUserInteractionEnabled = true
			connectButton.isEnabled = false
			connectButton.setTitle("connect.wrongProgram".localized, for: .normal)
		}
	}
}

//MARK: calliope communications

public extension MatrixConnectionViewController {

	public func uploadProgram(program: ProgramBuildResult) -> Worker<String>  {
		return Worker { [weak self] resolve in
			guard let queue = self?.queue else { LogNotify.log("no object to work on...)"); return }
			guard let device = self?.connector.connectedCalliope, device.state == .playgroundReady else {
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


//MARK: playground specifics

extension MatrixConnectionViewController: PlaygroundLiveViewSafeAreaContainer {

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