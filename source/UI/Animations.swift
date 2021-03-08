//
//  Animations.swift
//  Func
//
//  Created by Philip Fryklund on 16/Aug/19.
//

import UIKit





public class ViewAnimations {
	
	public class Animation {
		internal var wait: Bool = false
		/// Default: 0.2
		public var duration: TimeInterval = 0.2
		public var delay: TimeInterval = 0
		/**
		- dampingRatio for the spring animation as it approaches its quiescent state. To smoothly decelerate the animation without oscillation, use a value of 1. Employ a damping ratio closer to zero to increase oscillation.
		- velocity for smooth start to the animation, match this value to the view’s velocity as it was prior to attachment. A value of 1 corresponds to the total animation distance traversed in one second. For example, if the total animation distance is 200 points and you want the start of the animation to match a view velocity of 100 pt/s, use a value of 0.5.
		*/
		public var spring: (dampingRatio: CGFloat, velocity: CGFloat)? = nil
		public var options: UIView.AnimationOptions = [.curveEaseInOut]
		public var animations: Closure!
		public var completion: ((Bool) -> Void)? = nil
	}
	
	private var animations = [Animation]()
	
	internal init() {}
	
	
	/// Adds animation to run imediatelly when animations start
	public func spawn(builder: (inout Animation) -> Void) {
		var animation = Animation()
		builder(&animation)
		animations.append(animation)
	}
	@available(*, deprecated, message: "Use `spawn(:)` instead")
	public func add(builder: (inout Animation) -> Void) {
		spawn(builder: builder)
	}
	
	/// Queue animation to run after previous animations has completed
	public func queue(builder: (inout Animation) -> Void) {
		var animation = Animation()
		animation.wait = true
		builder(&animation)
		animations.append(animation)
	}
	
	internal func start() {
		run()
	}
	
	private func run() {
		guard animations.isNotEmpty else { return }
		
		let a = animations.remove(at: 0)
		
		if let spring = a.spring {
			UIView.animate(withDuration: a.duration, delay: a.delay, usingSpringWithDamping: spring.dampingRatio, initialSpringVelocity: spring.velocity, options: a.options,
				animations: a.animations,
				completion: {
					a.completion?($0)
					self.run()
				})
		}
		else {
			UIView.animate(withDuration: a.duration, delay: a.delay, options: a.options,
				animations: a.animations,
				completion: {
					a.completion?($0)
					self.run()
				})
		}
		
		// Run next spawn
		if let nextAnimation = animations.first, !nextAnimation.wait {
			run()
		}
	}
}

public extension UIView {
	
	static func animate(builder: (ViewAnimations) -> Void) {
		let animations = ViewAnimations()
		builder(animations)
		animations.start()
	}
}
