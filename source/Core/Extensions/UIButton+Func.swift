//
//  UIButton+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 24/Feb/17.
//
//

import UIKit





public extension UIButton {
	
	convenience init(type: UIButtonType = .system, target: Any?, action: Selector) {
		self.init(type: type)
		self.addTarget(target, action: action, for: .touchUpInside)
	}
}
