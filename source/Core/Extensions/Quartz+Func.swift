//
//  Quartz+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Apr/17.
//
//

import QuartzCore





public extension CAMediaTimingFunction {
	
	static var linear: CAMediaTimingFunction { return CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear) }
	static var easeIn: CAMediaTimingFunction { return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn) }
	static var easeOut: CAMediaTimingFunction { return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) }
	static var easeInOut: CAMediaTimingFunction { return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) }
	static var `default`: CAMediaTimingFunction { return CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault) }
	
	static func custom(controlPoint1 point1: CGPoint, controlPoint2 point2: CGPoint) -> CAMediaTimingFunction {
		return CAMediaTimingFunction(controlPoints: Float(point1.x), Float(point1.y), Float(point2.x), Float(point2.y))
	}
}
