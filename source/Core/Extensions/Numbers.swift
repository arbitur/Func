//
//  Numbers.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public protocol Number {
	init()
	init(_ v: Int)
	init(_ v: UInt)
	init(_ v: Int8)
	init(_ v: UInt8)
	init(_ v: Int16)
	init(_ v: UInt16)
	init(_ v: Int32)
	init(_ v: UInt32)
	init(_ v: Int64)
	init(_ v: UInt64)
	init(_ v: Float)
	init(_ v: Double)
	init(_ v: CGFloat)
	init?(_ string: String)

	// `number` as labeled parameter to rid of ambiguous inits
	init(number: Number)
	func toDouble() -> Double
}

public protocol Arithmetics: Number {
	static func + (lhs: Self, rhs: Self) -> Self
	static func - (lhs: Self, rhs: Self) -> Self
	static func * (lhs: Self, rhs: Self) -> Self
	static func / (lhs: Self, rhs: Self) -> Self
//	static func % (lhs: Self, rhs: Self) -> Self
}





public protocol IntegerNumber: BinaryInteger, Arithmetics {}
public extension IntegerNumber {
	
	var isEven: Bool  {
		return (self & 1) == 0
	}
	
	var isOdd: Bool  {
		return (self & 1) == 1
	}
}


public protocol FloatingNumber: FloatingPoint, Arithmetics {}
public extension FloatingNumber {
	
	static var max: Self { return self.greatestFiniteMagnitude }
	
	var deg: Self {
		return self * Self(180.0) / Self.pi
	}
	
	var rad: Self {
		return self *  Self.pi / Self(180.0)
	}
	
	func ifNan(_ value: Self) -> Self {
		return self.isNaN ? value : self
	}
	
	func shorten(decimals: Int) -> Self {
		let nr = Self(pow(10.0, Double(decimals)))
		let a = self * nr
		let b = a.rounded()
		return b / nr
	}
	
	static func % (lhs: Self, rhs: Self) -> Self {
		return lhs.remainder(dividingBy: rhs)
	}
}



extension Int: IntegerNumber {
	public init(number: Number) {
		self.init(number.toDouble())
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension UInt: IntegerNumber {
	public init(number: Number) {
		self.init(number.toDouble())
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension Int8: IntegerNumber {
	public init(number: Number) {
		self.init(number.toDouble())
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension UInt8: IntegerNumber {
	public init(number: Number) {
		self.init(number.toDouble())
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension Int16: IntegerNumber {
	public init(number: Number) {
		self.init(number.toDouble())
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension UInt16: IntegerNumber {
	public init(number: Number) {
		self.init(number.toDouble())
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension Int32: IntegerNumber {
	public init(number: Number) {
		self.init(number.toDouble())
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension UInt32: IntegerNumber {
	public init(number: Number) {
		self.init(number.toDouble())
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension Int64: IntegerNumber {
	public init(number: Number) {
		self.init(number.toDouble())
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension UInt64: IntegerNumber {
	public init(number: Number) {
		self.init(number.toDouble())
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension Float: FloatingNumber {
	public init(number: Number) {
		self.init(number.toDouble())
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension Double: FloatingNumber {
	public init(number: Number) {
		self = number.toDouble()
	}
	public func toDouble() -> Double {
		return self
	}
}

extension CGFloat: FloatingNumber {
	public init(number: Number) {
		self.init(number.toDouble())
	}
	public init?(_ string: String) {
		guard let v = Double(string) else {
			return nil
		}
		self.init(v)
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}




















