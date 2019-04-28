//
//  MatrixConnectionViewController.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 14.12.18.
//

import UIKit
import PlaygroundSupport

class MatrixConnectionViewController<C: CalliopeBLEDevice>: UIViewController {

	/// button to toggle whether connection view is open or not
	@IBOutlet var collapseButton: CollapseButton!

	/// the view which handles the collapsing
	@IBOutlet weak var zoomView: UIView!

	/// the matrix in which to draw the calliope name pattern
	@IBOutlet var matrixView: MatrixView!

	/// button to trigger the connection with the calliope
	@IBOutlet var connectButton: ConnectionButton!

	/// constraint to collapse view horizontally
	@IBOutlet var collapseWidthConstraint: NSLayoutConstraint!
	/// constraint to collapse view vertically
	@IBOutlet var collapseHeightConstraint: NSLayoutConstraint!

	private let collapsedWidth: CGFloat = 28
	private let collapsedHeight: CGFloat = 28
	private let expandedWidth: CGFloat = 275
	private let expandedHeight: CGFloat = 500

	private let queue = DispatchQueue(label: "bluetooth")

	private let connector = CalliopeBLEDiscovery<C>()

	public var calliopeWithCurrentMatrix: C? {
		return connector.discoveredCalliopes[Matrix.matrix2friendly(matrixView.matrix) ?? ""]
	}

	public var usageReadyCalliope: C? {
		guard let calliope = connector.connectedCalliope,
			calliope.state == .playgroundReady
			else { return nil }
		return calliope
	}

