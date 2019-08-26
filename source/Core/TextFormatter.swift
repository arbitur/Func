//
//  TextFormatter.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public class TextFormatter {
	
	public static func percent(_ percent: Double, decimals: Int = 1) -> String {
		let f = NumberFormatter()
		f.numberStyle = .percent
		f.maximumFractionDigits = decimals
		return f.string(from: NSNumber(value: percent))!
	}
	
	
	
	public static func currency(_ amount: Double, currencyCode: CurrencyCode) -> String {
		let f = NumberFormatter()
		f.locale = Locale.current
		f.numberStyle = .currency
		f.maximumFractionDigits = (amount.remainder(dividingBy: 1) == 0) ? 0 : 2
		f.currencyCode = currencyCode.rawValue
		return f.string(from: NSNumber(value: amount))!
	}
	
	
	
	
	public static func timeComponents(_ time: Number, maximumComponents: Int = 1) -> String {
		let f = DateComponentsFormatter()
		f.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
		f.maximumUnitCount = maximumComponents
		f.allowsFractionalUnits = false
		f.collapsesLargestUnit = false
		f.unitsStyle = .full
		f.zeroFormattingBehavior = .dropAll
		return f.string(from: time.toDouble()) ?? "NaN"
	}
	
	
	
	@available(iOS, deprecated: 1.0, message: "This only works for very specific situations")
	public static func phoneNumber(_ phoneNumber: String) -> String {
		let p = phoneNumber.extracted(characters: CharacterSet.decimalDigits)
		
		let format: String
		switch p.count {
			case 1+9: format = "xxx-xxx xx xx"
			case 1+8: format = "xxxx-xxx xx"
			case 1+7: format = "xxx-xxx xx"
			default: return p
		}
		
		var formattedNumber = ""
		
		var index = 0
		for char in format.map({ String($0) }) {
			if char == "x" {
				formattedNumber += String(p[p.index(p.startIndex, offsetBy: index)])
				index += 1
			}
			else {
				formattedNumber += char
			}
		}
		
		return formattedNumber
	}
}







// https://www.iban.com/currency-codes.html
public struct CurrencyCode: RawRepresentable {
	public var rawValue: String
	
	public init(rawValue: String) {
		self.rawValue = rawValue
	}
	
	
	public static let sek: CurrencyCode = "SEK"
	public static let usd: CurrencyCode = "USD"
	public static let eur: CurrencyCode = "EUR"
}


extension CurrencyCode: ExpressibleByStringLiteral {
	
	public init(stringLiteral value: StringLiteralType) {
		self.init(rawValue: value)
	}
}









