//
//  UIButton+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 24/Feb/17.
//
//

import UIKit





public extension UIButton {
	
	var titleFont: UIFont? {
		get { return self.titleLabel?.font }
		set { self.titleLabel?.font = newValue }
	}
	
	
	func addTarget(_ target: Any?, action: Selector) {
		self.addTarget(target, action: action, for: .touchUpInside)
	}
	
	
	convenience init(type: UIButtonType = .system, target: Any?, action: Selector) {
		self.init(type: type)
		self.addTarget(target, action: action, for: .touchUpInside)
	}
}
