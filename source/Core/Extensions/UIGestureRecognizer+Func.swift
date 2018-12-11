//
//  UIGestureRecognizer+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UIGestureRecognizer {
	
	var point: CGPoint {
		return self.location(in: self.view)
	}
	
	
	convenience init(target: Any?, action: Selector?, delegate: UIGestureRecognizerDelegate) {
		self.init(target: target, action: action)
		self.delegate = delegate
	}
}





public extension UISwipeGestureRecognizer {
	
	convenience init(target: Any?, action: Selector?, direction: UISwipeGestureRecognizer.Direction) {
		self.init(target: target, action: action)
		self.direction = direction
	}
}
