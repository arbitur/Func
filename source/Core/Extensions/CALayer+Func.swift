//
//  CALayer+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public extension CALayer {
	func setShadow(offset: CGSize?, radius: CGFloat?, opacity: Float?, color: UIColor? = nil, animationDuration: Double = 0) {
		let oldOpacity = self.shadowOpacity
		
		self.shadowOffset = offset ?? CGSize.zero
		self.shadowColor = color?.cgColor ?? UIColor.black.cgColor
		self.shadowRadius = radius ?? 5
		self.shadowOpacity = opacity ?? 1
		
		if animationDuration != 0 {
			let animation = CABasicAnimation(keyPath: "shadowOpacity")
			animation.fromValue = oldOpacity
			animation.toValue = self.shadowOpacity
			animation.duration = animationDuration
			self.add(animation, forKey: "shadowOpacity")
		}
	}
	
	
	
	func removeAllSublayers() {
		self.sublayers?.forEach { $0.removeFromSuperlayer() }
	}
	
	
	
	convenience init(frame: CGRect) {
		self.init()
		self.frame = frame
	}
}
