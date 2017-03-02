//
//  CGPoint+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public extension CGPoint {
	var angle: CGFloat { return atan2(self.y, self.x) }
	
	func angle(to point: CGPoint) -> CGFloat {
		let deltaX = self.x - point.x
		let deltaY = self.y - point.y
		return atan2(deltaY, deltaX)
	}
	
	func distance(to point: CGPoint) -> CGFloat {
		return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
	}
	
	
	
	init(angle: CGFloat) {
		self.init(x: cos(angle), y: sin(angle))
	}
	
	init(angle: CGFloat, multiplier: CGFloat) {
		self.init(x: cos(angle) * multiplier, y: sin(angle) * multiplier)
	}
	
	init(_ x: CGFloat, _ y: CGFloat) {
		self.init(x: x, y: y)
	}
	
	init(_ x: Double, _ y: Double) {
		self.init(x: x, y: y)
	}
	
	init(_ x: Float, _ y: Float) {
		self.init(x: CGFloat(x), y: CGFloat(y))
	}
	
	init(_ x: Int, _ y: Int) {
		self.init(x: x, y: y)
	}
	
	
	
	init(radians: CGFloat) {
		self.init(x: cos(radians), y: sin(radians))
	}
}





public func + (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func + (left: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: left.x + right, y: left.y + right)
}

public func - (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

public func - (left: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: left.x - right, y: left.y - right)
}

public func * (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

public func * (left: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: left.x * right, y: left.y * right)
}

public func / (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

public func / (left: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: left.x / right, y: left.y / right)
}


public func += (left: inout CGPoint, right: CGPoint) {
	left.x += right.x
	left.y += right.y
}

public func += (left: inout CGPoint, right: CGFloat) {
	left.x += right
	left.y += right
}

public func -= (left: inout CGPoint, right: CGPoint) {
	left.x -= right.x
	left.y -= right.y
}

public func -= (left: inout CGPoint, right: CGFloat) {
	left.x -= right
	left.y -= right
}

public func *= (left: inout CGPoint, right: CGPoint) {
	left.x *= right.x
	left.y *= right.y
}

public func *= (left: inout CGPoint, right: CGFloat) {
	left.x *= right
	left.y *= right
}

public func /= (left: inout CGPoint, right: CGPoint) {
	left.x /= right.x
	left.y /= right.y
}

public func /= (left: inout CGPoint, right: CGFloat) {
	left.x /= right
	left.y /= right
}




















