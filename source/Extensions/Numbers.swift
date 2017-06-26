//
//  Numbers.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public protocol NumberType {
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
	init?(text: String)
	
	init(number: NumberType)
	func toDouble() -> Double
}

public protocol Arithmetics: NumberType {
	static func +(lhs: Self, rhs: Self) -> Self
	static func -(lhs: Self, rhs: Self) -> Self
	static func *(lhs: Self, rhs: Self) -> Self
	static func /(lhs: Self, rhs: Self) -> Self
	static func %(lhs: Self, rhs: Self) -> Self
}





public protocol IntegerNumber: Integer, Arithmetics {}
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
		var v = self
		if v < 0 {
			v = abs(v)
			v += (Self.pi - v)*2
		}
		return v * Self(57.29577951308232)//(Self(180.0) / Self.pi)
	}
	
	var rad: Self {
		return self * Self(0.017453292519943295)//(Self.pi / Self(180.0))
	}
	
	func ifNan(_ value: Self) -> Self {
		if self.isNaN {
			return value
		}
		return self
	}
	
	func shorten(decimals: Int) -> Self {
		let nr = Self(pow(10.0, Double(decimals)))
		let a = self * nr
		let b = a.rounded()
		return b / nr
	}
}



extension Int: IntegerNumber {
	public init(number: NumberType) {
		self.init(number.toDouble())
	}
	public init?(text: String) {
		self.init(text)
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension UInt: IntegerNumber {
	public init(number: NumberType) {
		self.init(number.toDouble())
	}
	public init?(text: String) {
		self.init(text)
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension Int8: IntegerNumber {
	public init(number: NumberType) {
		self.init(number.toDouble())
	}
	public init?(text: String) {
		self.init(text)
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension UInt8: IntegerNumber {
	public init(number: NumberType) {
		self.init(number.toDouble())
	}
	public init?(text: String) {
		self.init(text)
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension Int16: IntegerNumber {
	public init(number: NumberType) {
		self.init(number.toDouble())
	}
	public init?(text: String) {
		self.init(text)
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension UInt16: IntegerNumber {
	public init(number: NumberType) {
		self.init(number.toDouble())
	}
	public init?(text: String) {
		self.init(text)
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension Int32: IntegerNumber {
	public init(number: NumberType) {
		self.init(number.toDouble())
	}
	public init?(text: String) {
		self.init(text)
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension UInt32: IntegerNumber {
	public init(number: NumberType) {
		self.init(number.toDouble())
	}
	public init?(text: String) {
		self.init(text)
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension Int64: IntegerNumber {
	public init(number: NumberType) {
		self.init(number.toDouble())
	}
	public init?(text: String) {
		self.init(text)
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension UInt64: IntegerNumber {
	public init(number: NumberType) {
		self.init(number.toDouble())
	}
	public init?(text: String) {
		self.init(text)
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension Float: FloatingNumber {
	public init(number: NumberType) {
		self.init(number.toDouble())
	}
	public init?(text: String) {
		self.init(text)
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}

extension Double: FloatingNumber {
	public init(number: NumberType) {
		self = number.toDouble()
	}
	public init?(text: String) {
		self.init(text)
	}
	public func toDouble() -> Double {
		return self
	}
}

extension CGFloat: FloatingNumber {
	public init(number: NumberType) {
		self.init(number.toDouble())
	}
	public init?(text: String) {
		guard let v = NumberFormatter().number(from: text) else { return nil }
		self.init(v)
	}
	public func toDouble() -> Double {
		return Double(self)
	}
}




















