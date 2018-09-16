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
	
	open override func prepareForInterfaceBuilder() {
		gradientLayer.gradientColorSpecifications = [
			(.white, 0),
			(.black, 1)
		]
	}
	
	
	public init(gradientColorSpecifications: [(color: UIColor, location: Double)]) {
		super.init(frame: .zero)
		self.gradientColorSpecifications = gradientColorSpecifications
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
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

















