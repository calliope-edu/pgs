import UIKit

public class UIStackView_Dashboard: UIStackView {
    
    lazy var input_display:UIView_DashboardItem = UIView_DashboardItem(type: .Display, ani: Dashboard_DisplayAnimation())
    lazy var input_rgb:UIView_DashboardItem = UIView_DashboardItem(type: .RGB, ani: Dashboard_RGBAnimation())
    lazy var input_sound:UIView_DashboardItem = UIView_DashboardItem(type: .Sound, ani: Dashboard_SoundAnimation())
    
    lazy var output_buttonA:UIView_DashboardItem = UIView_DashboardItem(type: .ButtonA, ani: Dashboard_ButtonAAnimation())
    lazy var output_buttonB:UIView_DashboardItem = UIView_DashboardItem(type: .ButtonB, ani: Dashboard_ButtonBAnimation())
    lazy var output_pin:UIView_DashboardItem = UIView_DashboardItem(type: .Pin, ani: Dashboard_PinAnimation())
    lazy var output_shake:UIView_DashboardItem = UIView_DashboardItem(type: .Shake, ani: Dashboard_ShakeAnimation())
    
    lazy var sensor_thermometer:UIView_DashboardItem = UIView_DashboardItem(type: .Thermometer, ani: Dashboard_ThermometerAnimation())
    lazy var sensor_noise:UIView_DashboardItem = UIView_DashboardItem(type: .Noise, ani: Dashboard_NoiseAnimation())
    lazy var sensor_brightness:UIView_DashboardItem = UIView_DashboardItem(type: .Brightness, ani: Dashboard_BrightnessAnimation())
    
    lazy var input_stack:UIStackView =  self.stackview(.horizontal)
    lazy var output_stack:UIStackView = self.stackview(.horizontal)
    lazy var button_stack:UIStackView = self.stackview(.vertical)
    lazy var sensor_stack:UIStackView = self.stackview(.horizontal)
    lazy var inout_stack:UIStackView = self.stackview(.vertical)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ output:[DashboardItemGroup.Output], _ input:[DashboardItemGroup.Input], _ sensor:[DashboardItemGroup.Sensor]) {
        self.init(frame:CGRect())
        
        if !output.isEmpty {
            for type in output {
                let item:UIView_DashboardItem = {
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
            inout_stack.addArrangedSubview(output_stack)
        }
        
        if !input.isEmpty {
            for type in input {
                let item:UIView_DashboardItem = {
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
            inout_stack.addArrangedSubview(input_stack)
        }
        
        if !inout_stack.arrangedSubviews.isEmpty {
            addArrangedSubview(inout_stack)
        }
        
        if !sensor.isEmpty {
            for type in sensor {
                let item:UIView_DashboardItem = {
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
                inout_stack.axis = .horizontal
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
                inout_stack.axis = .vertical
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

//MARK: - ping
extension UIStackView_Dashboard {
    func ping(){
        
    }
}

//MARK: - helper
extension UIStackView_Dashboard {
	func stackview(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        let _stack = UIStackView(frame: self.bounds)
        _stack.axis = axis
        _stack.distribution = .fillEqually
        _stack.alignment = .fill
        _stack.spacing = 0
        _stack.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _stack.translatesAutoresizingMaskIntoConstraints = false
        _stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        _stack.isLayoutMarginsRelativeArrangement = true
        return _stack
    }
    
	func axis(from: UIView) -> NSLayoutConstraint.Axis {
        return (from.bounds.size.width > from.bounds.size.height) ? .horizontal : .vertical
    }
    
    func howMany() -> Int {
        return Int(arc4random_uniform(3)+1)
    }
}


