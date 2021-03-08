//
//  ApiClient.swift
//  Func
//
//  Created by Philip Fryklund on 2021-03-08.
//

import Foundation



public enum HttpMethod: String {
	case get     = "GET"
	case post    = "POST"
	case put     = "PUT"
	case patch   = "PATCH"
	case delete  = "DELETE"
	case head    = "HEAD"
	case options = "OPTIONS"
	case trace   = "TRACE"
	case connect = "CONNECT"
}

public typealias HttpHeaders = [String: Set<String>]





//MARK: - Serialization

public enum SerializerError: Error {
	case wrong
}

public protocol Serializer {
	
	func serialize(data: Data) throws -> Any
}

public struct JsonSerializer: Serializer {
	public let options: JSONSerialization.ReadingOptions
	public init(options: JSONSerialization.ReadingOptions = []) {
		self.options = options
	}
	
	public func serialize(data: Data) throws -> Any {
		return try JSONSerialization.jsonObject(with: data, options: options)
	}
}

public struct AnySerializer: Serializer {
	
	public func serialize(data: Data) throws -> Any {
		return data
	}
}





//MARK: - Decoding

public protocol Decoder {
	
	associatedtype In
	associatedtype Out
	var decoder: (In) throws -> Out { get }
}

public extension Decoder {
	
	func decode(obj: Any) throws -> Out {
		guard let obj = obj as? In else {
			throw SerializerError.wrong
		}
		return try decoder(obj)
	}
}

public struct AnyDecoder<Out>: Decoder {
	public let decoder: (Any) throws -> Out
	
	public init() {
		decoder = {
			guard let obj = $0 as? Out else {
				throw SerializerError.wrong
			}
			return obj
		}
	}
	
	public init(decoder: @escaping (Any) throws -> Out) {
		self.decoder = decoder
	}
}

public struct DecodableDecoder<Out: Decodable>: Decoder {
	public typealias Closure = (Dict) throws -> Out
	public let decoder: Closure
	public init(decoder: @escaping Closure) { self.decoder = decoder }
}






//MARK: - Encoding

public protocol BodyEncoder {
	
	func encode(request: RequestBuilder) throws -> Data?
}

public struct JsonBodyEncoder: BodyEncoder {
	
	public let body: Any
	public let options: JSONSerialization.WritingOptions
	
	public init(body: Dict, options: JSONSerialization.WritingOptions = []) {
		self.body = body
		self.options = options
	}
	
	public init(body: [Dict], options: JSONSerialization.WritingOptions = []) {
		self.body = body
		self.options = options
	}
	
	public func encode(request: RequestBuilder) throws -> Data? {
		request.headers["Content-Type"] = ["application/json"]
		return try JSONSerialization.data(withJSONObject: body, options: options)
	}
}

public struct URLBodyEncoder: BodyEncoder {
	
	public let parameters: Dict
	public init(parameters: Dict) {
		self.parameters = parameters
	}
	
	public func encode(request: RequestBuilder) throws -> Data? {
		let query = parameters.map({ "\($0.percentEncoding(except: .alphanumerics)!)=\("\($1)".percentEncoding(except: .alphanumerics)!)" }).joined(by: "&")
		
		switch request.method {
		case .get, .head, .delete:
			request.url += "?" + query
			return nil
		default:
			request.headers["Content-Type"] = ["application/x-www-form-urlencoded; charset=utf-8"]
			guard let data = Data(query) else {
				throw SerializerError.wrong
			}
			return data
		}
	}
}

public struct FormBodyEncoder: BodyEncoder {
	
	public struct FormBody {
		let fileName: String?
		let mime: String?
		let data: Data
		public init(fileName: String?, mime: String?, data: Data) {
			self.fileName = fileName ; self.mime = mime ; self.data = data
		}
	}
	
	public let parameters: Dict
	public init(parameters: Dict) {
		self.parameters = parameters
	}
	
	public func encode(request: RequestBuilder) throws -> Data? {
		struct Boundary {
			static let crlf = "\r\n"
			
			let boundary: String
			let first: String
			let middle: String
			let last: String
			
			init() {
				boundary = String(format: "tidyapp_boundary_%08x%08x", arc4random(), arc4random())
				first = "--\(boundary)\(Boundary.crlf)"
				middle = "\(Boundary.crlf)--\(boundary)\(Boundary.crlf)"
				last = "\(Boundary.crlf)--\(boundary)--\(Boundary.crlf)"
			}
		}
		let boundary = Boundary()
		
		let bodies: [(name: String, body: FormBody)] = parameters.map { key, value in
			if let body = value as? FormBody {
				return (key, body)
			}
			
			return (key, FormBody(fileName: nil, mime: nil, data: Data(String(describing: value))!))
		}
		
		request.headers["Content-Type"] = ["multipart/form-data; boundary=\(boundary.boundary)"]
		
		var httpBody = Data()
		httpBody += Data(boundary.first)!
		
		for (i, e) in bodies.enumerated() {
			let (name, body) = e
			if i > 0 {
				httpBody += Data(boundary.middle)!
			}
			
			var disposition = "form-data; name=\"\(name)\""
			if let fileName = body.fileName {
				disposition += "; filename=\"\(fileName)\""
			}
			
			var headers = ["Content-Disposition": disposition]
			if let mime = body.mime {
				headers["Content-Type"] = mime
			}
			
			httpBody += Data( headers.map({ "\($0): \($1)\(Boundary.crlf)" }).joined() )!
			httpBody += Data(Boundary.crlf)!
			
			httpBody += body.data
		}
		
		httpBody += Data(boundary.last)!
		
		return httpBody
	}
}

