//
//  LinearGradientView.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





@IBDesignable
open class LinearGradientView: UIView {
	
	open override class var layerClass: AnyClass { return LinearGradientLayer.self }
	
	public var gradientLayer: LinearGradientLayer {
		return self.layer as! LinearGradientLayer
	}
	
	
	public var gradientColorSpecifications: [(color: UIColor, location: Double)]? {
		get { return gradientLayer.gradientColorSpecifications }
		set {
			gradientLayer.gradientColorSpecifications = newValue
		}
	}
	
	public var startPoint: CGPoint {
		get { return gradientLayer.startPoint }
		set { gradientLayer.startPoint = newValue }
	}
	
	public var endPoint: CGPoint {
		get { return gradientLayer.endPoint }
		set { gradientLayer.endPoint = newValue }
	}
	
	
	public convenience init(gradientColorSpecifications: [(color: UIColor, location: Double)]) {
		self.init(frame: .zero)
		self.gradientColorSpecifications = gradientColorSpecifications
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}



@IBDesignable
open class SimpleLinearGradientView: LinearGradientView {
	
	@IBInspectable var gradientDirection: NSLayoutConstraint.Axis = .vertical {
		didSet {
			switch gradientDirection {
			case .vertical:
				self.startPoint = CGPoint(0.5, 0.0)
				self.endPoint = CGPoint(0.5, 1.0)
				
			case .horizontal:
				self.startPoint = CGPoint(0.0, 0.5)
				self.endPoint = CGPoint(1.0, 0.5)
			}
		}
	}
	
	@IBInspectable var firstColor: UIColor = .clear {
		didSet {
			self.updateColors()
		}
	}
	
	@IBInspectable var secondColor: UIColor = .clear {
		didSet {
			self.updateColors()
		}
	}
	
	
	private func updateColors() {
		self.gradientColorSpecifications = [(firstColor, 0.0), (secondColor, 1.0)]
		self.setNeedsDisplay()
	}
}




open class LinearGradientLayer: CAGradientLayer {
	
	public var gradientColorSpecifications: [(color: UIColor, location: Double)]? {
		get { return zip(self.colors ?? [], self.locations ?? []).map { (UIColor(cgColor: $0.0 as! CGColor), $0.1.doubleValue) } }
		set {
			self.colors = newValue?.map { $0.color.cgColor }
			self.locations = newValue?.map { NSNumber(value: $0.location) }
		}
	}
	
//	open override func action(forKey event: String) -> CAAction? {
//		super.action(forKey: event)
//	}
	
	open override func animation(forKey key: String) -> CAAnimation? {
		switch key {
			case "frame": fallthrough
			case "bounds": return nil
			default: return super.animation(forKey: key)
		}
	}
	
	
	private func initz() {
		self.needsDisplayOnBoundsChange = true
		self.isOpaque = false
	}
	
	public override init() {
		super.init()
		initz()
	}
	
	public override init(layer: Any) {
		super.init(layer: layer)
		initz()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initz()
	}
}

















