//
//  CGPoint+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public extension CGPoint {
	var angle: CGFloat {
		return atan2(self.y, self.x)
	}
	
	var magnitude: CGFloat {
		return distance(to: .zero)
	}
	
	
	
	func angle(to point: CGPoint) -> CGFloat {
		let deltaX = self.x - point.x
		let deltaY = self.y - point.y
		return atan2(deltaY, deltaX)
	}
	
	func distance(to point: CGPoint) -> CGFloat {
		return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
	}
	
	
	
	/// Angle in rad
	init(angle: CGFloat, magnitude: CGFloat = 1.0) {
		self.init(x: cos(angle) * magnitude, y: sin(angle) * magnitude)
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
}





public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
	return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func + (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
	return CGPoint(x: lhs.x + rhs, y: lhs.y + rhs)
}

public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
	return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func - (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
	return CGPoint(x: lhs.x - rhs, y: lhs.y - rhs)
}

public func * (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
	return CGPoint(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
}

public func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
	return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
}

public func / (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
	return CGPoint(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
}

public func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
	return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
}



public func += (lhs: inout CGPoint, rhs: CGPoint) {
	lhs = lhs + rhs
}

public func += (lhs: inout CGPoint, rhs: CGFloat) {
	lhs = lhs + rhs
}

public func -= (lhs: inout CGPoint, rhs: CGPoint) {
	lhs = lhs - rhs
}

public func -= (lhs: inout CGPoint, rhs: CGFloat) {
	lhs = lhs - rhs
}

public func *= (lhs: inout CGPoint, rhs: CGPoint) {
	lhs = lhs * rhs
}

public func *= (lhs: inout CGPoint, rhs: CGFloat) {
	lhs = lhs * rhs
}

public func /= (lhs: inout CGPoint, rhs: CGPoint) {
	lhs = lhs / rhs
}

public func /= (lhs: inout CGPoint, rhs: CGFloat) {
	lhs = lhs / rhs
}




















