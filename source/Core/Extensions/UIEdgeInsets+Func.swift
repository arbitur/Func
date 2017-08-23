//
//  UIEdgeInsets+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UIEdgeInsets {
	
	var totalWidth: CGFloat {
		return self.left + self.right
	}
	
	var totalHeight: CGFloat {
		return self.top + self.bottom
	}
	
	var size: CGSize {
		return CGSize(totalWidth, totalHeight)
	}
	
	
	
	init(inset: CGFloat) {
		self.init(top: inset, left: inset, bottom: inset, right: inset)
	}
	
	init(horizontal: CGFloat, vertical: CGFloat) {
		self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}
	
	init(vertical: CGFloat, left: CGFloat, right: CGFloat) {
		self.init(top: vertical, left: left, bottom: vertical, right: right)
	}
	
	init(horizontal: CGFloat, top: CGFloat, bottom: CGFloat) {
		self.init(top: top, left: horizontal, bottom: bottom, right: horizontal)
	}
}
