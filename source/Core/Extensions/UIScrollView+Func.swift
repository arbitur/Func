//
//  UIScrollView+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UIScrollView {
	
	var maximumContentOffset: CGPoint {
		let x: CGFloat
		let y: CGFloat
		
		if self.contentSize.width > self.bounds.size.width {
			x = self.contentSize.width - self.bounds.size.width
		}
		else {
			x = 0
		}
		
		if self.contentSize.height > self.bounds.height {
			y = self.contentSize.height - self.bounds.height
		}
		else {
			y = 0
		}
		
		return CGPoint(x, y)
	}
	
	
	
	var contentFrame: CGRect {
		get { return CGRect(origin: self.contentOffset, size: self.contentSize) }
		set {
			self.contentOffset = newValue.origin
			self.contentSize = newValue.size
		}
	}
}