public struct DataBodyEncoder: BodyEncoder {
	
	public let data: Data
	public init(data: Data) {
		self.data = data
	}
	
	public func encode(request: RequestBuilder) throws -> Data? {
		request.headers["Content-Type"] = ["application/octet-stream"]
		return data
	}
}







//MARK: - Request

public protocol Cancellable {
	
	func cancel()
}

public class Request<T>: Cancellable {
	
	fileprivate var task: URLSessionTask?
	
	fileprivate var onResponse: ((Response<T>) -> Void)?
	fileprivate var onError: ((Error) -> Void)?
	fileprivate var onComplete: (() -> Void)?
	
	internal init() {}
	
	/// Called when there was no fatal errors i.e called when a response was received regardless of status code, for successful status code use `Response.isSuccessful`.
	public func onResponse(_ onResponse: @escaping (Response<T>) -> Void) {
		self.onResponse = onResponse
	}
	
	/// Called when there was a fatal error ex: URLSession error, serialize error
	public func onError(_ onError: @escaping (Error) -> Void) {
		self.onError = onError
	}
	
	/// Called lastly i.e **after** onResponse or onError
	public func onComplete(_ onComplete: @escaping Closure) {
		self.onComplete = onComplete
	}
	
	
	public func resume(builder: ((Request<T>) -> Void)? = nil) {
		builder?(self)
		task?.resume()
	}
	
	public func suspend() {
		task?.suspend()
	}
	
	public func cancel() {
		task?.cancel()
	}
}


public class RequestBuilder: CustomStringConvertible {
	public var method: HttpMethod = .get
	public var url: String = ""
	public var headers: HttpHeaders = [:]
	public var bodyEncoder: BodyEncoder?
	public var responseSerializer: Serializer = JsonSerializer(options: [])
	
	public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
	public var timeoutInterval: TimeInterval = 60
	public var networkServiceType: URLRequest.NetworkServiceType = .default
	public var allowsCellularAccess: Bool = true
	public var httpShouldHandleCookies: Bool = true
	public var httpShouldUsePipelining: Bool = true
	
	public var description: String {
		return """
		RequestBuilder(
			method: \(method),
			url: \(url),
			headers:
				\(headers.map { "\($0.key): \($0.value.joined(by: ","))" }.joined(by: "\n\t\t"))
			body: \((bodyEncoder as? URLBodyEncoder)?.parameters.description ?? "nil")
		)
		"""
	}
}








//MARK: - Response

public class Response<T> {
	
	public let statusCode: Int
	public let body: T?
	public let responseData: Data?
	public let isSuccessful: Bool
	
	public init(statusCode: Int, body: T?, responseData: Data?) {
		self.statusCode = statusCode
		self.body = body
		self.responseData = responseData
		self.isSuccessful = statusCode ?== 200..<300
	}
	
	public func map <U> (by closure: (T?) -> U?) -> Response<U> {
		return Response<U>(statusCode: statusCode, body: closure(body), responseData: responseData)
	}
}






// MARK: - API client

public protocol ApiClient {
	
	var baseUrl: String { get }
	var interceptors: [(RequestBuilder) -> Void] { get set }
	var logger: HttpLogger { get set }
}

public extension ApiClient {
	
	var logger: HttpLogger {
		return BaseHttpLogger(level: .default)
	}

