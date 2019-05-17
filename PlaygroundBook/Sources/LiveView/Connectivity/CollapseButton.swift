//
//  CollapseButton.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 23.12.18.
//

import UIKit

public class CollapseButton: UIButton {

	public enum ConnectionState {
		case disconnected
		case connected
	}

	public enum ExpansionState {
		case open
		case closed
	}

	public var connectionState: ConnectionState = .disconnected {
		didSet {
			determineAppearance()
		}
	}

	public var expansionState: ExpansionState = .closed {
		didSet {
			determineAppearance()
		}
	}

	private func determineAppearance() {
		if self.expansionState == .open {
			self.setBackgroundImage(nil, for: .normal)
			self.setImage(#imageLiteral(resourceName: "mini_close"), for: .normal)
		} else {
			switch self.connectionState {
			case .disconnected:
				self.setBackgroundImage(#imageLiteral(resourceName: "mini_button_circle_red"), for: .normal)
				self.setImage(#imageLiteral(resourceName: "mini_mini"), for: .normal)
			case .connected:
				self.setBackgroundImage(#imageLiteral(resourceName: "mini_button_circle_green"), for: .normal)
				self.setImage(#imageLiteral(resourceName: "mini_mini"), for: .normal)
			}
		}
	}
}
