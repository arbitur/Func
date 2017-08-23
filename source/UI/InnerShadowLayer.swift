//
//  InnerShadowLayer.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Apr/17.
//
//

import UIKit





open class InnerShadowLayer: CALayer {
	@NSManaged open var innerShadowColor: CGColor
	@NSManaged open var innerShadowOffset: CGSize
	@NSManaged open var innerShadowRadius: CGFloat
	private static let keys = ["innerShadowColor", "innerShadowOffset", "innerShadowRadius"]
	
	
	open override class func needsDisplay(forKey key: String) -> Bool {
		return key == "frame" || (key ?== keys)
	}
	
	open func animationForInnershadow(key: String, fromValue value: Any) -> CAAction {
		let anim = CABasicAnimation(keyPath: key)
		anim.fromValue = value
		anim.timingFunction = .default
		return anim
	}
	
	open override func action(forKey key: String) -> CAAction? {
		if key ?== InnerShadowLayer.keys, let value = self.presentation()?.value(forKey: key) {
			return animationForInnershadow(key: key, fromValue: value)
		}
		
		return super.action(forKey: key)
	}
	
	open override func draw(in ctx: CGContext) {
		ctx.setAllowsAntialiasing(true)
		ctx.setShouldAntialias(true)
		ctx.interpolationQuality = .high
		
		var radius = self.cornerRadius
		
		var rect = self.bounds
		if self.borderWidth != 0 {
			rect = rect.insetBy(dx: self.borderWidth, dy: self.borderWidth)
			radius -= self.borderWidth
			radius = max(radius, 0)
		}
		
		let outerPath = UIBezierPath(roundedRect: rect, cornerRadius: radius)
		ctx.addPath(outerPath.cgPath)
		ctx.clip()
		
		let invertedPath = CGMutablePath()
		invertedPath.addRect(rect.insetBy(dx: -rect.size.width, dy: -rect.size.height))
		invertedPath.addPath(outerPath.cgPath)
		invertedPath.closeSubpath()
		
		ctx.setFillColor(self.innerShadowColor)
		ctx.setShadow(offset: self.innerShadowOffset, blur: self.innerShadowRadius, color: self.innerShadowColor)
		
		ctx.addPath(invertedPath)
		ctx.fillPath(using: .evenOdd)
	}
	
	private func setDefaults() {
		self.allowsEdgeAntialiasing = true
		self.needsDisplayOnBoundsChange = true
		self.masksToBounds = true
		
		innerShadowColor = UIColor.black.cgColor
		innerShadowRadius = 10
		innerShadowOffset = .zero
	}
	public override init() {
		super.init()
		setDefaults()
	}
	
	public override init(layer: Any) {
		super.init(layer: layer)
		setDefaults()
		
		if let layer = layer as? InnerShadowLayer {
			innerShadowRadius = layer.innerShadowRadius
			innerShadowOffset = layer.innerShadowOffset
			innerShadowColor = layer.innerShadowColor
		}
	}
	public required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		setDefaults()
	}
}













