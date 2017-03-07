//
//  CGPoint+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public extension CGSize {
	
	var aspectRatio: CGFloat {
		return self.width / self.height
	}
	
	
	
	init(_ width: CGFloat, _ height: CGFloat) {
		self.init(width: width, height: height)
	}
	
	init(_ width: Double, _ height: Double) {
		self.init(width: width, height: height)
	}
	
	init(_ width: Float, _ height: Float) {
		self.init(width: CGFloat(width), height: CGFloat(height))
	}
	
	init(_ width: Int, _ height: Int) {
		self.init(width: width, height: height)
	}
	
	init(_ size: CGFloat) {
		self.init(width: size, height: size)
	}
	
	init(_ size: Double) {
		self.init(width: size, height: size)
	}
	
	init(_ size: Float) {
		self.init(width: CGFloat(size), height: CGFloat(size))
	}
	
	init(_ size: Int) {
		self.init(width: size, height: size)
	}
}





public func + (lhs: CGSize, rhs: CGSize) -> CGSize {
	return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}

public func + (lhs: CGSize, rhs: CGFloat) -> CGSize {
	return CGSize(width: lhs.width + rhs, height: lhs.height + rhs)
}

public func - (lhs: CGSize, rhs: CGSize) -> CGSize {
	return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
}

public func - (lhs: CGSize, rhs: CGFloat) -> CGSize {
	return CGSize(width: lhs.width - rhs, height: lhs.height - rhs)
}

public func * (lhs: CGSize, rhs: CGSize) -> CGSize {
	return CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
}

public func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
	return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
}

public func / (lhs: CGSize, rhs: CGSize) -> CGSize {
	return CGSize(width: lhs.width / rhs.width, height: lhs.height / rhs.height)
}

public func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
	return CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
}



public func += (lhs: inout CGSize, rhs: CGSize) {
	lhs = lhs + rhs
}

public func += (lhs: inout CGSize, rhs: CGFloat) {
	lhs = lhs + rhs
}

public func -= (lhs: inout CGSize, rhs: CGSize) {
	lhs = lhs - rhs
}

public func -= (lhs: inout CGSize, rhs: CGFloat) {
	lhs = lhs - rhs
}

public func *= (lhs: inout CGSize, rhs: CGSize) {
	lhs = lhs * rhs
}

public func *= (lhs: inout CGSize, rhs: CGFloat) {
	lhs = lhs * rhs
}

public func /= (lhs: inout CGSize, rhs: CGSize) {
	lhs = lhs / rhs
}

public func /= (lhs: inout CGSize, rhs: CGFloat) {
	lhs = lhs / rhs
}





















