//
//  UIStackView+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UIStackView {
	
	/// This method should be used to hide views inside a UIStackView due to a bug in UIStackView when setting isHidden = false more than once it takes an equal amount of isHidden = true to make it visible again...
	@available(*, deprecated, message: "Use UIView.safeHidden instead")
	static func setHidden(_ hidden: Bool, for view: UIView) {
		if view.isHidden != hidden {
			view.isHidden = hidden
		}
		view.alpha = hidden ? 0.0 : 1.0
	}
	
	func add(arrangedView view: UIView?) {
		guard let view = view else {
			return
		}
		self.addArrangedSubview(view)
	}
	
	
	func add(arrangedViews views: UIView? ...) {
		for view in views {
			self.add(arrangedView: view)
		}
	}
	
	func insert(arrangedView newView: UIView, before subview: UIView) {
		guard let index = self.arrangedSubviews.firstIndex(of: subview) else {
			return
		}
		
		self.insertArrangedSubview(newView, at: index)
	}
	
	func insert(arrangedView newView: UIView, after subview: UIView) {
		guard let index = self.arrangedSubviews.firstIndex(of: subview) else {
			return
		}
		
		self.insertArrangedSubview(newView, at: index + 1)
	}
	
	
	
	convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0.0, arrangedSubviews: [UIView]? = nil) {
		self.init(frame: .zero)
		self.axis = axis
		self.spacing = spacing
		arrangedSubviews?.forEach(self.addArrangedSubview)
	}
}
