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
	
	subscript(index: Int) -> (key: Key, value: Value)? {
		if let key = Array(self.keys)[safe: index] {
			return (key, self[key]!)
		}
		return nil
	}
}


public extension Dictionary where Key: ExpressibleByStringLiteral {
	func keyPath<T>(path: Key, separator: String = ".") -> T? {
		let path = path as! String
		var value: Any = self
		
		for part in path.components(separatedBy: separator) {
			if let dict = value as? [String: Any], let v = dict[part] {
				value = v
			}
			else if let array = value as? [Any], let index = Int(part) {
				value = array[index]
			}
			else {
				break//TODO: Migh be dangerous
			}
		}
		
		return value as? T
	}
}

extension Dictionary: Equatable {
	public static func == (lhs: [Key: Value], rhs: [Key: Value]) -> Bool {
		return NSDictionary(dictionary: lhs).isEqual(to: rhs)
	}
	
	public static func != (lhs: [Key: Value], rhs: [Key: Value]) -> Bool {
		return !(lhs == rhs)
	}
}




public typealias Dict = [String: Any]



public func + <T, U>(lhs: [T: U], rhs: [T: U]) -> [T: U] {
	var d = lhs
	for (k, v) in rhs {
		d[k] = v
	}
	return d
}

public func += <T, U>(lhs: inout [T: U], rhs: [T: U]) {
	lhs = lhs + rhs
}





















