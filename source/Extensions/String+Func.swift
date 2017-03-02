//
//  String+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public extension String {
	var length: Int {
		return self.characters.count
	}
	
	var reversed: String {
		return self.characters.reversed().map({ String($0) }).joined()
	}
	
	
	
	func `default`(str: String) -> String {
		if self.isEmpty { return str }
		return self
	}
	
	
	
	func extracted(to index: Int) -> String {
		let i = self.index(self.startIndex, offsetBy: index)
		return self.substring(to: i)
	}
	
	func extracted(from index: Int) -> String {
		let i = self.index(self.startIndex, offsetBy: index)
		return self.substring(from: i)
	}
	
	func extract(characters: CharacterSet) -> String {
		return remove(characters: characters.inverted)
	}
	
	func remove(characters: CharacterSet) -> String {
		return self.components(separatedBy: characters).joined(separator: "")
	}
	
	
	
	subscript (range: Range<Int>) -> String {
		let start = index(startIndex, offsetBy: range.lowerBound)
		let end = index(startIndex, offsetBy: range.upperBound)
		return self.substring(with: start..<end)
	}
	
	subscript (_ i: Int) -> Character {
		return Array(self.characters)[i]
	}
	
	
	
	func replaced(_ str: String, with rep: String) -> String {
		return self.replacingOccurrences(of: str, with: rep, options: [], range: nil)
	}
	
	mutating func replace(_ str: String, with rep: String) -> Bool {
		let temp = self
		self = self.replaced(str, with: rep)
		return temp != self
	}
	
	
	
	func split(_ str: String) -> [String] {
		return self.components(separatedBy: str)
	}
	
	
	
	func group(separator: String, size: Int) -> String {
		var holder = [String]()
		for (i, char) in self.characters.enumerated() {
			let index = (i) / size
			if i % size == 0 { holder ++= String() }
			holder[index] += String(char)
		}
		
		return holder.joined(separator: separator)
	}
	
	
	
	func size(for width: CGFloat, font: UIFont) -> CGSize {
		let attr = [NSFontAttributeName: font]
		let height = self.boundingRect(with: CGSize(width, CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attr, context: nil).height
		return CGSize(width, ceil(height))
	}
	
	
	
	func base64Encoded() -> String? {
		let data = self.data(using: .utf8)
		return data?.base64EncodedString()
	}
	
	func base64Decoded() -> String? {
		let data = Data(base64Encoded: self)
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
		let data = Data(base64Encoded: str)
		return String(data)
	}
	
	init?(_ data: Data?) {
		guard let data = data else { return nil }
		self.init(data: data, encoding: .utf8)
	}
}





public struct StringIndex {
	private var string: String
	var index: String.Index
	
	
	
	func successing() -> String.Index {
		return string.index(after: index)
	}
	
	mutating func predecessing() -> String.Index {
		return string.index(before: index)
	}
	
	func advance(_ offset: Int) -> String.Index {
		return string.index(index, offsetBy: offset, limitedBy: string.endIndex)!
	}
	
	
	init(stringStart string: String) {
		self.string = string
		self.index = string.startIndex
	}
	
	init(stringEnd string: String) {
		self.string = string
		self.index = string.endIndex
	}
	
	init(string: String, index: String.Index) {
		self.string = string
		self.index = index
	}
}






public func ?== (s1: String, s2: String) -> Bool {
	return s1.contains(s2)
}





public func + (lhs: String, rhs: String?) -> String {
	if let rhs = rhs {
		return lhs + rhs
	}
	
	return lhs
}























