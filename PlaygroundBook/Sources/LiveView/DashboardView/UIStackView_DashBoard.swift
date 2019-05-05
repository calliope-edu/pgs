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
    lazy var sensor_stack: UIStackView = self.stackview(.horizontal)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ output: [DashboardItemType.Output], _ input: [DashboardItemType.Input], _ sensor: [DashboardItemType.Sensor]) {
        self.init(frame: CGRect())

		self.distribution = .fillProportionally
		self.alignment = .fill
		self.spacing = 0

        if !output.isEmpty {
            for type in output {
                let item: UIView_DashboardItem = {
                    switch type {
                    case .Display:
                        return input_display
                    case .RGB:
                        return input_rgb
                    case .Sound:
                        return input_sound
                    }
                }()
                output_stack.addArrangedSubview(item)
            }
			addArrangedSubview(output_stack)
        }
        
        if !input.isEmpty {
            for type in input {
                let item: UIView_DashboardItem = {
                    switch type {
                    case .ButtonA:
                        return output_buttonA
                    case .ButtonB:
                        return output_buttonB
                    case .Pin:
                        return output_pin
                    case .Shake:
                        return output_shake
                    }
                }()
                if item.type == .ButtonA || item.type == .ButtonB {
                    button_stack.addArrangedSubview(item)
                } else {
                    input_stack.addArrangedSubview(item)
                }
            }
            if !button_stack.arrangedSubviews.isEmpty {
                input_stack.insertArrangedSubview(button_stack, at: 0)
            }
			addArrangedSubview(input_stack)
        }
        
        if !sensor.isEmpty {
            for type in sensor {
                let item: UIView_DashboardItem = {
                    switch type {
                    case .Noise:
                        return sensor_noise
                    case .Brightness:
                        return sensor_brightness
                    case .Thermometer:
                        return sensor_thermometer
                    }
                }()
                sensor_stack.addArrangedSubview(item)
            }
            addArrangedSubview(sensor_stack)
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
            switch axis {
            case .horizontal:
                output_stack.axis = .vertical
                input_stack.axis = .vertical
                sensor_stack.axis = .vertical

                if sensor_stack.arrangedSubviews.isEmpty {
                    button_stack.axis = .horizontal
                }
                if input_stack.arrangedSubviews.isEmpty && sensor_stack.arrangedSubviews.isEmpty {
                    output_stack.axis = .horizontal
                }
                if output_stack.arrangedSubviews.isEmpty && sensor_stack.arrangedSubviews.isEmpty {
                    input_stack.axis = .horizontal
                }
                if input_stack.arrangedSubviews.isEmpty && output_stack.arrangedSubviews.isEmpty {
                    sensor_stack.axis = .horizontal
                }
            case .vertical:
                output_stack.axis = .horizontal
                input_stack.axis = .horizontal
                sensor_stack.axis = .horizontal
                button_stack.axis = .vertical
                if input_stack.arrangedSubviews.isEmpty && sensor_stack.arrangedSubviews.isEmpty {
                    output_stack.axis = .vertical
                }
                if output_stack.arrangedSubviews.isEmpty && sensor_stack.arrangedSubviews.isEmpty {
                    input_stack.axis = .vertical
                }
                if input_stack.arrangedSubviews.isEmpty && output_stack.arrangedSubviews.isEmpty {
                    sensor_stack.axis = .vertical
                }
            }
        }
    }
}

//MARK: - helper
extension UIStackView_Dashboard {
	func stackview(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView(frame: self.bounds)
        stackView.axis = axis
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }
    
	func axis(from: UIView) -> NSLayoutConstraint.Axis {
        return (from.bounds.size.width > from.bounds.size.height) ? .horizontal : .vertical
    }
    
    func howMany() -> Int {
        return Int(arc4random_uniform(3)+1)
    }
}


