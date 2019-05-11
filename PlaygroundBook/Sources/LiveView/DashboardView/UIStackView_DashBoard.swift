import UIKit

public class UIStackView_Dashboard: UIStackView {
    
    lazy var input_display: UIView_DashboardItem = UIView_DashboardItem(type: .Display, ani: Dashboard_DisplayAnimation())
    lazy var input_rgb: UIView_DashboardItem = UIView_DashboardItem(type: .RGB, ani: Dashboard_RGBAnimation())
    lazy var input_sound: UIView_DashboardItem = UIView_DashboardItem(type: .Sound, ani: Dashboard_SoundAnimation())
    
    lazy var output_buttonA: UIView_DashboardItem = UIView_DashboardItem(type: .ButtonA, ani: Dashboard_ButtonAAnimation())
    lazy var output_buttonB: UIView_DashboardItem = UIView_DashboardItem(type: .ButtonB, ani: Dashboard_ButtonBAnimation())
    lazy var output_pin: UIView_DashboardItem = UIView_DashboardItem(type: .Pin, ani: Dashboard_PinAnimation())
    lazy var output_shake: UIView_DashboardItem = UIView_DashboardItem(type: .Shake, ani: Dashboard_ShakeAnimation())
    
    lazy var sensor_thermometer: UIView_DashboardItem = UIView_DashboardItem(type: .Thermometer, ani: Dashboard_ThermometerAnimation())
    lazy var sensor_noise: UIView_DashboardItem = UIView_DashboardItem(type: .Noise, ani: Dashboard_NoiseAnimation())
    lazy var sensor_brightness: UIView_DashboardItem = UIView_DashboardItem(type: .Brightness, ani: Dashboard_BrightnessAnimation())
    
    lazy var input_stack: UIStackView =  self.stackview(.horizontal)
    lazy var output_stack: UIStackView = self.stackview(.horizontal)
    lazy var button_stack: UIStackView = self.stackview(.vertical)
	lazy var pin_shake_stack: UIStackView = self.stackview(.horizontal)
    lazy var sensor_stack: UIStackView = self.stackview(.horizontal)

	var output: [DashboardItemType.Output]
	var input: [DashboardItemType.Input]
	var sensor: [DashboardItemType.Sensor]


	override convenience init(frame: CGRect) {
        self.init(DashboardItemType.Output.allCases, DashboardItemType.Input.allCases, DashboardItemType.Sensor.allCases)
    }
    
    init(_ output: [DashboardItemType.Output], _ input: [DashboardItemType.Input], _ sensor: [DashboardItemType.Sensor]) {

		self.input = input
		self.output = output
		self.sensor = sensor

        super.init(frame: CGRect())

		self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		self.distribution = .fillProportionally
		self.alignment = .fill
		self.spacing = 0

		if !output.isEmpty {
			let outputDashboardElement = { (type: DashboardItemType.Output) -> UIView_DashboardItem in
				switch type {
				case .Display:
					return self.input_display
				case .RGB:
					return self.input_rgb
				case .Sound:
					return self.input_sound
				}
			}
			if output.count > 1 {
				for type in output {
					let item: UIView_DashboardItem = outputDashboardElement(type)
					output_stack.addArrangedSubview(item)
				}
				addArrangedSubview(output_stack)
			} else {
				addArrangedSubview(outputDashboardElement(output[0]))
			}
		}
        
        if !input.isEmpty {
			let inputDashboardElement = { (type: DashboardItemType.Input) -> UIView_DashboardItem in
				switch type {
				case .ButtonA:
					return self.output_buttonA
				case .ButtonB:
					return self.output_buttonB
				case .Pin:
					return self.output_pin
				case .Shake:
					return self.output_shake
				}
			}
			if input.count > 1 {
				var buttons: [UIView_DashboardItem] = []
				var pinShake: [UIView_DashboardItem] = []
				for type in input {
					let item: UIView_DashboardItem = inputDashboardElement(type)
					if item.type == .ButtonA || item.type == .ButtonB {
						buttons.append(item)
					} else {
						pinShake.append(item)
					}
				}
				if buttons.count == 1 {
					input_stack.addArrangedSubview(buttons[0])
				} else if buttons.count > 1 {
					for item in buttons {
						button_stack.addArrangedSubview(item)
					}
					input_stack.addArrangedSubview(button_stack)
				}

				if pinShake.count == 1 {
					input_stack.addArrangedSubview(pinShake[0])
				} else {
					for item in pinShake {
						pin_shake_stack.addArrangedSubview(item)
					}
					input_stack.addArrangedSubview(pin_shake_stack)
				}

				input_stack.distribution = .fillProportionally
				addArrangedSubview(input_stack)

			} else {
				addArrangedSubview(inputDashboardElement(input[0]))
			}
		}

		if !sensor.isEmpty {
			let sensorDashboardElement = { (type: DashboardItemType.Sensor) -> UIView_DashboardItem in
				switch type {
				case .Noise:
					return self.sensor_noise
				case .Brightness:
					return self.sensor_brightness
				case .Thermometer:
					return self.sensor_thermometer
				}
			}
			if sensor.count > 1 {
				for type in sensor {
					let item: UIView_DashboardItem = sensorDashboardElement(type)
					sensor_stack.addArrangedSubview(item)
				}
				addArrangedSubview(sensor_stack)
			} else {
				addArrangedSubview(sensorDashboardElement(sensor[0]))
			}
		}
	}
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if let view = superview {
            self.axis = axis(from: view)
        }
    }
    
}

