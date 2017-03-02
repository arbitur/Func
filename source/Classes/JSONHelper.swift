//
//  JSONHelper.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public class JSONHelper {
	public typealias JSONData = (dictionary: [String: Any]?, array: [Any]?)
	
	
	public static func decode(data: Data, print: Bool = false) -> JSONData? {
		if print {
			Swift.print()
			Swift.print("Decode JSON:", String(data)!)
		}
		
		do {
			let json = try JSONSerialization.jsonObject(with: data, options: [])
			return (json as? [String: Any], json as? [Any])
		}
		catch {
			Swift.print("Failed to decode JSON:", error.localizedDescription)
			return nil
		}
	}
	
	public static func decode(string: String, print: Bool = false) -> JSONData? {
		if let data = Data(string) {
			return decode(data: data, print: print)
		}
		
		return nil
	}
	
	public static func encode(obj: Any, print: Bool = false) -> String? {
		do {
			let data = try JSONSerialization.data(withJSONObject: obj, options: [])
			let json = String(data)!
			
			if print {
				Swift.print()
				Swift.print("Encode JSON:", json)
			}
			
			return json
		}
		catch {
			Swift.print("Failed to encode JSON:", error.localizedDescription)
			return nil
		}
	}
}


















