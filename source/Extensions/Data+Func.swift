//
//  Data+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public extension Data {
	init?(_ string: String?) {
		guard let data = string?.data(using: .utf8, allowLossyConversion: false) else { return nil }
		self.init(data)
	}
}
