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
	
	
	
	mutating func remove(from index: Int) {
		let n = self.count - index
		self.removeLast(n)
	}
	
	mutating func remove(to n: Int) {
		self.removeFirst(n)
	}
}



public extension Array where Element: IntegerNumber {
	func sum() -> Element? {
		if self.isEmpty { return nil }
		
		var sum = Element(0)
		self.forEach {
			sum = sum + $0
		}
		
		return sum
	}
}

public extension Array where Element: FloatingNumber {
	func sum() -> Element {
		if self.isEmpty { return .nan }
		
		var sum = Element(0)
		self.forEach {
			sum = sum + $0
		}
		
		return sum
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



public extension Array where Element == String {
	func joined(by separator: String) -> String {
		return self.joined(separator: separator)
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

public func ?== <T: Equatable>(obj: T, arr: [T]) -> Bool {
	return arr.contains(obj)
}


















