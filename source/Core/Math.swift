//
//  Math.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public class Math {

	public static func ceil<T>(_ value: T, base: T) -> T where T: FloatingPoint {
		return Darwin.ceil(value / base) * base
	}


	public static func round<T>(_ value: T, base: T) -> T where T: FloatingPoint {
		return Darwin.round(value / base) * base
	}


	public static func floor<T>(_ value: T, base: T) -> T where T: FloatingPoint {
		return Darwin.floor(value / base) * base
	}

}
