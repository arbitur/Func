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
	
	private var getValueModifier: ((T) -> T)?
	
	
	
	public func notify() {
		observers.forEach { $0(getValueModifier?(value) ?? value) }
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
	
	public func valueModifier(_ modifier: @escaping (T) -> T) {
		getValueModifier = modifier
	}
}





public final class Channel<T> {
	
	public typealias Listener = (T) -> ()
	private var listeners = [Listener]()
	
	private var getValueModifier: ((T) -> T)?
	
	
	public func broadcast(_ value: T) {
		listeners.forEach {
			$0(getValueModifier?(value) ?? value)
		}
	}
	
	/// Use [weak/unowned self] to prevent retain cycle
	public func listen(_ listener: @escaping Listener) {
		listeners ++= listener
	}
	
	/// Use [weak/unowned self] to prevent retain cycle
	public func onGet(_ modifier: @escaping (T) -> T) {
		getValueModifier = modifier
	}
	
	
	// Anti-Error: Channel<T> initializer is inacccessible due to 'internal' protection level
	public init() {}
}

















