//
//  Requestable.swift
//  Func
//
//  Created by Philip Fryklund on 24/Oct/17.
//

import Alamofire





public protocol Requestable {
	var method: HTTPMethod { get }
	var url: String { get }
	var headers: HTTPHeaders? { get }
	
	
	associatedtype Request: Alamofire.Request
	func request <A: API> (_ api: A.Type) -> Request
	
	associatedtype Model
}

public extension Requestable {
	
	var method: HTTPMethod {
		return .get
	}
	
	var headers: HTTPHeaders? {
		return nil
	}
}





public protocol DataRequestable: Requestable {
	var parameters: Parameters? { get }
	var parameterEncoding: ParameterEncoding { get }
	
	func request <A: API> (_ api: A.Type) -> DataRequest
}

public extension DataRequestable {
	
	var parameters: Parameters? {
		return nil
	}
	
	var parameterEncoding: ParameterEncoding {
		return URLEncoding.default
	}
	
	
	func request<A>(_ api: A.Type) -> DataRequest where A : API {
		let url = api.baseUrl + "/" + self.url
		let headers = (api.baseHeaders ?? [:]) + (self.headers ?? [:])
		return Alamofire.request(url, method: method, parameters: parameters, encoding: parameterEncoding, headers: headers)
	}
}





// Have to inherit `DataRequestable` due to generics getting fucked in API.request functions, fix this in the future
public protocol UploadRequestable: DataRequestable {
	
	var data: Data { get }
	
	// Fix this, not overriding DataRequestable's extension
//	func request <A: API> (_ api: A.Type) -> UploadRequest
}

public extension UploadRequestable {
	
	func request<A>(_ api: A.Type) -> DataRequest where A : API {
		let url = api.baseUrl + "/" + self.url
		let headers = (api.baseHeaders ?? [:]) + (self.headers ?? [:])
		return Alamofire.upload(data, to: url, method: method, headers: headers)
	}
}