	@IBAction func toggleOpen(_ sender: Any) {
		if collapseButton.expansionState == .open {
			//button state open --> collapse!
			animate(expand: false)
		} else {
			//button state closed --> open!
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
		connectButton.imageView?.contentMode = .scaleAspectFit
		animate(expand: false)
	}

	public func animate(expand: Bool) {

		//do not animate anything if no change will happen
		guard expand && collapseButton.expansionState == .closed || collapseButton.expansionState == .open else { return }

		let animations: () -> ()
		let completion: (_ completed: Bool) -> ()

		if expand {
			self.zoomView.isHidden = false
			animations = {
				self.collapseHeightConstraint.constant = self.expandedHeight
				self.collapseWidthConstraint.constant = self.expandedWidth
				self.collapseButton.alpha = 0.0
			}
			completion = { _ in
				self.collapseButton.expansionState = .open
				self.collapseButton.alpha = 1.0
				if self.connector.state == .initialized {
					self.connector.startCalliopeDiscovery()
				}
			}
		} else {
			self.collapseButton.alpha = 0.0
			animations = {
				self.collapseHeightConstraint.constant = self.collapsedHeight
				self.collapseWidthConstraint.constant = self.collapsedWidth
				self.collapseButton.expansionState = .closed
				self.collapseButton.alpha = 1.0
				self.zoomView.alpha = 0.0
			}
			completion = { _ in
				self.collapseButton.alpha = 1.0
				self.zoomView.alpha = 1.0
				self.zoomView.isHidden = true
				self.connector.stopCalliopeDiscovery()
			}
		}

		UIView.animate(withDuration: TimeInterval(0.3), animations: {
			animations()
			self.view.superview?.layoutIfNeeded()
		}, completion: completion)
	}

	// MARK: calliope connection

	private var attemptReconnect = false
	private var reconnecting = false

	@IBAction func connect() {
		if self.connector.state == .initialized
			|| self.calliopeWithCurrentMatrix == nil && self.connector.state == .discoveredAll {
			connector.startCalliopeDiscovery()
		} else if let calliope = self.calliopeWithCurrentMatrix {
			if calliope.state == .discovered || calliope.state == .willReset {
				connector.stopCalliopeDiscovery()
				calliope.updateBlock = updateDiscoveryState
				LogNotify.log("Matrix view connecting to \(calliope)")
				connector.connectToCalliope(calliope)
			} else if calliope.state == .connected {
				calliope.evaluateMode()
			} else {
				LogNotify.log("Connect button of matrix view should not be enabled in this state (\(self.connector.state), \(String(describing: self.calliopeWithCurrentMatrix?.state)))")
			}
		} else {
			LogNotify.log("Connect button of matrix view should not be enabled in this state (\(self.connector.state), \(String(describing: self.calliopeWithCurrentMatrix?.state)))")
		}
	}

	private func updateDiscoveryState() {

		switch self.connector.state {
		case .initialized:
			matrixView.isUserInteractionEnabled = true
			connectButton.connectionState = .initialized
			self.collapseButton.connectionState = .disconnected
		case .discoveryWaitingForBluetooth:
			matrixView.isUserInteractionEnabled = true
			connectButton.connectionState = .waitingForBluetooth
			self.collapseButton.connectionState = .disconnected
		case .discovering, .discovered:
			if let calliope = self.calliopeWithCurrentMatrix {
				evaluateCalliopeState(calliope)
			} else {
				matrixView.isUserInteractionEnabled = true
				connectButton.connectionState = .searching
				self.collapseButton.connectionState = .disconnected
			}
		case .discoveredAll:
			if let matchingCalliope = calliopeWithCurrentMatrix {
				evaluateCalliopeState(matchingCalliope)
			} else {
				matrixView.isUserInteractionEnabled = true
				connectButton.connectionState = .notFoundRetry
				self.collapseButton.connectionState = .disconnected
			}
		case .connecting:
			matrixView.isUserInteractionEnabled = false
			attemptReconnect = false
			reconnecting = false
			connectButton.connectionState = .connecting
			self.collapseButton.connectionState = .connecting
		case .connected:
			if let connectedCalliope = connector.connectedCalliope, calliopeWithCurrentMatrix != connector.connectedCalliope {
				//set matrix in case of auto-reconnect, where we do not have corresponding matrix yet
				matrixView.matrix = Matrix.friendly2Matrix(Matrix.full2Friendly(fullName: connectedCalliope.peripheral.name!)!)
				connectedCalliope.updateBlock = updateDiscoveryState
			}
			evaluateCalliopeState(calliopeWithCurrentMatrix!)
		}
	}

	private func evaluateCalliopeState(_ calliope: C) {

		if calliope.state == .notPlaygroundReady || calliope.state == .discovered {
			self.collapseButton.connectionState = attemptReconnect || reconnecting ? .connecting : .disconnected
		} else if calliope.state == .playgroundReady {
			self.collapseButton.connectionState = .connected
		} else {
			self.collapseButton.connectionState = .connecting
		}

		if calliope.state == .discovered && attemptReconnect {
			//start reconnection attempt
			queue.asyncAfter(deadline: DispatchTime.now() + BluetoothConstants.restartDuration, execute: connect)
			reconnecting = true
			attemptReconnect = false
			return
		}

		switch calliope.state {
		case .discovered:
			matrixView.isUserInteractionEnabled = !reconnecting
			connectButton.connectionState = reconnecting ? .testingMode : .readyToConnect
		case .connected:
			reconnecting = false
			attemptReconnect = false
			matrixView.isUserInteractionEnabled = false
			connectButton.connectionState = .testingMode
		case .evaluateMode:
			matrixView.isUserInteractionEnabled = false
			connectButton.connectionState = .testingMode
		case .playgroundReady:
			matrixView.isUserInteractionEnabled = true
			connectButton.connectionState = .readyToPlay
		case .notPlaygroundReady:
			matrixView.isUserInteractionEnabled = true
			connectButton.connectionState = .wrongProgram
		case .willReset:
			matrixView.isUserInteractionEnabled = false
			attemptReconnect = true
			connectButton.connectionState = .testingMode
		}
	}
}

//MARK: calliope communications

extension MatrixConnectionViewController where C == ProgrammableCalliope {

	func uploadProgram(program: ProgramBuildResult) -> Worker<String>  {
		return Worker { [weak self] resolve in
			guard let queue = self?.queue else { return }
			guard let device = self?.usageReadyCalliope else {
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
