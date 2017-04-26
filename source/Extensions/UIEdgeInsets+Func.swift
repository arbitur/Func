//
//  UIEdgeInsets+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UIEdgeInsets {
	init(inset: CGFloat) {
		self.init(top: inset, left: inset, bottom: inset, right: inset)
	}
	
	init(vertical: CGFloat, horizontal: CGFloat) {
		self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}
	
	init(vertical: CGFloat, left: CGFloat, right: CGFloat) {
		self.init(top: vertical, left: left, bottom: vertical, right: right)
	}
	
	init(horizontal: CGFloat, top: CGFloat, bottom: CGFloat) {
		self.init(top: top, left: horizontal, bottom: bottom, right: horizontal)
	}
}
