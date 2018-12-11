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
		let x: CGFloat = max(0, (self.contentSize.width + self.contentInset.left + self.contentInset.right) - self.bounds.size.width)
		let y: CGFloat = max(0, (self.contentSize.height + self.contentInset.top + self.contentInset.bottom) - self.bounds.height)
		return CGPoint(x, y)
	}
	
	
	
	var contentBounds: CGRect {
		get { return CGRect(origin: self.contentOffset, size: self.contentSize) }
		set {
			self.contentOffset = newValue.origin
			self.contentSize = newValue.size
		}
	}
	
	
	//TODO: Take into account for contentInset
//	var contentFrame: CGRect {
//		get { return CGRect(origin: self.contentOffset, size: self.contentSize) }
//		set {
//			self.contentOffset = newValue.origin
//			self.contentSize = newValue.size
//		}
//	}
}
