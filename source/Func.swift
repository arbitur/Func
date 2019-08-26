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

infix operator ?== : ComparisonPrecedence





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


public extension NSObject {
	
	func `as` <T: NSObject> (_ class: T.Type) -> T? {
		return self as? T
	}
}




public final class Debug {
	
	public static func printDeinit <T> (_ obj: T) {
		print("~\(type(of: obj))")
	}
	
	
	internal init() {}
}





open class Observable<T> {
	
	public typealias Bond = (T) -> ()
	private var bonds = [Bond]()
	
	public typealias Observer = (_ old: T, _ new: T) -> ()
	private var observers = [Observer]()
	
	open var value: T {
		didSet {
			notify()
			observers.forEach { $0(getValueModifier?(oldValue) ?? oldValue, getValueModifier?(value) ?? value) }
		}
	}
	
	private var getValueModifier: ((T) -> T)?
	
	
	
	open func notify() {
		bonds.forEach { $0(getValueModifier?(value) ?? value) }
	}
	
	public init(_ value: T) {
		self.value = value
	}
	
	/// Use [weak/unowned self] to prevent retain cycle
	open func bind(_ bond: @escaping Bond) {
		bindNext(bond)
		bond(value)
	}
	
	open func bindNext(_ bond: @escaping Bond) {
		bonds ++= bond
	}
	
	open func observe(_ observer: @escaping Observer) {
		observers ++= observer
	}
	
	open func valueModifier(_ modifier: @escaping (T) -> T) {
		getValueModifier = modifier
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



open class FormObservable<T>: Observable<T> {
	
	open var isValid: Bool
	private final let validation: (T) -> Bool
	
	open override func notify() {
		isValid = validation(value)
		super.notify()
	}
	
	public init(_ value: T, validation: @escaping (T) -> Bool) {
		self.validation = validation
		self.isValid = validation(value)
		super.init(value)
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
















public class Queue {
	
	private(set) var isRunning: Bool = false
	
	typealias Observer = Closure
	private var observers = [Observer]()
	
	func wait(callback: @escaping Observer) {
		observers ++= callback
	}
	
	func begin() {
		guard !isRunning else { return }
		isRunning = true
	}
	
	func end() {
		guard isRunning else { return }
		isRunning = false
		observers.forEach { $0() }
	}
}
