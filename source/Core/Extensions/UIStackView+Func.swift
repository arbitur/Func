//
//  UIStackView+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





@available(iOS 9.0, *)
public extension UIStackView {
	
	func add(arrangedView view: UIView?) {
		guard let view = view else {
			return
		}
		self.addArrangedSubview(view)
	}
	
	func add(arrangedViews views: UIView? ...) {
		for view in views {
			self.add(arrangedView: view)
		}
	}
	
	convenience init(axis: UILayoutConstraintAxis) {
		self.init(frame: CGRect.zero)
		self.axis = axis
	}
}
