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
}
