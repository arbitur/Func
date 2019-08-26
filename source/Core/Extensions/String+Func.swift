//
//  String+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public extension String {
	
	var nsRange: NSRange {
		return NSRange(location: self.startIndex.utf16Offset(in: self), length: self.endIndex.utf16Offset(in: self))
	}
	
	var reversed: String {
		return String(self.reversed())
	}
	
	var capitalizedFirst: String {
		return self.prefix(1).uppercased() + self.lowercased().dropFirst()
	}
	
	
	
	func ifEmpty(_ str: String) -> String {
		return self.isEmpty ? str : self
	}
	
	
	
	func extracted(to index: Int) -> String {
		let i = self.index(self.startIndex, offsetBy: index)
		return String(self[..<i])
	}
	
	func extracted(from index: Int) -> String {
		let i = self.index(self.startIndex, offsetBy: index)
		return String(self[i...])
	}
	
	/// Remove all characters except characters in `characters`
	func extracted(characters: CharacterSet) -> String {
		return removed(characters: characters.inverted)
	}
	
	/// Remove characters in `characters`
	func removed(characters: CharacterSet) -> String {
		return self.components(separatedBy: characters).joined(separator: "")
	}
	
	func replaced(_ str: String, with rep: String) -> String {
		return self.replacingOccurrences(of: str, with: rep, options: [], range: nil)
	}
	
	func replaced(regex pattern: String, with rep: String) -> String {
		var str = self
		str.replace(regex: pattern, with: rep)
		return str
	}
	
	@discardableResult
	mutating func replace(_ str: String, with rep: String) -> Bool {
		let temp = self
		self = self.replaced(str, with: rep)
		return temp != self
	}
	
	@discardableResult
	mutating func replace(regex pattern: String, with rep: String) -> Bool {
		guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
			return false
		}
		
		let mutableString = NSMutableString(string: self)
		defer {
			self = mutableString as String
		}
		return regex.replaceMatches(in: mutableString, options: [], range: self.nsRange, withTemplate: rep) > 0
	}
	
	
	func percentEncoding(for characters: CharacterSet) -> String? {
		return self.addingPercentEncoding(withAllowedCharacters: characters.inverted)
	}
	
	func percentEncoding(except characters: CharacterSet) -> String? {
		return self.addingPercentEncoding(withAllowedCharacters: characters)
	}
	
	
	
	func matches(regex pattern: String) -> Bool {
		let regex = try! NSRegularExpression(pattern: pattern, options: [])
		return regex.firstMatch(in: self, options: [], range: self.nsRange) != nil
	}
	
	
	
	/**
		Substrings from lowerBound up to upperBound
	
			"123456789"[0...5] = "12345"
	
			"123456789"
			^^   ^^
			0    5
	*/
	subscript (range: ClosedRange<Int>) -> String {
		let start = self.index(self.startIndex, offsetBy: range.lowerBound)
		let end = self.index(self.startIndex, offsetBy: range.upperBound)
		return String(self[start..<end])
	}
	
	subscript (range: PartialRangeFrom<Int>) -> String {
		let start = self.index(self.startIndex, offsetBy: range.lowerBound)
		return String(self[start...])
	}
	
	subscript (range: PartialRangeThrough<Int>) -> String {
		let end = self.index(self.startIndex, offsetBy: range.upperBound)
		return String(self[..<end])
	}
	
	
	
	
	
	func split(_ str: String) -> [String] {
		return self.components(separatedBy: str)
	}
	
	
	/// Trims off leading and trailing white space
	func trimmed() -> String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	
	
	func grouped(size: Int) -> [String] {
		var holder = [String]()
		for (i, char) in self.enumerated() {
			let index = (i) / size
			if i % size == 0 { holder ++= String() }
			holder[index].append(char)
		}
		
		return holder
	}
	
	
	
	func size(for width: CGFloat, font: UIFont) -> CGSize {
		let height = self.boundingRect(with: CGSize(width, .max), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
		return CGSize(width, ceil(height))
	}
	
	
	
	func base64Encoded() -> String? {
		let data = self.data(using: .utf8)
		return data?.base64EncodedString()
	}
	
	func base64Decoded() -> String? {
		guard let data = Data(base64Encoded: self) else {
			return nil
		}
		
		return String(data)
	}
	
	func base64URLEncoded() -> String? {
		let data = self.data(using: .utf8)
		let str = data?.base64EncodedString(options: .endLineWithLineFeed)
			.replaced("+", with: "-1")
			.replaced("/", with: "-2")
			.replaced("=", with: "-3")
		return str
	}
	
	func base64URLDecoded() -> String? {
		let str = self.replaced("-1", with: "+").replaced("-2", with: "/").replaced("-3", with: "=")
		guard let data = Data(base64Encoded: str) else {
			return nil
		}
		
		return String(data)
	}
	
	
	init?(_ data: Data) {
		self.init(data: data, encoding: .utf8)
	}
}






public extension String {
	
	func replacingCharacters(in nsRange: NSRange, with replacement: String) -> String? {
		guard let range = Range.init(nsRange, in: self) else {
			return nil
		}
		return self.replacingCharacters(in: range, with: replacement)
	}
}





/// Left exists inside right
public func ?== (lhs: String, rhs: String) -> Bool {
	return rhs.contains(lhs)
}





public func + (lhs: String, rhs: String?) -> String {
	guard let rhs = rhs else {
		return lhs
	}
	return lhs + rhs
}



public func % (lhs: String, rhs: CVarArg) -> String {
	return String.init(format: lhs, rhs)
}

public func % (lhs: String, rhs: [CVarArg]) -> String {
	return String.init(format: lhs, arguments: rhs)
}




















