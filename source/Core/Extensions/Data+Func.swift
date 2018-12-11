//
//  Data+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public extension Data {
	
	init?(_ string: String, encoding: String.Encoding = .utf8, allowLossyConversion: Bool = false) {
		guard let data = string.data(using: encoding, allowLossyConversion: allowLossyConversion) else {
			return nil
		}
		self.init(data)
	}
	
	init <T: Number> (_ int: T) {
		var i = int
		self.init(bytes: &i, count: MemoryLayout.size(ofValue: int))
	}
}
