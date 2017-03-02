//
//  CAShapeLayer+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public extension CAShapeLayer {
	convenience init(path: CGPath) {
		self.init()
		self.path = path
	}
}
