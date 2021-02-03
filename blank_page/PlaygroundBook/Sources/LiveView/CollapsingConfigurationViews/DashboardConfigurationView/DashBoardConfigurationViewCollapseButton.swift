//
//  DashBoardConfigurationViewCollapseButton.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 04.05.19.
//

import UIKit

class DashBoardConfigurationViewCollapseButton: UIButton, CollapseButtonProtocol {

	public var expansionState: ExpansionState = .open {
		didSet {
			if oldValue != expansionState {
				determineAppearance()
			}
		}
	}

	private func determineAppearance() {
		if self.expansionState == .open {
			self.setImage(UIImage(named: "liveviewselect/close"), for: .normal)
		} else {
			self.setImage(UIImage(named: "liveviewselect/icon"), for: .normal)
		}
	}

}