//MARK: - layout sub-stacks axis
extension UIStackView_Dashboard {
	override public var axis: NSLayoutConstraint.Axis {
		didSet {
			let numSlots = (input.isEmpty ? 0 : 1) + (output.isEmpty ? 0 : 1) + (sensor.isEmpty ? 0 : 1)
			layoutOutputs(axis, axis == .vertical ? .horizontal : .vertical, numSlots)
			layoutInputs(axis, axis == .vertical ? .horizontal : .vertical, numSlots)
			layoutSensors(axis, axis == .vertical ? .horizontal : .vertical, numSlots)
		}
	}

	func layoutOutputs(_ mainAxis: NSLayoutConstraint.Axis, _ otherAxis: NSLayoutConstraint.Axis, _ numSlotsOnMainAxis: Int) {
		guard output.count > 1 else { return }
		if numSlotsOnMainAxis == 1 {
			output_stack.axis = mainAxis
		} else {
			output_stack.axis = otherAxis
		}
	}

	func layoutInputs(_ mainAxis: NSLayoutConstraint.Axis, _ otherAxis: NSLayoutConstraint.Axis, _ numSlotsOnMainAxis: Int) {
		guard input.count > 1 else { return }
		let hasButton = input.contains(.ButtonA) || input.contains(.ButtonB)
		let hasButtonStack = input.contains(.ButtonA) && input.contains(.ButtonB)
		let hasPinOrShake = input.contains(.Pin) || input.contains(.Shake)
		let hasPinShakeStack = input.contains(.Pin) && input.contains(.Shake)

		if numSlotsOnMainAxis == 1 {
			input_stack.axis = mainAxis
			if hasButtonStack {
				button_stack.axis = mainAxis
			}
			if hasPinShakeStack {
				pin_shake_stack.axis = mainAxis
			}
		} else if numSlotsOnMainAxis == 2 {
			input_stack.distribution = .fillProportionally
			input_stack.axis = otherAxis
			if hasButtonStack {
				button_stack.axis = hasPinOrShake ? mainAxis : otherAxis
			}
			if hasPinShakeStack {
				pin_shake_stack.axis = hasButton ? mainAxis : otherAxis
			}
		} else {
			input_stack.distribution = .fillProportionally
			input_stack.axis = otherAxis
			if hasButtonStack {
				button_stack.axis = hasPinShakeStack ? .vertical : otherAxis
			}
			if hasPinShakeStack {
				pin_shake_stack.axis = otherAxis
			}
		}
	}

	func layoutSensors(_ mainAxis: NSLayoutConstraint.Axis, _ otherAxis: NSLayoutConstraint.Axis, _ numSlotsOnMainAxis: Int) {
		guard sensor.count > 1 else { return }
		if numSlotsOnMainAxis == 1 {
			sensor_stack.axis = mainAxis
		} else {
			sensor_stack.axis = otherAxis
		}
	}
}

//MARK: - helper
extension UIStackView_Dashboard {
	func stackview(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView(frame: self.bounds)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		stackView.isLayoutMarginsRelativeArrangement = true

        stackView.axis = axis
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        return stackView
    }
    
	func axis(from: UIView) -> NSLayoutConstraint.Axis {
        return (from.bounds.size.width > from.bounds.size.height) ? .horizontal : .vertical
    }
}


