//
//  StarRatingView.swift
//  Func
//
//  Created by Philip Fryklund on 8/Dec/17.
//

import Foundation





@IBDesignable
open class StarRatingView: UIControl {
	
	@IBInspectable open var numberOfStars: Int = 5 {
		didSet {
			maximumValue = Float(numberOfStars)
			_maskLayer = nil
			self.setNeedsLayout()
		}
	}
	
	@IBInspectable open var value: Float = 0 {
		didSet {
			if stepValue != 0 {
				value = boundary(Math.round(value, base: stepValue), min: minimumValue, max: maximumValue)
			}
			self.setNeedsLayout()
		}
	}
	
	@IBInspectable open var stepValue: Float = 0 {
		didSet {
			value = Float(value)
		}
	}
	
	@IBInspectable open var minimumValue: Float = 0 {
		didSet {
			value = Float(value)
		}
	}
	
	@IBInspectable open var maximumValue: Float = 5 {
		didSet {
			value = Float(value)
		}
	}
	
	open var starSource: StarViewShapeSource = .character("\u{2605}", 26) { // https://unicode-table.com/en/2605/
		didSet {
			_maskLayer = nil
			self.setNeedsLayout()
		}
	}
	
	
	
	open override func tintColorDidChange() {
		super.tintColorDidChange()
		highlightLayer.backgroundColor = self.tintColor.cgColor
	}
	
	open override var intrinsicContentSize: CGSize {
		return maskLayer.bounds.size
	}
	
	open override func sizeToFit() {
		self.frame.size = self.intrinsicContentSize
	}
	
	
	
	
	private var _maskLayer: CALayer? {
		willSet {
			_maskLayer?.removeFromSuperlayer()
		}
	}
	private var maskLayer: CALayer {
		get { return _maskLayer ?? generateMaskLayer() }
		set {
			self.layer.mask = newValue
			_maskLayer = newValue
			self.invalidateIntrinsicContentSize()
		}
	}
	
	@discardableResult
	private func generateMaskLayer() -> CALayer {
		guard let starImage = starSource.image else {
			fatalError()
		}
		
		maskLayer = CALayer()
		maskLayer.frame.size.height = starImage.size.height
		
		for i in 0..<numberOfStars {
			let starLayer = CALayer()
			starLayer.contents = starImage.cgImage
			starLayer.frame = CGRect(origin: CGPoint(CGFloat(i) * starImage.size.width, 0), size: starImage.size)
			maskLayer.frame.size.width = starLayer.frame.right
			maskLayer.addSublayer(starLayer)
		}
		
		return maskLayer
	}
	
	
	private lazy var highlightLayer: CALayer = {
		let layer = CALayer()
		layer.backgroundColor = self.tintColor?.cgColor
		self.layer.addSublayer(layer)
		return layer
	}()
	
	
	
	private func gestureUpdateValue(_ value: Float) {
		self.value = value
		self.sendActions(for: .valueChanged)
	}
	
	private func gestureIsOutside(point: CGPoint) -> Bool {
		let frame = self.bounds
		let edgePoint = CGPoint(boundary(point.x, min: 0, max: frame.width), boundary(point.y, min: 0, max: frame.height))
		if point == edgePoint {
			return false
		}
		
		let distance = edgePoint.distance(to: point)
//		print(point, edgePoint, distance)
		return distance > 24
	}
	
	private func handleGesture(_ touch: UITouch) {
		let point = touch.location(in: self)
		guard !gestureIsOutside(point: point) else {
			return
		}
		
		let percent = point.x / self.bounds.width
		let value: Float = Float(percent) * Float(numberOfStars)
		gestureUpdateValue(value)
	}
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		handleGesture(touches.first!)
	}
	
	open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		handleGesture(touches.first!)
	}
	
	
	
	open override func layoutSubviews() {
		
		//TODO: Still animates height change...
		
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		highlightLayer.frame.size.height = maskLayer.frame.size.height
		CATransaction.commit()
		
		let percent = CGFloat(value) / CGFloat(numberOfStars)
		highlightLayer.frame.size.width = maskLayer.frame.size.width * percent
	}
}



public enum StarViewShapeSource {
	case image(UIImage)
	case starSize(CGFloat)
	case character(Character, CGFloat)
	
	
	private func imageFrom(character: Character, fontSize: CGFloat) -> UIImage? {
		let stringCharacter = NSString(string: String(character))
		let stringAttributes = [TextAttributes.font(UIFont.systemFont(ofSize: fontSize))].attributedDictionary
		let size = stringCharacter.size(withAttributes: stringAttributes)
		
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		defer { UIGraphicsEndImageContext() }
		NSString(string: String(character)).draw(at: .zero, withAttributes: stringAttributes)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	fileprivate var image: UIImage? {
		switch self {
			case let .image(image)					: return image
			case let .starSize(fontSize)			: return imageFrom(character: "\u{2605}", fontSize: fontSize)
			case let .character(character, fontSize): return imageFrom(character: character, fontSize: fontSize)
		}
	}
}
















