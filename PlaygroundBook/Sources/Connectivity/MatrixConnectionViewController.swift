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
	@IBOutlet var collapseButton: UIButton!


	@IBOutlet var collapseWidthConstraint: NSLayoutConstraint!
	@IBOutlet var collapseHeightConstraint: NSLayoutConstraint!

	@IBOutlet var matrixView: MatrixView!

	@IBOutlet var connectButton: UIButton!

	@IBAction func toggleOpen(_ sender: Any) {
		if collapseButton.isSelected {
			UIView.animate(withDuration: TimeInterval(0.5), animations: {
				self.collapseHeightConstraint.constant = 40
				self.collapseWidthConstraint.constant = 40
				self.view.superview?.layoutIfNeeded()
			}) { _ in
				self.collapseButton.isSelected = false
			}
		} else {
			UIView.animate(withDuration: TimeInterval(0.5), animations: {
				self.collapseHeightConstraint.constant = 500
				self.collapseWidthConstraint.constant = 500
				self.view.superview?.layoutIfNeeded()
			}) { _ in
				self.collapseButton.isSelected = true
			}
		}
	}

	@IBAction func connect(_ sender: Any) {
		//TODO: implement connection logic
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		//TODO: set up ble search and update connect button label according to state changes
		//TODO: set up reactions to matrix image drawing
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
