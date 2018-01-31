//
//  JSONHelper.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public enum JSON {
	case dictionary(Dict)
	case array([Any])
	
	public var dictionary: Dict? {
		switch self {
			case .dictionary(let dict): return dict
			default: return nil
		}
	}
	
	public var array: [Any]? {
		switch self {
			case .array(let arr): return arr
			default: return nil
		}
	}
}


public class JSONParser {
	
	public static func decode(data: Data, print: Bool = false) throws -> JSON {
		if print {
			Swift.print()
			Swift.print("Decode JSON:", String(data)!)
		}
		
		let json = try JSONSerialization.jsonObject(with: data, options: [])
		switch json {
			case let dictionary as Dict: return .dictionary(dictionary)
			case let array as [Any]: return .array(array)
			default: fatalError()
		}
	}
	
	
	public static func decode(string: String, print: Bool = false) throws -> JSON {
		guard let data = Data(string) else {
			fatalError()
		}
		return try decode(data: data, print: print)
	}
	
	
	public static func encode(obj: Any, print: Bool = false) throws -> String {
		let data = try JSONSerialization.data(withJSONObject: obj, options: [])
		let json = String(data)!
		
		if print {
			Swift.print()
			Swift.print("Encode JSON:", json)
		}
		
		return json
	}
	
	public static func encodedData(obj: Any) throws -> Data {
		return try JSONSerialization.data(withJSONObject: obj, options: [])
	}
}


















