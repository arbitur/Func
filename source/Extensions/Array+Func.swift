//
//  Array+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public extension Array {
	var random: Element {
		return self[Random.range(0..<self.count)]
	}
	
	// Has to be in Array because only Array has the [index] subscript
	subscript (safe index: Int) -> Element? {
		if self.indices.contains(index) {
			return self[index]
		}
		return nil
	}
	
	
	
	func split() -> (first: [Element], last: [Element]) {
		let half = self.count/2
		return (Array(self[0..<half]), Array(self[half..<self.count]))
	}
	
	func split(arrayLimit nr: Int) -> [[Element]] {
		var arr: [[Element]] = (0..<nr).map { _ in [] }
		for (i, elem) in self.enumerated() { arr[i % nr].append(elem) }
		return arr
	}
	
	func split(elementLimit nr: Int) -> [[Element]] {
		return (0..<Int(ceil(Float(self.count)/Float(nr)))).map {
			let start = $0 * nr
			return Array(self[start..<Swift.min(start + nr, self.count)])
		}
	}
	
	
	/// Removes all from index
	mutating func remove(from index: Int) {
		let n = self.count - index
		self.removeLast(n)
	}
	
	/// Removes all to index
	mutating func remove(to n: Int) {
		self.removeFirst(n)
	}
}



public extension Collection where Iterator.Element: IntegerNumber {
	func sum() -> Iterator.Element? {
		if self.isEmpty { return nil }
		return self.reduce(Iterator.Element(0), +)
	}
}

public extension Collection where Iterator.Element: FloatingNumber {
	func sum() -> Iterator.Element {
		if self.isEmpty { return .nan }
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



public extension Array where Element: Equatable {
	@discardableResult
	mutating func remove(element: Element) -> Element? {
		guard let index = self.index(of: element) else { return nil }
		return self.remove(at: index)
	}
}



public extension Collection where Iterator.Element == String {
	func joined(by separator: String) -> String {
		return self.joined(separator: separator)
	}
}



public extension Array where Element: ExpressibleByDictionaryLiteral, Element.Key: Hashable {
	func merged() -> Dictionary<Element.Key, Element.Value> {
		var d = Dictionary<Element.Key, Element.Value>()
		for case let dd as Dictionary<Element.Key, Element.Value> in self {
			d += dd
		}
		return d
	}
}





infix operator ++=
infix operator --=

public func ++= <T>(left: inout [T], right: T) {
	left.append(right)
}

public func --= <T: Equatable>(left: inout [T], right: T) {
	left.remove(element: right)
}

/// Checks if obj exists in arr
public func ?== <T: Equatable>(obj: T, arr: [T]) -> Bool {
	return arr.contains(obj)
}


















