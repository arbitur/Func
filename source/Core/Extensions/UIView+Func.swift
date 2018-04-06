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
			self.layer.masksToBounds = true
		}
	}
	
	func roundCorners() {
		self.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
	}
	
	func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		self.layer.mask = mask
	}
	
	
	
	func border(width: CGFloat, color: UIColor = .black) {
		self.layer.borderWidth = width
		self.layer.borderColor = color.cgColor
	}
	
	
	
	func layout() {
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
	
	func removeAllSubViews() {
		for view in self.subviews {
			view.removeFromSuperview()
		}
	}
}



public extension UIView {
	
	/// Go down the hiarchy
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
	
	
	
	/// `point`: The point in `self` coordinate space. `view` the view to project the `point` onto
	func projectedPoint(_ point: CGPoint, to view: UIView) -> CGPoint {
		guard let superview = self.superview else {
			fatalError()
		}
		
		return superview.convert(point, to: view)
	}
	
	/// `rect`: The rectangle in `self` coordinate space. `view` the view to project the `rect` onto
	func projectedRect(_ rect: CGRect, to view: UIView) -> CGRect {
		guard let superview = self.superview else {
			fatalError()
		}
		
		return superview.convert(rect, to: view)
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
	
	static func nib <T: UIView> (name: String, owner: Any?) -> T! {
		let objects = Bundle.main.loadNibNamed(name, owner: owner, options: nil)!
		return objects.compactMap { $0 as? T }.first!
	}
	
	
	convenience init(frame: CGRect = .zero, backgroundColor: UIColor?) {
		self.init(frame: frame)
		self.backgroundColor = backgroundColor
	}
}






























