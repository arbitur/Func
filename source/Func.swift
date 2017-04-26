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





public func pixels<T: FloatingNumber>(points v: T) -> T {
	return v * T(UIScreen.main.scale)
}

public func points<T: FloatingNumber>(pixels v: T) -> T {
	return v / T(UIScreen.main.scale)
}





public func boundary<T: Comparable>(value: T, min: T, max: T) -> T {
	switch true {
		case value < min: return min
		case value > max: return max
		default			: return value
	}
}

















