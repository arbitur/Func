//
//  Dictionary+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public extension Dictionary {
	
	var key: Key { return self.keys.first! }
	var value: Value { return self.values.first! }
	
	
	
	subscript(index: Int) -> Element? {
		if let key = Array(self.keys)[safe: index] {
			return (key, self[key]!)
		}
		return nil
	}
	
	
	func merged(with: [Key: Value]) -> [Key: Value] {
		var d = self
		d.merge(with: with)
		return d
	}
	
	
	mutating func merge(with: [Key: Value]) {
		for (k, v) in with {
			self[k] = v
		}
	}
}


public extension Dictionary where Key == String {
	
	func valueFor <T> (path: String, separator: String = ".") -> T? {
		var value: Any = self
		
		for part in path.split(separator) {
			if let dict = value as? Dict, let v = dict[part] {
				value = v
			}
			else if let arr = value as? [Any], let index = Int(part), let v = arr[safe: index] {
				value = v
			}
			else {
				return nil
			}
		}
		
		return value as? T
	}
}

//extension Dictionary: Equatable {
//	
//	public static func == (lhs: [Key: Value], rhs: [Key: Value]) -> Bool {
//		return NSDictionary(dictionary: lhs).isEqual(to: rhs)
//	}
//	
//	public static func != (lhs: [Key: Value], rhs: [Key: Value]) -> Bool {
//		return !(lhs == rhs)
//	}
//}





public func + <T, U>(lhs: [T: U], rhs: [T: U]) -> [T: U] {
	return lhs.merged(with: rhs)
}

public func += <T, U>(lhs: inout [T: U], rhs: [T: U]) {
	lhs.merge(with: rhs)
}





















