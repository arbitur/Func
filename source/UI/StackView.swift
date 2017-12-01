//
//  StackView.swift
//  Pods
//
//  Created by Philip Fryklund on 26/Feb/17.
//
//

import UIKit





@available(iOS 9.0, *)
open class StackView: UIStackView {
	
	private var _backgroundColor: UIColor?
	open override var backgroundColor: UIColor? {
		get { return _backgroundColor }
		set {
			_backgroundColor = newValue
			backgroundLayer.fillColor = newValue?.cgColor
		}
	}
	
	private let backgroundLayer = CAShapeLayer()
	open override var layer: CALayer {
		return backgroundLayer
	}
	
	open override var layoutMargins: UIEdgeInsets {
		get { return super.layoutMargins }
		set {
			self.isLayoutMarginsRelativeArrangement = true
			super.layoutMargins = newValue
		}
	}
	
	
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
		backgroundLayer.frame = self.bounds
		backgroundLayer.removeAllAnimations()
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = nil
		super.layer.insertSublayer(backgroundLayer, at: 0)
	}
	
	public required init(coder: NSCoder) {
		super.init(coder: coder)
		self.backgroundColor = nil
		super.layer.insertSublayer(backgroundLayer, at: 0)
	}
	
	
	public convenience init(frame: CGRect = .zero, backgroundColor: UIColor) {
		self.init(frame: frame)
		self.backgroundColor = backgroundColor
	}
}


















