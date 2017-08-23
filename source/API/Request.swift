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
	var method: HTTPMethod { get }
	
	/// The specific api path Ex: `users/add`
	var url: String { get }
	
	var headers: [String: String]? { get }
	
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
	func request(url: String, headers: [String: String]?) throws -> Alamofire.Request
}





/// Protocol to make a standard request.
public protocol DataRequestable: Requestable {
	/// HTTP body (default: nil)
	var body: Dict? { get }
	
	/// How to encode HTTP body (default: URLEncoding)
	var encoding: ParameterEncoding { get }
}



public extension DataRequestable {
	/// (default: GET)
	var method: HTTPMethod {
		return .get
	}
	
	/// (default: nil)
	var headers: [String: String]? {
		return nil
	}
	
	/// (default: nil)
	var body: [String: Any]? {
		return nil
	}
	
	/// (default: URLEncoding)
	var encoding: ParameterEncoding {
		return URLEncoding.default
	}
	
	
	/// (default: JSONDecoder)
	public var decoder: JSONDecoder {
		return .default
	}
	
	func request(url: String, headers: [String: String]?) throws -> Alamofire.Request {
		return Alamofire.request(url, method: method, parameters: body, encoding: encoding, headers: headers)
	}
}







public protocol UploadRequestable: Requestable {
	var uploadBody: UploadBody { get }
}


public extension UploadRequestable {
	public func request(url: String, headers: [String: String]?) throws -> Request {
		switch uploadBody {
		case .data(let data): return Alamofire.upload(data, to: url, method: method, headers: headers)
		case .file(let url) : return Alamofire.upload(url, to: url, method: method, headers: headers)
		case .multipart(let body):
			let semaphore = DispatchSemaphore(value: 0)
			var result: SessionManager.MultipartFormDataEncodingResult?
			
			let multipart: (MultipartFormData) -> () = { builder in
				for b in body {
					b.append(builder)
				}
			}
			
			Alamofire.upload(multipartFormData: multipart, to: url, method: method, headers: headers) {
				result = $0
				semaphore.signal()
			}
			
			semaphore.wait()
			
			switch result! {
				case .success(let request, _, _): return request
				case .failure(let error): throw error
			}
		}
	}
}




public enum UploadBody {
	case data(Data)
	case file(URL)
	case multipart([MultipartBody])
}

public enum MultipartBody {
	case data(String, Data)
	case dataMime(String, Data, mime: MimeType)
	case dataNameMime(String, Data, name: String, mime: MimeType)
	case file(String, URL)
	case fileNameMime(String, URL, name: String, mime: MimeType)
	
	public func append(_ builder: MultipartFormData) {
		switch self {
			case .data(let key, let data)								: builder.append(data, withName: key)
			case .dataMime(let key, let data, let mime)					: builder.append(data, withName: key, mimeType: mime.rawValue)
			case .dataNameMime(let key, let data, let name, let mime)	: builder.append(data, withName: key, fileName: name, mimeType: mime.rawValue)
			case .file(let key, let url)								: builder.append(url, withName: key)
			case .fileNameMime(let key, let url, let name, let mime)	: builder.append(url, withName: key, fileName: name, mimeType: mime.rawValue)
		}
	}
}

public enum MimeType {
	case text
	case jpeg
	case png
	case json
	case custom(String)
	
	public var rawValue: String {
		switch self {
			case .text: return "text/plain"
			case .jpeg: return "image/jpeg"
			case .png : return "image/png"
			case .json: return "application/json"
			case .custom(let mime): return mime
		}
	}
}


















