//
//  Quartz+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Apr/17.
//
//

import QuartzCore





public extension CAMediaTimingFunction {
	
	static var linear: CAMediaTimingFunction { return CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear) }
	static var easeIn: CAMediaTimingFunction { return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn) }
	static var easeOut: CAMediaTimingFunction { return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut) }
	static var easeInOut: CAMediaTimingFunction { return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut) }
	static var `default`: CAMediaTimingFunction { return CAMediaTimingFunction(name: CAMediaTimingFunctionName.default) }
	
	static func custom(controlPoint1 point1: CGPoint, controlPoint2 point2: CGPoint) -> CAMediaTimingFunction {
		return CAMediaTimingFunction(controlPoints: Float(point1.x), Float(point1.y), Float(point2.x), Float(point2.y))
	}
}
