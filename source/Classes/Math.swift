//
//  Math.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public class Math {
	public static func ceil <T> (_ value: T, base: T) -> T where T: Arithmetics {
		return T(Darwin.ceil(Double(number: value) / Double(number: base))) * base
	}
	
	public static func round <T> (_ value: T, base: T) -> T where T: Arithmetics {
		return T(Darwin.round(Double(number: value) / Double(number: base))) * base
	}
	
	public static func floor <T> (_ value: T, base: T) -> T where T: Arithmetics {
		return T(Darwin.floor(Double(number: value) / Double(number: base))) * base
	}
	
	
	
	public static func hypotenusa <T> (nr1: T, nr2: T) -> T where T: FloatingNumber {
		return T(sqrt(pow(Double(number: nr1), 2) + pow(Double(number: nr2), 2)))
	}
	
	public static func hypotenusa(point: CGPoint) -> CGFloat {
		return hypotenusa(nr1: point.x, nr2: point.y)
	}
}

















