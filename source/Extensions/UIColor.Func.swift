//
//  UIColor.Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import UIKit





public extension UIColor {
	static var extraLightGray: UIColor	{ return UIColor(hex: 0xEEEEEE) }
	static var extraDarkGray: UIColor  	{ return UIColor(hex: 0x333333) }
	static var pink: UIColor      		{ return UIColor(hex: 0xFF69B4) }
	
	
	
	static var random: UIColor {
		let h: CGFloat = Random.range(min: 0, max: 360)
		let s: CGFloat = 0.25 + Random.range(min: 0.0, max: 0.75)
		let b: CGFloat = 0.25 + Random.range(min: 0.0, max: 0.75)
		return UIColor(hue: h, saturation: s, brightness: b, alpha: 1.0)
	}
	
	
	
	func alpha(_ alpha: CGFloat) -> UIColor {
		return self.withAlphaComponent(alpha)
	}
	
	/// -1.0...1.0
//	func brightness(_ change: CGFloat) -> UIColor {
//		let comp = self.cgColor.components!
//		var components = [comp[0], comp[1], comp[2]]
//		
//		for i in 0..<components.count {
//			let v = components[i] + change
//			
//			if v < 0 {
//				components[i] = 0
//			}
//			else if v > 1 {
//				components[i] = 1
//			}
//			else {
//				components[i] = v
//			}
//		}
//		
//		return UIColor(red: components[0], green: components[1], blue: components[2], alpha: comp[3])
//	}
	
	func lightened(by v: CGFloat) -> UIColor {
		let (h, s, l) = self.hsl
		let delta = 1.0 - l
		return UIColor(hue: h, saturation: s, lightness: l + delta * v, alpha: self.rgba.a)
	}
	
	func darkened(by v: CGFloat) -> UIColor {
		let (h, s, l) = self.hsl
		let delta = l
		return UIColor(hue: h, saturation: s, lightness: l - delta * v, alpha: self.rgba.a)
	}
	
	
	
	
	
	convenience init(hex: UInt, alpha: CGFloat = 1.0) {
		let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
		let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
		let blue = CGFloat((hex & 0xFF)) / 255.0
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
	
	
	
	convenience init(hue h: CGFloat, saturation s: CGFloat, lightness l: CGFloat, alpha: CGFloat) {
		let C = s * (1.0 - abs(l * 2.0 - 1.0))
		let H = h/60.0
		let X = C * (1.0 - abs(H.remainder(dividingBy: 2) - 1))
		let m = l - C / 2
		
		var rgb: (r: CGFloat, g: CGFloat, b: CGFloat)
		switch H {
		case 0..<1	: rgb = (C, X, 0)
		case 1..<2	: rgb = (X, C, 0)
		case 2..<3	: rgb = (0, C, X)
		case 3..<4	: rgb = (0, X, C)
		case 4..<5	: rgb = (X, 0, C)
		default		: rgb = (C, 0, X)
		}
		rgb.r += m
		rgb.g += m
		rgb.b += m
		
		self.init(red: rgb.r, green: rgb.g, blue: rgb.b, alpha: alpha)
	}
}


public extension UIColor {
	var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
		var (r, g, b, a) = (CGFloat(), CGFloat(), CGFloat(), CGFloat())
		getRed(&r, green: &g, blue: &b, alpha: &a)
		return (r, g, b, a)
	}
	
	var hsl: (h: CGFloat, s: CGFloat, l: CGFloat) {
		var (r, g, b, _) = self.rgba
		
		let min = Swift.min(r, g, b)
		let max = Swift.max(r, g, b)
		let delta = max - min
		
		var h: CGFloat
		switch true {
			case delta == 0	: h = 0
			case max == r	: h = ((g - b) / delta).remainder(dividingBy: 6)
			case max == g	: h = ((b - r) / delta) + 2.0
			case max == b	: h = ((r - g) / delta) + 4.0
			default			: fatalError()
		}
		h *= 60
		if h < 0 {
			h += 360
		}
		
		let l = (min + max) / 2
		
		let s: CGFloat
		switch true {
			case delta == 0	: s = 0
			default			: s = delta / (1.0 - abs(l * 2.0 - 1.0))
		}
		
		return (h, s, l)
	}
	
	var hsb: (h: CGFloat, s: CGFloat, l: CGFloat) {
		var (r, g, b, _) = self.rgba
		
		let min = Swift.min(r, g, b)
		let max = Swift.max(r, g, b)
		let delta = max - min
		
		var h: CGFloat
		switch true {
			case delta == 0	: h = 0
			case max == r	: h = ((g - b) / delta).remainder(dividingBy: 6)
			case max == g	: h = ((b - r) / delta) + 2.0
			case max == b	: h = ((r - g) / delta) + 4.0
			default			: fatalError()
		}
		h *= 60
		if h < 0 {
			h += 360
		}
		
		let v = max
		
		let s: CGFloat
		switch v {
			case 0.0: s = 0
			default	: s = delta / v
		}
		
		return (h, s, v)
	}
}






















