//
//  Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public typealias Dict = [String: Any]
public typealias Arr = [Any]
public typealias Closure = ()->()

infix operator ?==





internal let funcDirectory = "se.arbitur.Func"





public func clamp <T: Comparable> (_ value: T, min: T, max: T) -> T {
	return Swift.min(Swift.max(value, min), max)
}

public func clamp <T: Comparable> (_ value: T, max: T) -> T {
	return min(value, max)
}

public func clamp <T: Comparable> (_ value: T, min: T) -> T {
	return max(value, min)
}

// Renamings of min and max functions
//public func lowest <T: Comparable> (_ lhs: T, _ rhs: T) -> T {
//	return min(lhs, rhs)
//}
//
//public func highest <T: Comparable> (_ lhs: T, _ rhs: T) -> T {
//	return min(lhs, rhs)
//}





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

extension Observable: Equatable where T: Equatable {
	
	public static func == (lhs: Observable, rhs: Observable) -> Bool {
		return lhs.value == rhs.value
	}
	
	public static func == (lhs: T, rhs: Observable) -> Bool {
		return lhs == rhs.value
	}
	
	public static func == (lhs: Observable, rhs: T) -> Bool {
		return rhs == lhs.value
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

















