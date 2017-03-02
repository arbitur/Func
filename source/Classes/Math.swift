//
//  Math.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public class Math {
	public static func ceil<T: Arithmetics>(number: T, base: T) -> T {
		return T(Darwin.ceil(Double(number: number) / Double(number: base))) * base
	}
	
	public static func round<T: Arithmetics>(number: T, base: T) -> T {
		return T(Darwin.round(Double(number: number) / Double(number: base))) * base
	}
	
	public static func floor<T: Arithmetics>(number: T, base: T) -> T {
		return T(Darwin.floor(Double(number: number) / Double(number: base))) * base
	}
	
	
	
	public static func hypotenusa<T: FloatingNumber>(nr1: T, nr2: T) -> T {
		return T(sqrt(pow(Double(number: nr1), 2) + pow(Double(number: nr2), 2)))
	}
	
	public static func hypotenusa(point: CGPoint) -> CGFloat {
		return hypotenusa(nr1: point.x, nr2: point.y)
	}
}

















