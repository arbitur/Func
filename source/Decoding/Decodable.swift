//
//  FuncJSON.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Jul/17.
//
//

import Foundation





public protocol Decodable {
	
	init(json: Dict) throws
}

public protocol Encodable {
	
	func encoded() -> Dict
}


public protocol Codable: Decodable, Encodable {
}


//public enum DecodableError: Error {
//	case wrong
//}



private func getParse <T> (_ json: Dict, key: String) throws -> T {
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



private func decode <T> (_ json: Dict, _ key: String) throws -> T where T: Func.Decodable {
	let dict: Dict = try getParse(json, key: key)
	return try T(json: dict)
}

private func decode <T> (_ json: Dict, _ key: String) throws -> T where T: RangeReplaceableCollection, T.Element: Decodable {
	let dicts: [Dict] = try getParse(json, key: key)
	var arr: T = T()
	for dict in dicts {
		arr.append(try T.Element.init(json: dict))
	}
	return arr
}



private func decode <T> (_ json: Dict, _ key: String) throws -> T where T: RawRepresentable {
	let raw: T.RawValue = try getParse(json, key: key)
	guard let enumm = T(rawValue: raw) else {
		throw DecodingError.parseFailed(key: key, value: raw, valueType: T.self)
	}
	
	return enumm
}

private func decode <T> (_ json: Dict, _ key: String) throws -> T where T: RangeReplaceableCollection, T.Element: RawRepresentable {
	let raws: [T.Element.RawValue] = try getParse(json, key: key)
	var arr: T = T()
	for raw in raws {
		guard let element = T.Element.init(rawValue: raw) else {
			throw DecodingError.parseFailed(key: key, value: raw, valueType: T.Element.self)
		}
		arr.append(element)
	}
	return arr
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
	return strs.compactMap(URL.init)
}



private func decode(_ json: Dict, _ key: String, format: DateFormat = .dateTime) throws -> Date {
	let str: String = try getParse(json, key: key)
	guard let date = Date(str, format: format) else {
		throw DecodingError.dateFormat(key: key, value: str, format: format.rawValue)
	}
	return date
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
	
	public func decode <T> (_ key: String) throws -> T where T: RangeReplaceableCollection, T.Element: Decodable {
		return try Func.decode(self, key)
	}
	
	
	
	public func decode <T> (_ key: String) throws -> T where T: RawRepresentable {
		return try Func.decode(self, key)
	}
	
	public func decode <T> (_ key: String) throws -> T where T: RangeReplaceableCollection, T.Element: RawRepresentable {
		return try Func.decode(self, key)
	}
	
	
	
	public func decode (_ key: String) throws -> URL {
		return try Func.decode(self, key)
	}
	
	public func decode (_ key: String) throws -> [URL] {
		return try Func.decode(self, key)
	}
	
	
	
	public func decode (_ key: String, format: DateFormat = .dateTime) throws -> Date {
		return try Func.decode(self, key, format: format)
	}
	
}





public enum DecodingError: LocalizedError {
	case missingKey(key: String)
	case parseFailed(key: String, value: Any, valueType: Any.Type)
	case dateFormat(key: String, value: String, format: String)
	
	
	public var errorDescription: String? {
		switch self {
			case .missingKey(let key): return "\"\(key)\" does not exist"
			case .parseFailed(let key, let value, let type): return "Expected \"\(key)\" to be of type: \(type) but was \(Swift.type(of: value))"
			case .dateFormat(let key, let value, let format): return "Expected \"\(key)\" \(value) to be of format \(format)"
		}
	}
}














