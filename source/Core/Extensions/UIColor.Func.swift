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
	static var lightBlack: UIColor		{ return UIColor(hex: 0x282828) }
	static var pink: UIColor      		{ return UIColor(hex: 0xFF69B4) }
	
	
	
	static var random: UIColor {
		let h: CGFloat = Random.range(min: 0.0, max: 1.0)
		let s: CGFloat = 0.25 + Random.range(min: 0.0, max: 0.75)
		let b: CGFloat = 0.25 + Random.range(min: 0.0, max: 0.75)
		return UIColor(hue: h, saturation: s, brightness: b, alpha: 1.0)
	}
	
	
	
	func alpha(_ alpha: CGFloat) -> UIColor {
		return self.withAlphaComponent(alpha)
	}
	
	func lightened(by v: CGFloat) -> UIColor {
		let (h, s, l, a) = self.hsla
		let delta = 1.0 - l
		return UIColor(hue: h, saturation: s, lightness: l + delta * v, alpha: a)
	}
	
	func darkened(by v: CGFloat) -> UIColor {
		let (h, s, l, a) = self.hsla
		let delta = l
		return UIColor(hue: h, saturation: s, lightness: l - delta * v, alpha: a)
	}
	
	
	
	
	
	convenience init(hex: UInt, alpha: CGFloat = 1.0) {
		let red   = CGFloat( (hex >> 16) & 0xff ) / 255
		let green = CGFloat( (hex >> 8)  & 0xff ) / 255
		let blue  = CGFloat( (hex >> 0)  & 0xff ) / 255
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
	
	
	/// All parameters range 0...1
	convenience init(hue h: CGFloat, saturation s: CGFloat, lightness l: CGFloat, alpha: CGFloat) {
		let r: CGFloat
		let g: CGFloat
		let b: CGFloat
		
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

		self.init(red: r, green: g, blue: b, alpha: alpha)
	}
}


public extension UIColor {
	
	var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
		var (r, g, b, a) = (CGFloat(), CGFloat(), CGFloat(), CGFloat())
		getRed(&r, green: &g, blue: &b, alpha: &a)
		return (r, g, b, a)
	}
	
	var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
		var (h, s, b, a) = (CGFloat(), CGFloat(), CGFloat(), CGFloat())
		getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		return (h, s, b, a)
	}
	
	var hsla: (h: CGFloat, s: CGFloat, l: CGFloat, a: CGFloat) {
		var (h, s, b, a) = hsba
		
		let l = (2 - s) * b / 2;
		
		if (l > 0) {
			switch true {
				case l < 0.5: s = s * b / (l * 2)
				case l < 1.0: s = s * b / (2 - l * 2)
				default		: s = 0
			}
		}
		
		return (h, s, l, a)
	}
}






















