//
//  ResponseSerializer.swift
//  Func
//
//  Created by Philip Fryklund on 24/Oct/17.
//

import Alamofire





public protocol ResponseSerializer {
	static var `default`: Self { get }
	
	associatedtype T
	func serialize(data: Data) throws -> T
}





public struct JSONResponseSerializer: ResponseSerializer {
	public static let `default` = JSONResponseSerializer(options: [])
	
	public let options: JSONSerialization.ReadingOptions
	
	
	public func serialize(data: Data) throws -> Any {
		return try JSONSerialization.jsonObject(with: data, options: options)
	}
}



public struct DataResponseSerializer: ResponseSerializer {
	public static let `default` = DataResponseSerializer()
	
	
	public func serialize(data: Data) throws -> Data {
		return data
	}
}
