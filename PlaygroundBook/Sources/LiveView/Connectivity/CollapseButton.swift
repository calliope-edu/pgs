//
//  CollapseButton.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 23.12.18.
//

import UIKit

class CollapseButton: UIButton {

	public enum ConnectionState {
		case disconnected
		case connecting
		case connected
	}

	public enum ExpansionState {
		case open
		case closed
	}

	public var connectionState: ConnectionState = .disconnected {
		didSet {
			if oldValue != connectionState {
				determineAppearance(smooth: true)
			}
		}
	}

	public var expansionState: ExpansionState = .open {
		didSet {
			if oldValue != expansionState {
				determineAppearance(smooth: false)
			}
		}
	}

	private func determineAppearance(smooth: Bool) {
		if self.expansionState == .open {
			self.setImages(smooth, nil, #imageLiteral(resourceName: "mini_close"), for: .normal)
		} else {
			switch self.connectionState {
			case .disconnected:
				self.setImages(smooth, #imageLiteral(resourceName: "mini_button_circle_red"), #imageLiteral(resourceName: "mini_mini"), for: .normal)
			case .connecting:
				self.setImages(smooth, #imageLiteral(resourceName: "mini_button_circle_red"), #imageLiteral(resourceName: "connect"), for: .normal)
			case .connected:
				self.setImages(smooth, #imageLiteral(resourceName: "mini_button_circle_green"), #imageLiteral(resourceName: "mini_mini"), for: .normal)
			}
		}
	}

	private func setImages(_ smooth: Bool, _ backgroundImage: UIImage?, _ foregroundImage: UIImage?, for state: UIControl.State) {

		let animations = {
			self.setBackgroundImage(backgroundImage, for: state)
			self.setImage(foregroundImage, for: state)
		}

		if smooth {
		UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve, .allowAnimatedContent, .curveLinear], animations: animations, completion: nil)
		} else {
			animations()
		}
	}
}
