//
//  Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public typealias Closure = ()->()
infix operator ?==





internal let funcDirectory = "se.arbitur.Func"





public func boundary <T> (_ value: T, min: T, max: T) -> T where T: Comparable {
	switch true {
		case value < min: return min
		case value > max: return max
		default			: return value
	}
}

public func boundary <T> (_ value: T, max: T) -> T where T: Comparable {
	switch true {
		case value > max: return max
		default			: return value
	}
}

















