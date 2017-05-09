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
	
	func lightened(by v: CGFloat) -> UIColor {
		let (h, s, l) = self.hsl
		let delta = 1.0 - l
		return UIColor(hue: h/360, saturation: s, lightness: l + delta * v, alpha: self.rgba.a)
	}
	
	func darkened(by v: CGFloat) -> UIColor {
		defer {print()}
		let (h, s, l) = self.hsl
		let delta = l
		return UIColor(hue: h/360, saturation: s, lightness: l - delta * v, alpha: self.rgba.a)
	}
	
	
	
	
	
	convenience init(hex: UInt, alpha: CGFloat = 1.0) {
		let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
		let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
		let blue = CGFloat((hex & 0xFF)) / 255.0
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
	
	
	/// All parameters range 0...1
	convenience init(hue h: CGFloat, saturation s: CGFloat, lightness l: CGFloat, alpha: CGFloat) {
		var r: CGFloat = 0.0
		var g: CGFloat = 0.0
		var b: CGFloat = 0.0
		
		if s == 0.0 {
			r = l
			g = l
			b = l
		}
		else {
			func hueToRGB(p: CGFloat, q: CGFloat, t: CGFloat) -> CGFloat {
				var t = t
				if t < 0 { t += 1 }
				if t > 1 { t -= 1 }
				switch true {
					case t < 1/6: return p + (q - p) * 6 * t
					case t < 1/2: return q
					case t < 2/3: let fuckingApple = (2/3 - t); return  p + (q - p) * fuckingApple * 6
					default		: return p
				}
			}
			
			let q = (l < 0.5) ? (l * (1 + s)) : (l + s - l*s)
			let p = 2 * l - q
			r = hueToRGB(p: p, q: q, t: h + 1/3)
			g = hueToRGB(p: p, q: q, t: h)
			b = hueToRGB(p: p, q: q, t: h - 1/3)
		}
		print(r,g,b,alpha)
		self.init(red: r, green: g, blue: b, alpha: alpha)
	}
}


public extension UIColor {
	var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
		var (r, g, b, a) = (CGFloat(), CGFloat(), CGFloat(), CGFloat())
		getRed(&r, green: &g, blue: &b, alpha: &a)
		return (r, g, b, a)
	}
	
	var hsl: (h: CGFloat, s: CGFloat, l: CGFloat) {
		let (r, g, b, _) = self.rgba
		
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
		let (r, g, b, _) = self.rgba
		
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






















