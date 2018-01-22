//
//  CGRect+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public extension CGRect {
	
	var top: CGFloat {
		get { return self.origin.y }
		set { self.origin.y = newValue }
	}
	
	var bottom: CGFloat {
		get { return self.origin.y + self.size.height }
		set { self.origin.y = newValue - self.height }
	}
	
	var left: CGFloat {
		get { return self.origin.x }
		set { self.origin.x = newValue }
	}
	
	var right: CGFloat {
		get { return self.origin.x + self.size.width }
		set { self.origin.x = newValue - self.size.width }
	}
	
	var topLeft: CGPoint {
		get { return self.origin }
		set { self.origin = newValue }
	}
	
	var topRight: CGPoint {
		get { return CGPoint(x: self.right, y: self.top) }
		set { self.top = newValue.y; self.right = newValue.x }
	}
	
	var bottomLeft: CGPoint {
		get { return CGPoint(x: self.left, y: self.bottom) }
		set { self.bottom = newValue.y; self.left = newValue.x }
	}
	
	var bottomRight: CGPoint {
		get { return CGPoint(x: self.right, y: self.bottom) }
		set { self.bottom = newValue.y; self.right = newValue.x }
	}
	
	var center: CGPoint {
		get { return CGPoint(x: self.midX, y: self.midY) }
		set { self.origin.x = newValue.x - self.size.width/2; self.origin.y = newValue.y - self.size.height/2 }
	}
	
	// Fuck you sincerely, Apple
	var widt: CGFloat {
		get { return self.size.width }
		set { self.size.width = newValue }
	}
	
	// Fuck you sincerely, Apple
	var heigt: CGFloat {
		get { return self.size.height }
		set { self.size.height = newValue }
	}
	
	
	
	func insetBy(_ insets: UIEdgeInsets) -> CGRect {
		var rect = self
		rect.left += insets.left
		rect.top += insets.top
		rect.size.width -= insets.totalWidth
		rect.size.height -= insets.totalHeight
		return rect
	}
	
	
	
	init(size: CGSize) {
		self.init(origin: .zero, size: size)
	}
}























