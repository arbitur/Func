//
//  FuncJSON.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Jul/17.
//
//

import Foundation




// MARK: - Protocols

public typealias Codable = Decodable & Encodable

public protocol Decodable {
	
	init(json: Dict) throws
}

public protocol Encodable {
	
	func encoded() -> Dict
}




// MARK: - Parse functions

private func getParse <T> (_ json: Dict, key: String) throws -> T {
	guard let value: Any = json.valueFor(path: key) else {
		throw DecodingError.missingKey(key: key)
	}
	
	guard let parsed = value as? T else {
		throw DecodingError.parseFailed(key: key, value: value, valueType: T.self)
	}
	
	return parsed
}




// MARK: - Private decode function

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
	guard let date = Date.init(str, format: format) else {
		throw DecodingError.dateFormat(key: key, value: str, format: format.rawValue)
	}
	return date
}







// MARK: - Public decode functions

public extension Dictionary where Key == String {
	
	// Any
	
	func decode <T> (_ key: String) throws -> T {
		return try Func.decode(self, key)
	}
//	func decode <T> (_ key: String) throws -> T? {
//		return try? self.decode(key)
//	}
	
	
	// Decodable
	
	func decode <T> (_ key: String) throws -> T where T: Decodable {
		return try Func.decode(self, key)
	}
	func decode <T> (_ key: String) throws -> T? where T: Decodable {
		return try? self.decode(key)  as T
	}
	
	func decode <T> (_ key: String) throws -> T where T: RangeReplaceableCollection, T.Element: Decodable {
		return try Func.decode(self, key)
	}
	func decode <T> (_ key: String) throws -> T? where T: RangeReplaceableCollection, T.Element: Decodable {
		return try? self.decode(key)  as T
	}
	
	
	// RawRepresentable
	
	func decode <T> (_ key: String) throws -> T where T: RawRepresentable {
		return try Func.decode(self, key)
	}
	func decode <T> (_ key: String) throws -> T? where T: RawRepresentable {
		return try? self.decode(key) as T
	}
	
	func decode <T> (_ key: String) throws -> T where T: RangeReplaceableCollection, T.Element: RawRepresentable {
		return try Func.decode(self, key)
	}
	func decode <T> (_ key: String) throws -> T? where T: RangeReplaceableCollection, T.Element: RawRepresentable {
		return try? self.decode(key) as T
	}
	
	
	// URL
	
	func decode (_ key: String) throws -> URL {
		return try Func.decode(self, key)
	}
	func decode (_ key: String) throws -> URL? {
		return try? self.decode(key) as URL
	}
	
	func decode (_ key: String) throws -> [URL] {
		return try Func.decode(self, key)
	}
	func decode (_ key: String) throws -> [URL]? {
		return try? self.decode(key) as [URL]
	}
	
	
	// Date
	
	func decode (_ key: String, format: DateFormat = .dateTime) throws -> Date {
		return try Func.decode(self, key, format: format)
	}
	func decode (_ key: String, format: DateFormat = .dateTime) throws -> Date? {
		return try? self.decode(key, format: format) as Date
	}
}





public enum DecodingError: LocalizedError {
	case missingKey(key: String)
	case parseFailed(key: String, value: Any, valueType: Any.Type)
	case dateFormat(key: String, value: String, format: String)
	case any(String)
	
	public var errorDescription: String? {
		switch self {
		case .missingKey(let key): return "\"\(key)\" does not exist"
		case .parseFailed(let key, let value, let type): return "Expected \"\(key)\" to be of type: \(type) but was \(Swift.type(of: value))"
		case .dateFormat(let key, let value, let format): return "Expected \"\(key)\" \(value) to be of format \(format)"
		case .any(let description): return description
		}
	}
}
