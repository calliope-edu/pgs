//
//  LayoutHelper.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 23.02.19.
//

import UIKit

struct LayoutHelper {
	static let symbolInsetByPercentage:CGFloat = 0.75

	static func iconImage(icon:UIImage?, color:UIColor) -> UIImage? {
		let size = CGSize(width: 50.0, height: 50.0)
		let inner = CGSize(width: 40.0, height: 40.0)

		UIGraphicsBeginImageContextWithOptions(size, false, 0)

		//        UIColor.gray.setFill()
		//        UIRectFill(CGRect(x:0, y:0, width:size.width, height:size.height))

		let oval = UIBezierPath(roundedRect: CGRect(
			x: 0,
			y: 0,
			width: size.width,
			height: size.height
		), cornerRadius: size.width*0.5)

		color.setFill()
		oval.fill()

		if let img = icon {
			img.draw(in: CGRect(x: 5.0, y: 5.0, width: inner.width, height: inner.height) )
		}

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image
	}

	static func animationLabel(in view:UIView, center:Bool = true) -> UILabel {
		let label = UILabel()
		label.font = UIFont(name: "Menlo", size: 32.0)
		label.textColor = .white
		label.textAlignment = .center
		label.adjustsFontSizeToFitWidth = true
		label.numberOfLines = 0
		view.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		if center {
			label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
			label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		}
		label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
		label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.22).isActive = true
		return label
	}

	static func buttonLabel(in view:UIView) -> UILabel {
		let label = UILabel()
		label.font = UIFont(name: "AmericanTypewriter-SemiBold", size: 42.0)
		label.textColor = .white
		label.textAlignment = .center
		label.adjustsFontSizeToFitWidth = true
		label.numberOfLines = 0
		view.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
}
