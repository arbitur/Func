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
		var value: Any = self
		
		for part in (path as! String).components(separatedBy: separator) {
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




public typealias Dict = [String: Any]



public func += <T, U> (left: inout [T: U], right: [T: U]) {
	for (k, v) in right {
		left[k] = v
	}
}

public func + <T, U> (left: [T: U], right: [T: U]) -> [T: U] {
	var d = left
	d += right
	return d
}

public func == (lhs: Dict, rhs: Dict) -> Bool {
	return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

public func != (lhs: Dict, rhs: Dict) -> Bool {
	return !(lhs == rhs)
}

















