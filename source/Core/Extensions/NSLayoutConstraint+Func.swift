//
//  NSLayoutConstraint+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 26/Apr/17.
//
//

import Foundation





public extension NSLayoutConstraint {
	
	func activate() {
		if !self.isActive {
			self.isActive = true
		}
	}
	
	func deactivate() {
		if self.isActive {
			self.isActive = false
		}
	}
}





public extension UILayoutPriority {
	
	static var high: UILayoutPriority {
		return .defaultHigh
	}
	
	static var medium: UILayoutPriority {
		return UILayoutPriority(rawValue: 500)
	}
	
	static var low: UILayoutPriority {
		return .defaultLow
	}
}



extension UILayoutPriority: ExpressibleByFloatLiteral {
	
	public init(floatLiteral value: Float) {
		self.init(value)
	}
	
	public static func + (lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
		return UILayoutPriority(rawValue: boundary(lhs.rawValue + rhs, min: 0, max: 1000))
	}
	
	public static func - (lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
		return UILayoutPriority(rawValue: boundary(lhs.rawValue - rhs, min: 0, max: 1000))
	}
}
