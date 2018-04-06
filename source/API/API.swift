//
//  API.swift
//  Func
//
//  Created by Philip Fryklund on 24/Oct/17.
//

import Alamofire





public protocol API {
	/// Schema + domain [+ port]
	static var baseUrl: String { get }
	static var baseHeaders: HTTPHeaders? { get }
	static var loggingMode: LoggingMode { get }
}

public extension API {
	
	static var loggingMode: LoggingMode {
		return .all
	}
	
	static func log(request: URLRequest?) {
		guard
			loggingMode != .none,
			let request = request,
			let httpMethod = request.httpMethod,
			let url = request.url?.absoluteString
		else {
			return
		}
		
		print("\n-->", httpMethod, url, "|", request.httpBody?.count ?? 0, "b |")
		
		if loggingMode ?== [.headers, .all], let headers = request.allHTTPHeaderFields {
			headers.forEach { print($0 + ":", $1) }
		}
		
		if loggingMode ?== [.body, .all], let data = request.httpBody {
			if let str = String(data) {
				print(str)
			}
			else {
				print(data)
			}
		}
	}
	
	static func log(response: DefaultDataResponse) {
		guard
			loggingMode != .none,
			let statusCode = response.response?.statusCode,
			let url = response.request?.url?.absoluteString
		else {
			return
		}
		
		print("\n<-- \(statusCode) \(url) | \(Int(response.timeline.totalDuration * 1000)) ms |")
		
		if loggingMode ?== [.headers, .all], let headers = response.response?.allHeaderFields as? [String: String] {
			headers.forEach { print($0 + ":", $1) }
		}
		
		if loggingMode ?== [.body, .all], let data = response.data, let str = String(data) {
			print(str)
		}
	}
	
	static func dataRequest <R: DataRequestable, M> (_ req: R, decode: @escaping (Data) throws -> M) -> ResponseHandler<M> {
		let request = req.request(Self.self)
		let responseHandler = ResponseHandler<M>(request: request)
		
		log(request: request.request)
		
		request.response { response in
			log(response: response)
			
			defer {
				responseHandler.finally?()
			}
			
			if let error = response.error {
				responseHandler.failure?(error.localizedDescription)
				return
			}
			
			do {
				guard let data = response.data, data.isNotEmpty else {
					throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
				}
				let model = try decode(data)
				responseHandler.success?(response.response?.statusCode ?? 0, model)
			}
			catch {
				responseHandler.failure?(error.localizedDescription)
			}
		}
		
		return responseHandler
	}
	
	// Array / Dictionary
	static func requestJson <R: DataRequestable> (_ req: R) -> ResponseHandler<R.Model> {
		
		return dataRequest(req) { data in
			let obj = try JSONResponseSerializer.default.serialize(data: data)
			guard let model = obj as? R.Model else {
				throw APIError.castingError
			}
			return model
		}
	}
	
	// Array of type `M` ### Might be unnecessary
//	static func requestJson <R, M> (_ req: R) -> ResponseHandler<R.Model> where R: DataRequestable, R.Model == [M] {
//
//		return dataRequest(req) { data -> R.Model in
//			let obj = try JSONResponseSerializer.default.serialize(data: data)
//			guard let arr = obj as? [Any] else {
//				throw APIError.castingError
//			}
//
//			return arr.compactMap { $0 as? M }
//		}
//	}
	
	
	static func requestJson <R: DataRequestable> (_ req: R) -> ResponseHandler<R.Model> where R.Model: Func.Decodable {
		
		return dataRequest(req) { data in
			let obj = try JSONResponseSerializer.default.serialize(data: data)
			guard let dict = obj as? Dict else {
				throw APIError.castingError
			}
			return try R.Model(json: dict)
		}
	}
	
	static func requestJson <R: DataRequestable, M> (_ req: R) -> ResponseHandler<R.Model> where M: Func.Decodable, R.Model == [M] {
		
		return dataRequest(req) { data in
			let obj = try JSONResponseSerializer.default.serialize(data: data)
			guard let arr = obj as? [Dict] else {
				throw APIError.castingError
			}
			
			return try arr.compactMap(M.init)
		}
	}
}



public enum APIError: String, Error {
	case castingError = "Failed to cast object into specified model"
}



public enum LoggingMode {
	case none, url, headers, body, all
}

