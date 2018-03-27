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
	
	public typealias Observer = (T) -> ()
	private var observers = [Observer]()
	
	public var value: T {
		didSet {
			notify()
		}
	}
	
	public func notify() {
		observers.forEach { $0(value) }
	}
	
	public init(_ value: T) {
		self.value = value
	}
	
	/// Use [weak/unowned self] to prevent retain cycle
	public func bind(_ observer: @escaping Observer) {
		observers ++= observer
		observer(value)
	}
	
	public func bindNext(_ observer: @escaping Observer) {
		observers ++= observer
	}
}





public final class Channel<T> {
	
	public typealias Listener = (T) -> ()
	private var listeners = [Listener]()
	
	
	public func broadcast(_ value: T) {
		listeners.forEach {
			$0(value)
		}
	}
	
	/// Use [weak/unowned self] to prevent retain cycle
	public func listen(_ listener: @escaping Listener) {
		listeners ++= listener
	}
	
	
	// Anti-Error: Channel<T> initializer is inacccessible due to 'internal' protection level
	public init() {}
}

















