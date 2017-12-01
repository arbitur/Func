//
//  UIFont+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UIFont {
	
	/// Just for debugging custom fonts
	static func print() {
		let families = UIFont.familyNames.sorted()
		
		for family in families {
			Swift.print(family)
			
			let children = UIFont.fontNames(forFamilyName: family)
			
			for child in children {
				Swift.print("\t" + child)
			}
		}
	}
}







public protocol FontBuildable: RawRepresentable {
	var rawValue: String { get }
	init?(rawValue: String)
}

public extension FontBuildable {
	
	var fontName: String { return "\(type(of: self))" + self.rawValue }
	
	func size(_ size: CGFloat) -> UIFont {
		return UIFont(name: fontName, size: size)!
	}
}





public extension UIFont {
	
	enum Arial: String, FontBuildable {
		case regular = "MT"
		case bold = "-BoldMT"
	}
	
	enum Avenir: String, FontBuildable {
		case book = "-Book"
		case black = "-Black"
		case heavy = "-Heavy"
		case italic = "-Oblique"
		case light = "-Light"
		case medium = "-Medium"
		case roman = "-Roman"
	}
	
	enum HelveticaNeue: String, FontBuildable {
		case regular = ""
		case bold = "-Bold"
		case light = "-Light"
		case medium = "-Medium"
		case thin = "-Thin"
		case ultraLight = "-UltraLight"
	}
	
	enum Verdana: String, FontBuildable {
		case regular = ""
		case bold = "-Bold"
	}
}



















