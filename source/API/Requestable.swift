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
	
	associatedtype Serializer: ResponseSerializer
	var responseSerializer: Serializer { get }
	
	associatedtype Request: Alamofire.Request
	func request <A: API>(_ api: A.Type) -> Request
	
	associatedtype Model
	func decode(_ obj: Serializer.T) throws -> Model
}



public extension Requestable where Serializer == JSONResponseSerializer, Model: Func.Decodable {
	
	func decode(_ obj: Any) throws -> Model {
		guard let model = Model(json: obj as! Dict) else {
			throw AFError.responseSerializationFailed(reason: AFError.ResponseSerializationFailureReason.inputDataNil)
		}
		return model
	}
}





public protocol DataRequestable: Requestable {
	var parameters: Parameters? { get }
	var parameterEncoding: ParameterEncoding { get }
	
	func request <A> (_ api: A.Type) -> DataRequest where A: API
}

public extension DataRequestable {
	
	var method: HTTPMethod {
		return .get
	}
	
	var parameters: Parameters? {
		return nil
	}
	
	var parameterEncoding: ParameterEncoding {
		return URLEncoding.default
	}
	
	var headers: HTTPHeaders? {
		return nil
	}
	
	var responseSerializer: JSONResponseSerializer {
		return .default
	}
	
	func request<A>(_ api: A.Type) -> DataRequest where A : API {
		let url = api.baseUrl + "/" + self.url
		let headers = (api.baseHeaders ?? [:]) + (self.headers ?? [:])
		return Alamofire.request(url, method: method, parameters: parameters, encoding: parameterEncoding, headers: headers)
	}
}
