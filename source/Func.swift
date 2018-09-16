//
//  Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public typealias Dict = [String: Any]
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





public final class Debug {
	
	public static func printDeinit <T> (_ obj: T) {
		print("~\(type(of: obj))")
	}
	
	
	internal init() {}
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
		bindNext(observer)
		observer(value)
	}
	
	public func bindNext(_ observer: @escaping Observer) {
		observers ++= observer
	}
	
	public func valueModifier(_ modifier: @escaping (T) -> T) {
		getValueModifier = modifier
	}
	
	
	public func observe <U: AnyObject> (_ caller: U, with closure: @escaping (U, T) -> ()) {
		observeNext(caller, with: closure)
		closure(caller, value)
	}
	
	public func observeNext <U: AnyObject> (_ caller: U, with closure: @escaping (U, T) -> ()) {
		observers ++= { [weak caller] value in
			caller.map { closure($0, value) }
		}
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





//public class Event {
//	private var observers = [() -> Void]()
//
//	func addObserver<T: AnyObject>(_ observer: T, using closure: @escaping (T) -> Void) {
//		observers.append { [weak observer] in
//			observer.map(closure)
//		}
//	}
//}





public enum Result <T> {
	case success(T)
	case failure(String)
}

















