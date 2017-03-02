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
	static var random: UIColor			{ return .random() }
	
	
	
	static func random(printHex: Bool = false) -> UIColor {
		let randomNumber: UInt = Random.range(0x0..<0xffffff)
		if printHex { print("Random color hex: 0x" + String(format: "%06X", randomNumber)) }
		return UIColor(hex: randomNumber, alpha: 1.0)
	}

	
	
	func alpha(_ alpha: CGFloat) -> UIColor {
		return self.withAlphaComponent(alpha)
	}
	
	/// -1.0...1.0
	func brightness(_ change: CGFloat) -> UIColor {
		let comp = self.cgColor.components!
		var components = [comp[0], comp[1], comp[2]]
		
		for i in 0..<components.count {
			let v = components[i] + change
			
			if v < 0 {
				components[i] = 0
			}
			else if v > 1 {
				components[i] = 1
			}
			else {
				components[i] = v
			}
		}
		
		return UIColor(red: components[0], green: components[1], blue: components[2], alpha: comp[3])
	}
	
	
	
	convenience init(hex: UInt, alpha: CGFloat = 1.0) {
		let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
		let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
		let blue = CGFloat((hex & 0xFF)) / 255.0
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
}






















