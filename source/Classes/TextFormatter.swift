//
//  TextFormatter.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public class TextFormatter {
	public static func format(sek: Double, digits: Int = 2) -> String {
		return String(format: "%.\(digits)f kr", sek)
	}
	
	public static func format(dollar: Double, digits: Int = 2) -> String {
		return String(format: "$%.\(digits)f", dollar)
	}
	
	
	
	public static func format(percent: Double, digits: Int = 1) -> String {
		return String(format: "%g %%", percent.shorten(decimals: 2))
	}
	
	
	
	public static func format(phoneNumber p: String) -> String {
		let p = p.extract(characters: CharacterSet.decimalDigits)
		
		var format: String
		switch p.characters.count {
		case 1+9: format = "xxx-xxx xx xx"
		case 1+8: format = "xxxx-xxx xx"
		case 1+7: format = "xxx-xxx xx"
		default: return p
		}
		
		var formattedNumber = ""
		
		var index = 0
		for char in format.characters.map({ String($0) }) {
			if char == "x" {
				formattedNumber += String(p.characters[p.index(p.startIndex, offsetBy: index)])
				index += 1
			}
			else {
				formattedNumber += char
			}
		}
		
		return formattedNumber
	}
}
