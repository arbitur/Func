//
//  Networking.swift
//  FuncExample
//
//  Created by Philip Fryklund on 8/Feb/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Func





final class HTTPClient: NSObject {
	
	
	override init() {
		super.init()
		
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
		
		var urlRequest = URLRequest.init(url: "https://google.com", cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
		urlRequest.httpMethod = "GET"
		urlRequest.allHTTPHeaderFields = [:]
		let task = session.dataTask(with: urlRequest) { data, response, error in
			
		}
		
		URLSessionDataDelegate
		
		(task as URLSessionTask).resume()
	}
}


extension HTTPClient: URLSessionDelegate {
	
	func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
		print(#function)
	}
	
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		print(#function)
		completionHandler(.useCredential, nil)
	}
	
	
	func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
		print(#function, error ?? "nil")
	}
}
