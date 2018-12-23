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

	override init(frame: CGRect) {
		super.init(frame: frame)
		initialize()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialize()
	}

	public var connectionState: ConnectionState = .disconnected {
		didSet {
			switch connectionState {
			case .disconnected:
				setBackgroundImage(#imageLiteral(resourceName: "mini_button_circle_red"), for: .normal)
				setImage(#imageLiteral(resourceName: "mini_mini"), for: .normal)
			case .connected:
				setBackgroundImage(#imageLiteral(resourceName: "mini_button_circle_green"), for: .normal)
				setImage(#imageLiteral(resourceName: "mini_mini"), for: .normal)
			}
		}
	}

	private func initialize() {
		setBackgroundImage(nil, for: .selected)
		setImage(UIImage(named: "mini_close"), for: .selected)
	}

}
