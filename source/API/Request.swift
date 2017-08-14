//
//  Request.swift
//  Pods
//
//  Created by Philip Fryklund on 11/Aug/17.
//
//

import Alamofire





/**
	Base protocol for a request
*/
public protocol Requestable {
	associatedtype D: Decoder
	associatedtype M
	
	/// The response decoder.
	var decoder: D { get }
	
	/**
		Creates the response model
		- parameter data: The data type specified from the Decoder
		- returns: The model or nil
	*/
	func makeModel(data: D.D) -> M?
	
	/**
		Build an Alamofire Request
		- parameter api: The API model
		- returns: Alamofire.Request
	*/
	func request(api: API.Type) -> Alamofire.Request
}





/**
	Protocol to make a standard request.

	- method:	HTTP method.			**(default: get)**
	- url:		Path to a specific api.
	- headers:	HTTP headers.			**(default: nil)**
	- body:		HTTP body.				**(default: nil)**
	- encoding: HTTP encoding.			**(default: URLEncoding.default)**
	- decoder:	Response decoder.		**(default: URLEncoding.default)**
*/
public protocol DataRequestable: Requestable {
	var method: HTTPMethod { get } // Default .get
	var url: String { get } // Required
	var headers: [String: String]? { get } // Default nil
	var body: [String: Any]? { get } // Default nil
	var encoding: ParameterEncoding { get } // Default URLEncoding.default
}



public extension DataRequestable {
	var method: HTTPMethod {
		return .get
	}
	var headers: [String: String]? {
		return nil
	}
	var body: [String: Any]? {
		return nil
	}
	var encoding: ParameterEncoding {
		return URLEncoding.default
	}
	
	
	
	public var decoder: JSONDecoder {
		return .default
	}
	
	func request(api: API.Type) -> Alamofire.Request {
		let url = api.baseUrl + "/" + self.url
		let headers = [api.baseHeaders, self.headers].flatMap { $0 }.merged()
		
		return Alamofire.request(url, method: method, parameters: body, encoding: encoding, headers: headers)
	}
}





public protocol UploadRequestable: Requestable {
	
}


public extension UploadRequestable {
//	public func request(baseUrl: String, baseHeaders: [String : String]?) -> Request {
//		
//	}
}
















