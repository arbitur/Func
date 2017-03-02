//
//  Funimation.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit




public enum Curve {
	case linear
	case easeIn
	case easeOut
	case easeInOut
	case `default`
	case custom(Float, Float, Float, Float)
	
	
	public var rawValue: String {
		switch self {
			case .linear	: return kCAMediaTimingFunctionLinear
			case .easeIn	: return kCAMediaTimingFunctionEaseIn
			case .easeOut	: return kCAMediaTimingFunctionEaseOut
			case .easeInOut	: return kCAMediaTimingFunctionEaseInEaseOut
			case .default	: return kCAMediaTimingFunctionDefault
			case .custom	: fatalError(".custom was called wrongly")
		}
	}
	
	
	fileprivate var timingFunction: CAMediaTimingFunction {
		switch self {
			case .custom(let c1x, let c1y, let c2x, let c2y):
				return CAMediaTimingFunction(controlPoints: c1x, c1y, c2x, c2y)
			default: return CAMediaTimingFunction(name: self.rawValue)
		}
	}
}


public class Funimation {
	
	// Start
	public func animate(animations: (Funimator)->()) {
		animations(animator)
		animate()
	}
	
	// Run animation
	private func animate() {
		guard !animator.animations.isEmpty else {
			return print("Animations done")
		}
		
		let animation = animator.animations.removeFirst()
		
		
		CATransaction.begin()
		CATransaction.setAnimationDuration(animation.animationDuration ?? 0.2)
		CATransaction.setAnimationTimingFunction(animation.animationCurve.timingFunction)
		
		if let wait = animation.waitToFinish {
			CATransaction.setCompletionBlock {
				DispatchQueue.main.asyncAfter(deadline: .now() + wait, execute: self.animate)
			}
		}
		
		let a = animation.animate(layer: layer)
		if animation.repeatCount >= 1 {
			a.autoreverses = true
			a.repeatCount = Float(animation.repeatCount)
		}
		layer.add(a, forKey: nil)
		
		CATransaction.commit()
		
		if animation.waitToFinish == nil {
			self.animate()
		}
	}
	
	
	
	private let animator = Funimator()
	private let layer: CALayer
	
	fileprivate init(layer: CALayer) {
		self.layer = layer
	}
}


public final class Funimator {
	fileprivate var animations = [Animation]()
	
	
	
	public func move(to: CGPoint) -> Animation {
		let a = MoveAnimation(point: to, relative: false)
		animations.append(a)
		return a
	}
	
	public func move(by: CGPoint) -> Animation {
		let a = MoveAnimation(point: by, relative: true)
		animations.append(a)
		return a
	}
}





// Abstract
public class Animation {
	fileprivate var animationDuration: TimeInterval?
	fileprivate var animationCurve:	Curve			= .easeInOut
	fileprivate var repeatCount: Int				= 0
	fileprivate var waitToFinish: TimeInterval?		= nil
	
	fileprivate var isRepeating: Bool {
		return repeatCount >= 1
	}
	fileprivate var isWaiting: Bool {
		return waitToFinish != nil
	}
	
	@discardableResult
	public final func duration(_ duration: TimeInterval) -> Self {
		if isRepeating {
			animationDuration = duration / TimeInterval(repeatCount*2)
		}
		else {
			animationDuration = duration
		}
		
		return self
	}
	
	@discardableResult
	public final func curve(_ curve: Curve) -> Self {
		self.animationCurve = curve
		return self
	}
	
	@discardableResult
	public final func `repeat`(_ repeatCount: Int) -> Self {
		self.repeatCount = repeatCount
		
//		if let duration = animationDuration {
//			animationDuration = duration / TimeInterval(repeatCount)
//		}
		
		return self
	}
	
	@discardableResult
	public final func wait(_ wait: TimeInterval = 0.0) -> Self {
		self.waitToFinish = wait
		return self
	}
	
	
	
	fileprivate func animate(layer: CALayer) -> CAAnimation {
		fatalError("animation(layer:_) needs to be overrided")
	}
}




fileprivate class MoveAnimation: Animation {
	let point: CGPoint
	let relative: Bool
	
	override func animate(layer: CALayer) -> CAAnimation {
		let a = CABasicAnimation(keyPath: "position")
		if relative {
			a.fromValue = layer.position
			a.byValue = point
		}
		else {
			a.fromValue = layer.position
			a.toValue = point
		}
		
		if repeatCount == 0 {
			layer.position = relative ? (layer.position + point) : point
		}
		
		return a
	}
	
	init(point: CGPoint, relative: Bool) {
		self.point = point
		self.relative = relative
	}
}





public extension CALayer {
	var fun: Funimation {
		return Funimation(layer: self)
	}
}

public extension UIView {
	var fun: Funimation {
		return self.layer.fun
	}
}





















