//
//  FuncViews.swift
//  Pods
//
//  Created by Philip Fryklund on 26/Feb/17.
//
//

import UIKit
import SnapKit





public func pixels(points: CGFloat) -> CGFloat {
	return points * UIScreen.main.scale
}

public func points(pixels: Int) -> CGFloat {
	return CGFloat(pixels) / UIScreen.main.scale
}





public protocol BorderDrawable: class {
	var borderWidth: CGFloat { get set }
	var borderColor: UIColor { get set }
}

extension BorderDrawable where Self: UIView {
	
	public var borderWidth: CGFloat {
		get { return self.layer.borderWidth }
		set { self.layer.borderWidth = newValue }
	}
	
	public var borderColor: UIColor {
		get {
			if let cgColor = self.layer.borderColor {
				return UIColor(cgColor: cgColor)
			}
			else {
				return self.tintColor
			}
		}
		set {
			self.layer.borderColor = newValue.cgColor
		}
	}
}





@IBDesignable
open class RoundView: UIView, BorderDrawable {
	
	open override func tintColorDidChange() {
		super.tintColorDidChange()
		self.borderColor = self.tintColor
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		self.roundCorners()
	}
}



@IBDesignable
open class RoundLabel: UILabel, BorderDrawable {
	
	open override func tintColorDidChange() {
		super.tintColorDidChange()
		self.borderColor = self.tintColor
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		self.roundCorners()
	}
}



@IBDesignable
open class RoundButton: UIButton, BorderDrawable {
	
	open override func tintColorDidChange() {
		super.tintColorDidChange()
		self.borderColor = self.tintColor
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		self.roundCorners()
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
	
	open override func tintColorDidChange() {
		super.tintColorDidChange()
		self.borderColor = self.tintColor
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		self.roundCorners()
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
	
	open override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: self.cornerRadius, dy: 0)
	}
	
	open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return self.textRect(forBounds: bounds)
	}
	
	open override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return self.textRect(forBounds: bounds)
	}
	
	open override func tintColorDidChange() {
		super.tintColorDidChange()
		self.borderColor = self.tintColor
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		self.roundCorners()
	}
}









