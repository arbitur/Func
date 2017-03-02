//
//  UISwipeGestureRecognizer+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit



public extension UISwipeGestureRecognizer {
	convenience init(target: Any?, action: Selector?, direction: UISwipeGestureRecognizerDirection) {
		self.init(target: target, action: action)
		self.direction = direction
	}
}