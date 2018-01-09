//
//  URL+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public extension URL {
	
	var parameters: [String: String] {
		let paramsRaw = self.query?.components(separatedBy: "&")
		var params = [String: String]()
		
		paramsRaw?.forEach {
			let a = $0.components(separatedBy: "=")
			if let key = a.first, let value = a.last {
				params.updateValue(value, forKey: key)
			}
		}
		return params
	}
}



extension URL: ExpressibleByStringLiteral {
	
	public init(stringLiteral value: StringLiteralType) {
		guard let url = URL(string: value) else {
			fatalError("Could not create URL from string: \"\(value)\"")
		}
		self = url
	}
}




















//	var percentEncoded: String {
//		let scheme = self.scheme
//		
//		let host = self.host?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
//		let port = self.port
//		let path = self.path?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())
//		let query = self.query?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
//		let fragment = self.fragment?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
//		
////		print(scheme, host ?? nil, port ?? nil, path ?? nil, fragment ?? nil, parameterString ?? nil, query ?? nil)
//		
//		var url = scheme! + ":"
//		if let host = host {
//			url += "//" + host
//		}
//		if let port = port as? Int {
//			url += ":" + String(port)
//		}
//		if let path = path {
//			url += "/" + path
//		}
//		if let query = query {
//			url += "?" + query
//		}
//		if let fragment = fragment {
//			url += "#" + fragment
//		}
//		
//		return url
//	}
//}
