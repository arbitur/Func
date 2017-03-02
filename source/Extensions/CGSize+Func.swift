//
//  CGPoint+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public extension CGSize {
	
	var ratio: CGFloat {
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





public func + (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width + right.width, height: left.height + right.height)
}

public func + (left: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: left.width + right, height: left.height + right)
}

public func - (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width - right.width, height: left.height - right.height)
}

public func - (left: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: left.width - right, height: left.height - right)
}

public func * (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width * right.width, height: left.height * right.height)
}

public func * (left: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: left.width * right, height: left.height * right)
}

public func / (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width / right.width, height: left.height / right.height)
}

public func / (left: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: left.width / right, height: left.height / right)
}

public func += (left: inout CGSize, right: CGSize) {
	left.width += right.width
	left.height += right.height
}

public func += (left: inout CGSize, right: CGFloat) {
	left.width += right
	left.height += right
}

public func -= (left: inout CGSize, right: CGSize) {
	left.width -= right.width
	left.height -= right.height
}

public func -= (left: inout CGSize, right: CGFloat) {
	left.width -= right
	left.height -= right
}

public func *= (left: inout CGSize, right: CGSize) {
	left.width *= right.width
	left.height *= right.height
}

public func *= (left: inout CGSize, right: CGFloat) {
	left.width *= right
	left.height *= right
}





















