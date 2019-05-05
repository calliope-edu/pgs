//
//  DashBoardConfigurationViewController.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 04.05.19.
//

import UIKit

class DashBoardConfigurationViewController: UIViewController, CollapsingViewControllerProtocol {

	@IBOutlet var zoomView: UIView!
	@IBOutlet var collapseButton: DashBoardConfigurationViewCollapseButton!
	var collapseButtonView: (CollapseButtonProtocol & UIView)! {
		return collapseButton
	}

	@IBOutlet var collapseHeightConstraint: NSLayoutConstraint!
	@IBOutlet var collapseWidthConstraint: NSLayoutConstraint!

	let collapsedWidth: CGFloat = 50
	let collapsedHeight: CGFloat = 50
	let expandedWidth: CGFloat = 274
	let expandedHeight: CGFloat = 450

	@IBOutlet weak var displayToggleButton: UIButton!
	@IBOutlet weak var rgbToggleButton: UIButton!
	@IBOutlet weak var soundToggleButton: UIButton!
	@IBOutlet weak var abToggleButton: UIButton!
	@IBOutlet weak var pinToggleButton: UIButton!
	@IBOutlet weak var shakeToggleButton: UIButton!
	@IBOutlet weak var temperatureToggleButton: UIButton!
	@IBOutlet weak var brightnessToggleButton: UIButton!
	@IBOutlet weak var noiseToggleButton: UIButton!

	var selectionCallback: (_ items: [DashboardItemType]) -> () = {_ in }

	public var selectedViews = Dictionary<DashboardItemType, Bool>(uniqueKeysWithValues: DashboardItemType.types.map {($0, true)}) {
		didSet {
			reconfigureSelectedButtons()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		animate(expand: false)
		reconfigureSelectedButtons()
    }

	func reconfigureSelectedButtons() {
		for (type, selected) in selectedViews {
			self.button(for: type).isSelected = selected
		}
	}

	func additionalAnimationCompletions(expand: Bool) {}

	@IBAction func toggleOpen(_ sender: Any) {
		toggleOpen()
	}


	@IBAction func selectDashboardItem(_ sender: UIButton) {
		for item in type(for: sender) {
			selectedViews[item] = !(selectedViews[item] ?? true)
		}
	}

	@IBAction func confirmSelection(_ sender: Any) {
		let types = selectedViews.filter({$0.1}).map({$0.0})
		selectionCallback(types)
	}

	func button(for type: DashboardItemType) -> UIButton {
		switch type {
		case .Display:
			return displayToggleButton
		case .ButtonA:
			return abToggleButton
		case .ButtonB:
			return abToggleButton
		case .ButtonAB:
			return abToggleButton
		case .RGB:
			return rgbToggleButton
		case .Sound:
			return soundToggleButton
		case .Pin:
			return pinToggleButton
		case .Shake:
			return shakeToggleButton
		case .Thermometer:
			return temperatureToggleButton
		case .Noise:
			return noiseToggleButton
		case .Brightness:
			return brightnessToggleButton
		default:
			return displayToggleButton
		}
	}

	func type(for button: UIButton) -> [DashboardItemType] {
		switch button {
		case displayToggleButton:
			return [.Display]
		case abToggleButton:
			return [.ButtonA, .ButtonB, .ButtonAB]
		case rgbToggleButton:
			return [.RGB]
		case soundToggleButton:
			return [.Sound]
		case pinToggleButton:
			return [.Pin]
		case shakeToggleButton:
			return [.Shake]
		case temperatureToggleButton:
			return [.Thermometer]
		case noiseToggleButton:
			return [.Noise]
		case brightnessToggleButton:
			return [.Brightness]
		default:
			return []
		}
	}
}
