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
		let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		self.layer.mask = mask
	}
	
	
	
	func border(width: CGFloat, color: UIColor = .black) {
		self.layer.borderWidth = width
		self.layer.borderColor = color.cgColor
	}
	
	
	
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
	
	/// Go down the hiarchy
	var descendants: [UIView] {
		return [self] + self.subviews.flatMap{ $0.descendants }
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
	
	
	
	var capturedImage: UIImage! {
		UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
		defer { UIGraphicsEndImageContext() }
		self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	
	
	func transform(scale: CGSize) {
		self.transform = CGAffineTransform(scaleX: scale.width, y: scale.height)
	}
	
	func transform(rotation angle: CGFloat) {
		self.transform = CGAffineTransform(rotationAngle: angle)
	}
	
	
	
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
	
	
	
	static func nib(name: String, owner: AnyObject) -> UIView? {
		return Bundle.main.loadNibNamed(name, owner: owner, options: nil)?.first as? UIView
	}
	
	convenience init(frame: CGRect = .zero, backgroundColor: UIColor) {
		self.init(frame: frame)
		self.backgroundColor = backgroundColor
	}
}






























