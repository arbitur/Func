//
//  Array+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public extension Collection {
	
	var isNotEmpty: Bool {
		return !self.isEmpty
	}
}



public extension Collection where Index == Int {
	
	/// Returns random `Iterator.Element`
	var random: Iterator.Element {
		let index = Random.range(0..<self.count)
		return self[index]
	}
}



public extension RangeReplaceableCollection where Index == Int {
	
	/// Splits `Self` in half
	func split() -> (first: SubSequence, last: SubSequence) {
		let half = Index(round(Float(self.count)/2))
		return (self[0..<half], self[half..<self.count])
	}
	
	/**
		Splits `Self` into `count` amount of `Self`

			[1, 2, 3, 4, 5, 6, 7].split(arrays: 2) ==
			[
				[1, 2, 3, 4],
				[5, 6, 7]
			]
	*/
	func split(arrays count: Int) -> [SubSequence] {
		var start = 0
		return (0..<count).map { i in
			let end = Int(ceil(Float(self.count - start) / Float(count - i)))
			let seq = self[start..<start + end]
			start += end
			return seq
		}
	}
	
	/**
		Splits `Self` into `Self`'s each with maximum of `count` elements
	
			[1, 2, 3, 4, 5, 6, 7].split(capacity: 3) ==
			[
				[1, 2, 3],
				[4, 5, 6],
				[7]
			]
	*/
	func split(capacity count: Int) -> [SubSequence] {
		let arrays = Int(ceil(Float(self.count) / Float(count)))
		return (0..<arrays).map { i in
			let start = count * i
			let end = boundary(start + count, max: self.count)
			return self[start..<end]
		}
	}
	
	
	/** 
		Removes all elements to index `index`
		
			[1, 2, 3, 4, 5].remove(to: 2) ==
			[3, 4, 5]
	*/
	mutating func remove(to index: Int) {
		self.removeFirst(index)
	}
	
	/**
		Removes all elements from index `index`
	
		[1, 2, 3, 4, 5].remove(from: 2) ==
		[1, 2]
	*/
	mutating func remove(from index: Int) {
		self.removeSubrange(index..<self.count)
	}
}



public extension MutableCollection {
	
	/// Returns `nil` if `Element` doesn't exist at `index`
	subscript (safe index: Index) -> Iterator.Element? {
		guard self.indices.contains(index) else {
			return nil
		}
		return self[index]
	}
}



public extension Collection where Iterator.Element: IntegerNumber {
	
	func sum() -> Iterator.Element? {
		guard self.isNotEmpty else {
			return nil
		}
		return self.reduce(Iterator.Element(0), +)
	}
}

public extension Collection where Iterator.Element: FloatingNumber {
	
	func sum() -> Iterator.Element {
		guard self.isNotEmpty else {
			return .nan
		}
		return self.reduce(Iterator.Element(0), +)
	}
}



public extension Array where Element: UIView {
	
	/// Removes from superview and array
	mutating func removeFromSuperview() {
		for v in self {
			v.removeFromSuperview()
		}
		self.removeAll()
	}
}



public extension MutableCollection where Iterator.Element: Equatable, Index == Int {
	
	func element(before element: Iterator.Element) -> Iterator.Element? {
		guard let index = self.index(of: element) else {
			return nil
		}
		return self[safe: index - 1]
	}

	func element(after element: Iterator.Element) -> Iterator.Element? {
		guard let index = self.index(of: element) else {
			return nil
		}
		return self[safe: index + 1]
	}
	
}



public extension RangeReplaceableCollection where Iterator.Element: Equatable {
	
	@discardableResult
	mutating func remove(element: Iterator.Element) -> Iterator.Element? {
		guard let index = self.index(of: element) else {
			return nil
		}
		return self.remove(at: index)
	}
}



public extension Sequence where Iterator.Element == String {
	
	func joined(by separator: Iterator.Element) -> Iterator.Element {
		return self.joined(separator: separator)
	}
}



//TODO: Kinda weirdly done, consider redoing it...
public extension Array where Iterator.Element: ExpressibleByDictionaryLiteral & DictionaryMergable {
	
	/// Merges Dictionaries
	func merged() -> Iterator.Element {
		var merged: Iterator.Element = [:]
		for dictionary in self {
			dictionary.DictionaryMergableMerge(with: &merged)
		}
		return merged
	}
}

public protocol DictionaryMergable {
	/// Capitalized to not accidentally use it, bad practice but hey...
	func DictionaryMergableMerge(with: inout Self)
}

extension Dictionary: DictionaryMergable {
	public func DictionaryMergableMerge(with: inout [Key: Value]) {
		with.merge(with: self)
	}
}





infix operator ++=
infix operator --=

public func ++= <T> (left: inout T, right: T.Iterator.Element) where T: RangeReplaceableCollection {
	left.append(right)
}

public func --= <T> (left: inout T, right: T.Iterator.Element) where T: RangeReplaceableCollection, T.Iterator.Element: Equatable {
	left.remove(element: right)
}

/// Checks if left exists in right
public func ?== <T> (left: T.Iterator.Element, right: T) -> Bool where T: Sequence, T.Iterator.Element: Equatable {
	return right.contains(left)
}


















