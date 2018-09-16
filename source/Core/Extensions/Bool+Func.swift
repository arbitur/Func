//
//  Bool+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 24/Feb/17.
//
//

import Foundation





public extension Bool {
	
//	mutating func toggle() {
//		self = !self
//	}
	
	
//	func `else`(_ bool: Bool) -> Bool {
//		return self ? self : bool
//	}
	
	
	init(_ int: Int) {
		self = int == 1
	}
}
