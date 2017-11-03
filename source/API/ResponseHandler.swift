//
//  ResponseHandler.swift
//  Func
//
//  Created by Philip Fryklund on 24/Oct/17.
//

import Alamofire





public class ResponseHandler<R: Alamofire.Request, M> {
	public let request: R
	
	public var success: ((Int, M)->())?
	public var failure: ((String)->())?
	public var finally: (()->())?
	
	
	@discardableResult
	public func success(_ success: @escaping (Int, M)->()) -> Self {
		self.success = success
		return self
	}
	
	@discardableResult
	public func failure(_ failure: @escaping (String)->()) -> Self {
		self.failure = failure
		return self
	}
	
	@discardableResult
	public func finally(_ finally: @escaping ()->()) -> Self {
		self.finally = finally
		return self
	}
	
	public init(request: R) {
		self.request = request
	}
}
