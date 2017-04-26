//
//  FuncViews.swift
//  Pods
//
//  Created by Philip Fryklund on 26/Feb/17.
//
//

import UIKit
import SnapKit





// SnapKit
public extension UIView {
	func add(view: UIView?, makeConstraints: (ConstraintMaker)->()) {
		self.add(view: view)
		view?.snp.makeConstraints(makeConstraints)
	}
}

public extension UIStackView {
	func add(arrangedView: UIView?, makeConstraints: (ConstraintMaker)->()) {
		self.add(arrangedView: arrangedView)
		arrangedView?.snp.makeConstraints(makeConstraints)
	}
}





public protocol BorderDrawable: class {
	var borderWidth: CGFloat? {get set}
	var borderColor: UIColor? {get set}
}

extension BorderDrawable {
	fileprivate func updateBorder(of view: UIView) {
		if let width = borderWidth, let color = borderColor ?? view.tintColor {
			view.border(width: width, color: color)
		}
	}
}





@IBDesignable
open class RoundView: UIView, BorderDrawable {
	@IBInspectable public var borderWidth: CGFloat? { didSet { self.setNeedsLayout() } }
	@IBInspectable public var borderColor: UIColor? { didSet { self.setNeedsLayout() } }
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		self.roundCorners()
		self.updateBorder(of: self)
	}
}


@IBDesignable
open class RoundLabel: UILabel, BorderDrawable {
	@IBInspectable public var borderWidth: CGFloat? { didSet { self.setNeedsLayout() } }
	@IBInspectable public var borderColor: UIColor? { didSet { self.setNeedsLayout() } }
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		self.roundCorners()
		self.updateBorder(of: self)
	}
}


@IBDesignable
open class TintImageView: UIImageView {
	open override var image: UIImage? {
		get { return super.image }
		set { super.image = newValue?.withRenderingMode(.alwaysTemplate) }
	}
}


@IBDesignable
open class RoundImageView: UIImageView, BorderDrawable {
	@IBInspectable public var borderWidth: CGFloat? { didSet { self.setNeedsLayout() } }
	@IBInspectable public var borderColor: UIColor? { didSet { self.setNeedsLayout() } }
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		self.roundCorners()
		self.updateBorder(of: self)
	}
}


@IBDesignable
open class RoundTintImageView: RoundImageView {
	open override var image: UIImage? {
		get { return super.image }
		set { super.image = newValue?.withRenderingMode(.alwaysTemplate) }
	}
}


@IBDesignable
open class RoundTextField: UITextField, BorderDrawable {
	@IBInspectable public var borderWidth: CGFloat? { didSet { self.setNeedsLayout() } }
	@IBInspectable public var borderColor: UIColor? { didSet { self.setNeedsLayout() } }
	
	open override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: self.cornerRadius, dy: 0)
	}
	
	open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return self.textRect(forBounds: bounds)
	}
	
	open override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return self.textRect(forBounds: bounds)
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		self.roundCorners()
		self.updateBorder(of: self)
	}
}









