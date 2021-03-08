//
//  NSCache+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public extension NSCache {
	
	@objc convenience init(name: String) {
		self.init()
		self.name = name
	}
}
