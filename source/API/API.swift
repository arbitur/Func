//
//  API.swift
//  Pods
//
//  Created by Philip Fryklund on 11/Aug/17.
//
//

import Alamofire





/**
	What to log for requests and responses
*/
public enum LoggingMode {
	case none, url, headers, body, all
}



public protocol API {
	static var loggingMode: LoggingMode { get }
	
	/// The host to your api server EX: https://api.company.com
	static var baseUrl: String { get set }
	
	/// Headers to send for each request
	static var baseHeaders: [String: String]? { get set }
}



public extension API {
	static var loggingMode: LoggingMode {
		return .all
	}
	
	/// Logs the request when sending it to your server
	private static func log(request: Alamofire.Request) {
		if loggingMode == .none {
			return
		}
		
		print()
		print(request, "|", request.request?.httpBody?.count ?? 0, "b |")
		
		if loggingMode ?== [.headers, .all], let headers = request.request?.allHTTPHeaderFields {
			for (k, v) in headers {
				print(k + ":", v)
			}
		}
		
		if loggingMode ?== [.body, .all], let data = request.request?.httpBody, let str = String(data) {
			print(str)
		}
	}
	
	
	private static func log(_ response: String, headers: [AnyHashable: Any]? = nil, body: Data? = nil, error: (message: String, failure: (String) -> ())? = nil) {
		if loggingMode == .none {
			return
		}
		
		var response = response
		
		response += " \(body?.count ?? 0) b |"
		
		if let error = error {
			response += "\n" + error.message
			print(response, "\n")
			error.failure(error.message)
			return
		}
		
		if loggingMode ?== [.headers, .all], let headers = headers {
			response += "\n" + headers.map {  "\($0.key) : \($0.value)" }.joined(by: "\n")
		}
		
		if loggingMode ?== [.body, .all], let body = body, let string = String(body) {
			response += "\n" + string
		}
		
		print(response, "\n")
	}
	
	
	/**
		Sends request to server using Alamofire.
		- parameters:
			- requestable: The request struct.
			- success: Callback for successful response where the model is successfully parsed.
			- failure: Callback for when parsing the response failed with an error message.
			- finally: Optional callback always called after success or failure.
		- returns: The request created by requestable
	*/
	@discardableResult
	static func fetch <R> (_ requestable: R, success: @escaping (R.M) -> (), failure: @escaping (String) -> (), finally: Closure? = nil) -> Alamofire.Request where R: Requestable {
		let request = requestable.request(api: Self.self)
		
		log(request: request)
		
		let callback: (DefaultDataResponse) -> () = { response in
			defer {
				finally?()
			}
			
			let logString = "\nRESPONSE \(request) | \(Int(response.timeline.totalDuration * 1000)) ms |"
			
			if let error = response.error {
				return log(logString, error: (error.localizedDescription, failure))
			}
			
			guard let data = response.data, data.count > 0 else {
				return log(logString, error: ("Zero data received", failure))
			}
			
			guard let d = try? requestable.decoder.decode(data: data) else {
				return log(logString, error: ("Failed to decode data", failure))
			}
			
			guard let model = requestable.makeModel(data: d) else {
				return log(logString, error: ("Failed to decode data", failure))
			}
			
			log(logString, headers: response.response?.allHeaderFields, body: data, error: nil)
			
			success(model)
		}
		
		if let request = request as? DataRequest {
			request.response(completionHandler: callback)
		}
		else if let request = request as? UploadRequest {
			request.response(completionHandler: callback)
		}
//		else if let request = request as? DownloadRequest {
//			request.response(completionHandler: { response in
//				
//			})
//		}
		
		return request
	}
}
















