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
		
		if loggingMode ?== [.body, .all], let data = request.httpBody, let str = String(data) {
			print(str)
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
	
	static func request <R> (_ req: R) -> ResponseHandler<DataRequest, R.Model> where R: DataRequestable {
		let request = req.request(Self.self)
		let responseHandler = ResponseHandler<DataRequest, R.Model>(request: request)
		
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
				let a = req.responseSerializer
				let obj = try a.serialize(data: response.data)
				let model = try req.decode(obj)
				responseHandler.success?(response.response?.statusCode ?? 0, model)
			}
			catch {
				responseHandler.failure?(error.localizedDescription)
			}
		}
		
		return responseHandler
	}
}




public enum LoggingMode {
	case none, url, headers, body, all
}