	func request <D: Decoder> (decoder: D, buildRequest: (inout RequestBuilder) -> Void) -> Request<D.Out> {
		var builder = RequestBuilder()
		buildRequest(&builder)
		if !builder.url.contains("http") {
			let toAppend: String
			if !baseUrl.hasSuffix("/") && !builder.url.hasPrefix("/") {
				toAppend = "/" + builder.url
			}
			else {
				toAppend = builder.url
			}
			builder.url = baseUrl + toAppend
		}
		
		let requestBodyData = try? builder.bodyEncoder?.encode(request: builder) // Needs to be called before urlRequest so url will be correct if httpBody and method is head, get or delete
		
		for interceptor in interceptors {
			interceptor(builder)
		}
		
		
//		print(builder)
		
		var urlRequest = URLRequest(url: URL(string: builder.url)!, cachePolicy: builder.cachePolicy, timeoutInterval: builder.timeoutInterval)
		urlRequest.httpMethod = builder.method.rawValue
		urlRequest.allHTTPHeaderFields = builder.headers.mapValues { $0.joined(by: ",") }
		urlRequest.httpBody = requestBodyData
		urlRequest.networkServiceType = builder.networkServiceType
		urlRequest.allowsCellularAccess = builder.allowsCellularAccess
		urlRequest.httpShouldHandleCookies = builder.httpShouldHandleCookies
		urlRequest.httpShouldUsePipelining = builder.httpShouldUsePipelining
		
		let request = Request<D.Out>()
		
		let timer = DebugTimer()
//		NetworkActivityIndicator.incrementQueueCount()
		logger.log(request: urlRequest)
		
		request.task = URLSession.shared.dataTask(with: urlRequest) { (httpData, httpResponse, httpError) in
//			NetworkActivityIndicator.decrementQueueCount()
			
			defer {
				Dispatch.main.async {
					request.onComplete?()
				}
			}
			
			if let error = httpError {
				print("*** [ERROR] ***", error.localizedDescription, ":", urlRequest.url!)
				Dispatch.main.async {
					request.onError?(error)
				}
			}
			else if let httpResponse = httpResponse as? HTTPURLResponse, let httpData = httpData {
				self.logger.log(response: httpResponse, data: httpData, timer: timer)
				
				do {
					let obj = try builder.responseSerializer.serialize(data: httpData)
					let response: Response<D.Out>
					
					if httpResponse.statusCode ?== 200..<300 {
						let body: D.Out = try decoder.decode(obj: obj)
						response = Response(statusCode: httpResponse.statusCode, body: body, responseData: httpData)
					}
					else {
						response = Response(statusCode: httpResponse.statusCode, body: try? decoder.decode(obj: obj), responseData: httpData)
					}
					
					Dispatch.main.async {
						request.onResponse?(response)
					}
				}
//				catch TidyError.responseError(let error, let errorMessage) {
//					if let url = urlRequest.url, !url.absoluteString.contains("login") {
//						EventLogger.logUnexpectedResponse(httpResponse, for: urlRequest, data: httpData, with: (error as? LocalizedError)?.localizedDescription ?? errorMessage)
//					}
//					print("*** [ERROR] ***", (error as? LocalizedError)?.localizedDescription ?? errorMessage, ":", urlRequest.url!)
//
//					DispatchQueue.main.async {
//						request.onError?(error)
//					}
//				}
				catch {
//					EventLogger.logUnexpectedResponse(httpResponse, for: urlRequest, data: httpData, with: error.localizedDescription)
					print("*** [ERROR] ***", error.localizedDescription, ":", urlRequest.url!)
					
					Dispatch.main.async {
						request.onError?(error)
					}
				}
			}
			else {
				fatalError("Only HTTP requests allowed")
			}
		}
		
		return request
	}
}



// MARK: - Logging

public enum HttpLoggingLevel: Int, Comparable {
	case none, light, medium, full
	
	public static let `default`: HttpLoggingLevel = .light
	
	public static func < (lhs: HttpLoggingLevel, rhs: HttpLoggingLevel) -> Bool {
		lhs.rawValue < rhs.rawValue
	}
}

public protocol HttpLogger {
	var level: HttpLoggingLevel { get }
	func log(request: URLRequest)
	func log(response: HTTPURLResponse, data: Data?, timer: DebugTimer)
}

public struct BaseHttpLogger: HttpLogger {
	
	public let level: HttpLoggingLevel
	public init(level: HttpLoggingLevel = .default) {
		self.level = level
	}
	
	public func log(request: URLRequest) {
		guard level != .none else { return }
		
		print()
		print("<--", request.httpMethod ?? "", request.url?.absoluteString ?? "")
		
		guard level > .light else { return }
		
		if level == .full, let headers = request.allHTTPHeaderFields, headers.isNotEmpty {
			headers.forEach { print($0, $1) }
		}
		
		if let data = request.httpBody {
			if let string = String(data) {
				print(string.removed(characters: CharacterSet.newlines))
			}
			else {
				print("Request body size:", data.count)
			}
		}
	}
	
	public func log(response: HTTPURLResponse, data: Data?, timer: DebugTimer) {
		guard level != .none else { return }
		
		print()
		print("-->", response.statusCode, response.url?.absoluteString ?? "", "|", timer.formatMilli(), "|")
		
		guard level > .light else { return }
		
		if level == .full {
			response.allHeaderFields.forEach { print($0, $1) }
		}
		
		if let data = data {
			if level == .medium, data.count >= 10_000 {
				print("Body too big to print")
			}
			else if let string = String(data) {
				print(string.removed(characters: CharacterSet.newlines))
			}
			else {
				print("Response body size:", data.count)
			}
		}
	}
}
