//
//  ConnectionButton.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 22.12.18.
//

import UIKit

public class ConnectionButton: UIButton {

	public enum ConnectionState {
		case initialized
		case waitingForBluetooth
		case searching
		case notFoundRetry
		case readyToConnect
		case connecting
		case testingMode
		case readyToPlay
		case wrongProgram
	}

	public var connectionState: ConnectionState = .initialized {
		didSet {
			switch connectionState {
			case .initialized:
				isEnabled = true
				setBackgroundImage(nil, for: .normal)
				setTitle(nil, for: .normal)
				setImage(#imageLiteral(resourceName: "mini_refresh"), for: .normal)
			case .waitingForBluetooth:
				isEnabled = false
				setBackgroundImage(nil, for: .normal)
				setTitle(nil, for: .normal)
				setImage(#imageLiteral(resourceName: "bluetooth_disabled"), for: .normal)
			case .searching:
				isEnabled = false
				setBackgroundImage(nil, for: .normal)
				setTitle(nil, for: .normal)
				setImage(#imageLiteral(resourceName: "mini_mini"), for: .normal)
			//TODO: animation
			case .notFoundRetry:
				isEnabled = true
				setBackgroundImage(#imageLiteral(resourceName: "mini_button_red"), for: .normal)
				setTitle(nil, for: .normal)
				setImage(#imageLiteral(resourceName: "mini_refresh"), for: .normal)
			case .readyToConnect:
				isEnabled = true
				setBackgroundImage(#imageLiteral(resourceName: "mini_button_green"), for: .normal)
				setTitle(nil, for: .normal)
				setImage(#imageLiteral(resourceName: "mini_pfeil"), for: .normal)
			case .connecting:
				isEnabled = false
				setBackgroundImage(nil, for: .normal)
				setTitle(nil, for: .normal)
				setImage(#imageLiteral(resourceName: "connect"), for: .normal)
			case .testingMode:
				isEnabled = false
				setBackgroundImage(nil, for: .normal)
				setTitle("2", for: .normal)
				setImage(#imageLiteral(resourceName: "mini_test_mode"), for: .normal)
			//TODO: number animation
			case .readyToPlay:
				isEnabled = false
				setBackgroundImage(nil, for: .normal)
				setTitle(nil, for: .normal)
				setImage(#imageLiteral(resourceName: "mini_figur"), for: .normal)
			case .wrongProgram:
				isEnabled = true
				setBackgroundImage(#imageLiteral(resourceName: "mini_button_red"), for: .normal)
				setAttributedTitle(NSAttributedString(string: "5", attributes: [.strikethroughStyle: NSUnderlineStyle.single]), for: .normal)
				setImage(#imageLiteral(resourceName: "mini_refresh"), for: .normal)
			}
		}
	}

}
