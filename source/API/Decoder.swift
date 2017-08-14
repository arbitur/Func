//
//  Decoder.swift
//  Pods
//
//  Created by Philip Fryklund on 12/Aug/17.
//
//

import Foundation





/// Protocol for a response recoder
public protocol Decoder {
	static var `default`: Self { get }
	
	associatedtype D
	/**
		Decode raw `Data` into type `D`
		- parameter data: Raw `Data`
		- returns: Type `D`
	*/
	func decode(data: Data) throws -> D
}





/// Decodes raw `Data` into a `Dictionary` or an `Array`
public struct JSONDecoder: Decoder {
	public static let `default`: JSONDecoder = JSONDecoder()
	
	public func decode(data: Data) throws -> (dictionary: Dict?, array: [Any]?) {
		let json = try JSONSerialization.jsonObject(with: data, options: [])
		return (json as? Dict, json as? [Any])
	}
}


