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





public final class Observable<T> {
	
	public var value: T {
		didSet {
			observers.forEach { $0(value) }
		}
	}
	
	public typealias Listener = (T) -> ()
	private var observers = [Listener]()
	
	public init(_ value: T) {
		self.value = value
	}
	
	/// Use [weak/unowned self] to prevent retain cycle
	public func bind(_ observer: @escaping Listener) {
		observers ++= observer
		observer(value)
	}
}

















