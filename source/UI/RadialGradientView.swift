//
//  RadialGradientView.swift
//  Pods
//
//  Created by Philip Fryklund on 21/Feb/17.
//
//

import UIKit





public class RadialGradientView: UIView {
	
	public override class var layerClass: AnyClass { return RadialGradientLayer.self }
	
	private var gradientLayer: RadialGradientLayer { return self.layer as! RadialGradientLayer }
	
	
	
	public var colorComponents: [(color: UIColor, location: CGFloat)]? {
		get { return gradientLayer.colorComponents }
		set { gradientLayer.colorComponents = newValue }
	}
}





open class RadialGradientLayer: CALayer {
	
	public var colorComponents: [(color: UIColor, location: CGFloat)]? {
		didSet { self.setNeedsDisplay() }
	}
	
	
	open override func animation(forKey key: String) -> CAAnimation? {
		switch key {
			case "frame": fallthrough
			case "bounds": return nil
			default: return super.animation(forKey: key)
		}
	}
	
	
	public override init() {
		super.init()
		self.needsDisplayOnBoundsChange = true
	}
	
	public override init(layer: Any) {
		super.init(layer: layer)
		self.needsDisplayOnBoundsChange = true
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.needsDisplayOnBoundsChange = true
	}
	
	
	
	open override func draw(in ctx: CGContext) {
		guard let components = colorComponents, !components.isEmpty else {
			return super.draw(in: ctx)
		}
		
		let colors = components.map { $0.color.cgColor } as CFArray
		let locations = components.map { $0.location }
		
		ctx.saveGState()
		
		let colorspace = CGColorSpaceCreateDeviceRGB()
		let gradient = CGGradient(colorsSpace: colorspace, colors: colors, locations: locations)!
		
		let center = self.bounds.center
		let radius = center.magnitude//Math.hypotenusa(point: center) //TODO: Check still works as intended
		
		ctx.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: radius, options: .drawsAfterEndLocation)
	}
}
















