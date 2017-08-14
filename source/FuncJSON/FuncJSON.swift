//
//  FuncJSON.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Jul/17.
//
//

import Foundation





public protocol Decodable {
	init?(json: Dict)
}



private func getParse<T>(_ json: Dict, key: String) throws -> T {
	guard let value: Any = json.valueFor(path: key) else {
		throw DecodingError.missingKey(key: key)
	}
	
	guard let parsed = value as? T else {
		throw DecodingError.parseFailed(key: key, value: value, valueType: T.self)
	}
	
	return parsed
}





private func decode <T> (_ json: Dict, _ key: String) throws -> T {
	return try getParse(json, key: key)
}

//private func decode <T> (_ json: Dict, _ key: String) throws -> [T] {
//	return try getParse(json, key: key)
//}



private func decode <T> (_ json: Dict, _ key: String) throws -> T where T: Decodable {
	let dict: Dict = try getParse(json, key: key)
	guard let decodable = T(json: dict) else {
		throw DecodingError.parseFailed(key: key, value: dict, valueType: T.self)
	}
	
	return decodable
}

private func decode <T> (_ json: Dict, _ key: String) throws -> [T] where T: Decodable {
	let dict: [Dict] = try getParse(json, key: key)
	return dict.flatMap(T.init)
}



private func decode <T> (_ json: Dict, _ key: String) throws -> T where T: RawRepresentable {
	let raw: T.RawValue = try getParse(json, key: key)
	guard let enumm = T(rawValue: raw) else {
		throw DecodingError.parseFailed(key: key, value: raw, valueType: T.self)
	}
	
	return enumm
}

private func decode <T> (_ json: Dict, _ key: String) throws -> [T] where T: RawRepresentable {
	let raws: [T.RawValue] = try getParse(json, key: key)
	return raws.flatMap(T.init)
}



private func decode(_ json: Dict, _ key: String) throws -> URL {
	let str: String = try getParse(json, key: key)
	guard let url: URL = URL(string: str) else {
		throw DecodingError.parseFailed(key: key, value: str, valueType: URL.self)
	}
	return url
}

private func decode(_ json: Dict, _ key: String) throws -> [URL] {
	let strs: [String] = try getParse(json, key: key)
	return strs.flatMap(URL.init)
}



private func decode(_ json: Dict, _ key: String, format: Date.Format = .dateTime) throws -> Date {
	let str: String = try getParse(json, key: key)
	guard let date = Date(str, format: format) else {
		throw DecodingError.dateFormat(key: key, value: str, format: format.format)
	}
	return date
}










infix operator <--



public func <-- <T> (json: Dict, key: String) throws -> T {
	return try decode(json, key)
}

//public func <-- <T> (json: Dict, key: String) throws -> [T] {
//	return try decode(json, key)
//}



public func <-- <T> (json: Dict, key: String) throws -> T where T: Decodable {
	return try decode(json, key)
}

public func <-- <T> (json: Dict, key: String) throws -> [T] where T: Decodable {
	return try decode(json, key)
}



public func <-- <T> (json: Dict, key: String) throws -> T where T: RawRepresentable {
	return try decode(json, key)
}

public func <-- <T> (json: Dict, key: String) throws -> [T] where T: RawRepresentable {
	return try decode(json, key)
}



public func <-- (json: Dict, key: String) throws -> URL {
	return try decode(json, key)
}

public func <-- (json: Dict, key: String) throws -> [URL] {
	return try decode(json, key)
}





public extension Dictionary where Key == String {
	
	public func decode <T> (_ key: String) throws -> T {
		return try Func.decode(self, key)
	}
	
//	public func decode <T> (json: Dict, key: String) throws -> [T] {
//		return try Func.decode(self, key)
//	}
	
	
	
	public func decode <T> (_ key: String) throws -> T where T: Decodable {
		return try Func.decode(self, key)
	}
	
	public func decode <T> (_ key: String) throws -> [T] where T: Decodable {
		return try Func.decode(self, key)
	}
	
	
	
	public func decode <T> (_ key: String) throws -> T where T: RawRepresentable {
		return try Func.decode(self, key)
	}
	
	public func decode <T> (_ key: String) throws -> [T] where T: RawRepresentable {
		return try Func.decode(self, key)
	}
	
	
	
	public func decode (_ key: String) throws -> URL {
		return try Func.decode(self, key)
	}
	
	public func decode (_ key: String) throws -> [URL] {
		return try Func.decode(self, key)
	}
	
	
	
	public func decode (_ key: String, format: Date.Format = .dateTime) throws -> Date {
		return try Func.decode(self, key, format: format)
	}
	
}




//public extension Dictionary where Key == String {
//	private static func getValue(json: Dict, key: String) throws -> Any {
//		guard let value = json[key] else {
//			throw DecodingError.missingKey(key)
//		}
//		
//		return value
//	}
//	
//	private static func parse<T>(_ value: Any, key: String) throws -> T {
//		guard let parsed = value as? T else {
//			throw DecodingError.parseFailed(key, value, T.self)
//		}
//		
//		return parsed
//	}
//	
//	
//	func decode<T>(_ key: String) throws -> T {
//		let value = try Dictionary.getValue(json: self, key: key)
//		return try Dictionary.parse(value, key: key)
//	}
//	
//	func decode<T: Decodable>(_ key: String) throws -> T {
//		let v = try Dictionary.getValue(json: self, key: key)
//		let dict: Dict = try Dictionary.parse(v, key: key)
//		
//		guard let decodable = T(json: dict) else {
//			throw DecodingError.parseFailed(key, dict, T.self)
//		}
//		
//		return decodable
//	}
//}




public enum DecodingError: LocalizedError {
	case missingKey(key: String)
	case parseFailed(key: String, value: Any, valueType: Any.Type)
	case dateFormat(key: String, value: String, format: String)
	
	
	public var errorDescription: String? {
		switch self {
			case .missingKey(let key): return "\"\(key)\" does not exist"
			case .parseFailed(let key, let value, let type): return "Expected \"\(key)\" to be of type: \(type) but was \(type(of: value))"
			case .dateFormat(let key, let value, let format): return "Expected \"\(key)\" \(value) to be of format \(format)"
		}
	}
}














