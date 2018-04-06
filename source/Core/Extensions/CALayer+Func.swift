//
//  CALayer+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public extension CALayer {
	
	var currentTime: CFTimeInterval {
		return self.convertTime(CACurrentMediaTime(), from: nil)
	}
	
	
	
	func addAnimation(_ animation: CABasicAnimation) {
		self.add(animation, forKey: animation.keyPath)
		self.setValue(animation.toValue, forKey: animation.keyPath!)
	}
	
	
	
	func removeAllSublayers() {
		self.sublayers?.forEach {
			$0.removeFromSuperlayer()
		}
	}
	
	
	
	convenience init(frame: CGRect) {
		self.init()
		self.frame = frame
	}
}
