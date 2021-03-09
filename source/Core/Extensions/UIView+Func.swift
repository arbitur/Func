//
//  UIView+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import UIKit





public extension UIView {
	
	var cornerRadius: CGFloat {
		get { return self.layer.cornerRadius }
		set {
			self.layer.cornerRadius = newValue
//			self.layer.masksToBounds = true
		}
	}
	
//	var borderColor: UIColor {
//		get { return self.layer.borderColor.map({ UIColor(cgColor: $0) }) ?? .clear }
//		set {
//			self.layer.borderColor = newValue.cgColor
//		}
//	}
//
//	var borderWidth: CGFloat {
//		get { return self.layer.borderWidth }
//		set {
//			self.layer.borderWidth = newValue
//		}
//	}
	
	
	var isVisible: Bool {
		get { return !self.isHidden }
		set { self.isHidden = !newValue }
	}
	
	/// If inside a stack view. Stackview bug with isHidden, it counts everytime you set isHidden even if set to the same value.
	var safeHidden: Bool {
		get { return self.isHidden }
		set {
			if self.superview is UIStackView {
				if self.isHidden != newValue {
					self.isHidden = newValue
				}
				self.alpha = newValue ? 0.0 : 1.0
			}
			else {
				self.isHidden = newValue
			}
		}
	}
	
	
	
	func roundCorners() {
		self.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
		self.clipsToBounds = true
	}
	
	func roundedCorners(_ corners: UIRectCorner, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		self.layer.mask = mask
	}
	
	
	
	func border(width: CGFloat, color: UIColor = .black) {
		self.layer.borderWidth = width
		self.layer.borderColor = color.cgColor
	}
	
	
	
	func forceLayout() {
		self.setNeedsLayout()
		self.layoutIfNeeded()
	}
}



public extension UIView {
	
	func add(view: UIView?) {
		if let view = view {
			self.addSubview(view)
		}
	}
	
	func add(views: UIView? ...) {
		for view in views {
			self.add(view: view)
		}
	}
	
	func removeAllSubviews() {
		for view in self.subviews {
			view.removeFromSuperview()
		}
	}
	
	@available(*, deprecated, message: "Use `removeAllSubviews` instead.")
	func removeAllSubViews() {
		removeAllSubviews()
	}
}



public extension UIView {
	
	/// Go down the hiarchy. First element is self
	var descendants: [UIView] {
		return [self] + self.subviews.flatMap { $0.descendants }
	}
	
	/// Go up the hiarchy
	var precendents: [UIView] {
		var views = [UIView]()
		var view = self.superview
		while let v = view {
			views.append(v)
			view = v.superview
		}
		return views
	}
	
	
	
	var superViewController: UIViewController? {
		var responder: UIResponder? = self
		
		repeat {
			responder = responder?.next
			if let viewController = responder as? UIViewController {
				return viewController
			}
		}
		while responder != nil
		
		return nil
	}
}



public extension UIView {
	
	func transform(scaleX x: CGFloat, y: CGFloat) {
		self.transform = CGAffineTransform(scaleX: x, y: y)
	}
	
	func transform(scale: CGFloat) {
		self.transform = CGAffineTransform(scaleX: scale, y: scale)
	}
	
	func transform(rotation angle: CGFloat) {
		self.transform = CGAffineTransform(rotationAngle: angle)
	}
	
	func transform(moveX x: CGFloat, y: CGFloat) {
		self.transform = CGAffineTransform(translationX: x, y: y)
	}
	
	func translateTo(x: CGFloat, y: CGFloat) {
		self.transform = self.transform.concatenating(CGAffineTransform(translationX: x, y: y))
	}
	
	func translateBy(x: CGFloat, y: CGFloat) {
		self.transform = self.transform.translatedBy(x: x, y: y)
	}
	
	
	
	/// `rect`: The rectangle in `self` coordinate space. `view` the view to project the `rect` onto
	func projectedFrame(to view: UIView?) -> CGRect? {
		return self.superview?.convert(self.frame, to: view)
	}
}



public extension UIView {
	
	func applyMotion(magnitude: CGFloat) {
		let motionX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
		motionX.minimumRelativeValue = -magnitude
		motionX.maximumRelativeValue = magnitude
		
		let motionY = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
		motionY.minimumRelativeValue = -magnitude
		motionY.maximumRelativeValue = magnitude
		
		let motionGroup = UIMotionEffectGroup()
		motionGroup.motionEffects = [motionX, motionY]
		self.addMotionEffect(motionGroup)
	}
	
	
	func captureImage() -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
		defer { UIGraphicsEndImageContext() }
		self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
}



public extension UIView {
	
//	static func nib(name: String, owner: Any?) -> UIView? {
//		return Bundle.main.loadNibNamed(name, owner: owner, options: nil)?.first as? UIView
//	}
	
	
	static func nib <T: UIView> (name: String, owner: Any?) -> T {
		let objects = Bundle.main.loadNibNamed(name, owner: owner, options: nil)!
		return objects.compactMap { $0 as? T }.first!
	}
	
//	static func nib <T: UIView> (name: String, owner: Any?) -> T! {
//		let objects = Bundle.main.loadNibNamed(name, owner: owner, options: nil)!
//		return objects.compactMap { $0 as? T }.first!
//	}
	
	
	convenience init(frame: CGRect = .zero, backgroundColor: UIColor?) {
		self.init(frame: frame)
		self.backgroundColor = backgroundColor
	}
}
