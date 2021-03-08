//
//  CGPoint+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public extension CGSize {
	
	/**
		Returns an aspect ratio of `width / height`
	
		## Usage:
			let width = height * aspectRatio
	*/
	var aspectRatio: CGFloat {
		return self.width / self.height
	}
	
	
	
	init <T> (_ width: T, _ height: T) where T: Number {
		self.init(width: width.toDouble(), height: height.toDouble())
	}
	
	init <T> (_ size: T) where T: Number {
		self.init(size, size)
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





















