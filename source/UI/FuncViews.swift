//
//  FuncViews.swift
//  Pods
//
//  Created by Philip Fryklund on 26/Feb/17.
//
//

import Foundation




public func pixels(points: CGFloat) -> CGFloat {
	return points * UIScreen.main.scale
}

public func points(pixels: Int) -> CGFloat {
	return CGFloat(pixels) / UIScreen.main.scale
}





public protocol BorderDrawable: AnyObject {
	var borderWidth: CGFloat { get set }
	var borderColor: UIColor { get set }
}

private extension BorderDrawable where Self: UIView {
	
	func drawBorder() {
		self.border(width: borderWidth, color: borderColor == .black ? self.tintColor : borderColor)
	}
}





@IBDesignable
open class RoundView: UIView, BorderDrawable {
	
	@IBInspectable public var borderWidth: CGFloat = 0 		 { didSet { self.drawBorder() } }
	@IBInspectable public var borderColor: UIColor = .black  { didSet { self.drawBorder() } }
	
	open override func tintColorDidChange() {
		super.tintColorDidChange()
		borderColor = self.tintColor
	}
	open override func layoutSubviews() {
		super.layoutSubviews()
		self.roundCorners()
	}
}



@IBDesignable
open class RoundLabel: UILabel, BorderDrawable {
	
	@IBInspectable public var borderWidth: CGFloat = 0 		 { didSet { self.drawBorder() } }
	@IBInspectable public var borderColor: UIColor = .black  { didSet { self.drawBorder() } }
	
	open override func tintColorDidChange() {
		super.tintColorDidChange()
		borderColor = self.tintColor
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		self.roundCorners()
	}
}



@IBDesignable
open class RoundButton: UIButton, BorderDrawable {
	
	@IBInspectable public var borderWidth: CGFloat = 0 		 { didSet { self.drawBorder() } }
	@IBInspectable public var borderColor: UIColor = .black  { didSet { self.drawBorder() } }
	
	open override func tintColorDidChange() {
		super.tintColorDidChange()
		borderColor = self.tintColor
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		self.roundCorners()
	}
}


@available(*, unavailable, message: "Define assets as templates instead")
@IBDesignable
open class TintImageView: UIImageView {
	
	open override var image: UIImage? {
		get { return super.image }
		set { super.image = newValue?.withRenderingMode(.alwaysTemplate) }
	}
	
	private func makeImageTemplate() {
		self.image = self.image?.withRenderingMode(.alwaysTemplate)
	}
	
	open override func tintColorDidChange() {
		super.tintColorDidChange()
		makeImageTemplate()
	}
	
	open override func awakeFromNib() {
		super.awakeFromNib()
		makeImageTemplate()
	}
	
	open override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		makeImageTemplate()
	}
}



@IBDesignable
open class RoundImageView: UIImageView, BorderDrawable {
	
	@IBInspectable public var borderWidth: CGFloat = 0 		 { didSet { self.drawBorder() } }
	@IBInspectable public var borderColor: UIColor = .black  { didSet { self.drawBorder() } }
	
	open override func tintColorDidChange() {
		super.tintColorDidChange()
		borderColor = self.tintColor
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		self.roundCorners()
	}
}



@available(*, unavailable, message: "Define assets as templates instead")
@IBDesignable
open class RoundTintImageView: RoundImageView {
	
	private func makeImageTemplate() {
		self.image = self.image?.withRenderingMode(.alwaysTemplate)
	}
	
	open override func tintColorDidChange() {
		super.tintColorDidChange()
		makeImageTemplate()
	}
	
	open override func awakeFromNib() {
		super.awakeFromNib()
		makeImageTemplate()
	}
	
	open override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		makeImageTemplate()
	}
}



@IBDesignable
open class RoundTextField: UITextField, BorderDrawable {
	
	open override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: self.cornerRadius / 2, dy: 0)
	}
	
	open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return self.textRect(forBounds: bounds)
	}
	
	open override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return self.textRect(forBounds: bounds)
	}
	
	@IBInspectable public var borderWidth: CGFloat = 0 		 { didSet { self.drawBorder() } }
	@IBInspectable public var borderColor: UIColor = .black  { didSet { self.drawBorder() } }
	
	open override func tintColorDidChange() {
		super.tintColorDidChange()
		borderColor = self.tintColor
	}
	open override func layoutSubviews() {
		super.layoutSubviews()
		self.roundCorners()
	}
}









open class AdjustableButton: UIButton {
	
	public var modifyImageRect: ((inout CGRect) -> ())? {
		didSet { self.layoutIfNeeded() }
	}
	public var modifyTitleRect: ((inout CGRect) -> ())? {
		didSet { self.layoutIfNeeded() }
	}
	
	open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
		var rect = super.imageRect(forContentRect: contentRect)
		modifyImageRect?(&rect)
		return rect
	}
	
	open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
		var rect = super.titleRect(forContentRect: contentRect)
		modifyTitleRect?(&rect)
		return rect
	}
}
