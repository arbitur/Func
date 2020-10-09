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
	
	
	@inlinable func forEachIndexed(_ body: (Self.Index, Self.Element) throws -> Void) rethrows {
		for i in self.indices {
			try body(i, self[i])
		}
	}
	
	
	/// Returns `nil` if `Element` doesn't exist at `index`
	subscript (safe index: Index) -> Element? {
		guard self.indices.contains(index) else {
			return nil
		}
		return self[index]
	}
}



public extension Collection where Index == Int {
	
	//* Returns random `Iterator.Element`
	/* Returns nil if collection is empty
	*/
	var random: Iterator.Element? {
		return self.randomElement()
	}
	
	
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
			let end = clamp(start + count, max: self.count)
			return self[start..<end]
		}
	}
}



public extension Collection where Element: Collection, Index == Int, Element.Index == Self.Index {
	
	subscript(indexPath: IndexPath) -> Element.Element? {
		guard let s = self[safe: indexPath.section], let element = s[safe: indexPath.row] else {
			return nil
		}
		return element
	}
}



public extension RangeReplaceableCollection where Index == Int {
	
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



public extension RangeReplaceableCollection where Element: UIView {
	
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
		guard let index = self.firstIndex(of: element) else {
			return nil
		}
		return self[safe: index - 1]
	}

	func element(after element: Iterator.Element) -> Iterator.Element? {
		guard let index = self.firstIndex(of: element) else {
			return nil
		}
		return self[safe: index + 1]
	}
	
}



public extension RangeReplaceableCollection where Iterator.Element: Equatable {
	
	@discardableResult
	mutating func remove(element: Iterator.Element) -> Iterator.Element? {
		guard let index = self.firstIndex(of: element) else {
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



public extension Sequence {
	
	func grouped <T: Hashable> (by keyClosure: (Element) -> (T)) -> [[Element]] {
		var grouper = [[Element]]()
		for element in self {
			let key = keyClosure(element)
			if let index = grouper.firstIndex(where: { keyClosure($0.first!) == key }) {
				grouper[index].append(element)
			}
			else {
				grouper.append([element])
			}
		}
		return grouper
//		var grouper = [T: [Element]]()
//		for element in self {
//			let key = keyClosure(element)
//			if grouper.keys.contains(key) {
//				grouper[key]?.append(element)
//			}
//			else {
//				grouper[key] = [element]
//			}
//		}
//		return grouper
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


















