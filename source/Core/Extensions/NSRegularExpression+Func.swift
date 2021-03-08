//
//  NSRegularExpression+Func.swift
//  Func
//
//  Created by Philip Fryklund on 2021-03-03.
//

import Foundation


public extension NSRegularExpression {
	
	convenience init(pattern: String) {
		try! self.init(pattern: pattern, options: [])
	}
	
	func matches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> [RegexMatch] {
		let range = range ?? string.startIndex..<string.endIndex
		let nsRange = NSRange(range, in: string)
		return self.matches(in: string, options: options, range: nsRange).map { .init(inputString: string, nsResult: $0) }
	}

	func numberOfMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> Int {
		let range = range ?? string.startIndex..<string.endIndex
		let nsRange = NSRange(range, in: string)
		return self.numberOfMatches(in: string, options: options, range: nsRange)
	}

	func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> RegexMatch? {
		let range = range ?? string.startIndex..<string.endIndex
		let nsRange = NSRange(range, in: string)
		return self.firstMatch(in: string, options: options, range: nsRange).map { .init(inputString: string, nsResult: $0) }
	}

	func rangeOfFirstMatch(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> Range<String.Index> {
		let range = range ?? string.startIndex..<string.endIndex
		let nsRange = NSRange(range, in: string)
		return Range(self.rangeOfFirstMatch(in: string, options: options, range: nsRange), in: string)!
	}
}


public struct RegexMatch {
	
	internal let inputString: String
	internal let nsResult: NSTextCheckingResult
	
	
	private func substring(in nsRange: NSRange) -> String.SubSequence {
		let range = Range(nsRange, in: inputString)!
		return inputString[range]
	}
	
	public func string() -> String.SubSequence {
		let nsRange = nsResult.range
		return substring(in: nsRange)
	}
	
	/// Get string at capture group `index` asserting there exists one at that index.
	public func string(at index: Int) -> String.SubSequence {
		let nsRange = nsResult.range(at: index + 1)
		return substring(in: nsRange)
	}
	
	@available(iOS 11.0, *)
	public func string(forKey key: String) -> String.SubSequence {
		let nsRange = nsResult.range(withName: key)
		return substring(in: nsRange)
	}
}
