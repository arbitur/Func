//
//  Math.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public class Math {

	public static func ceil <T: FloatingPoint> (_ value: T, base: T) -> T {
		return Darwin.ceil(value / base) * base
	}


	public static func round <T: FloatingPoint> (_ value: T, base: T) -> T {
		return Darwin.round(value / base) * base
	}


	public static func floor <T: FloatingPoint> (_ value: T, base: T) -> T {
		return Darwin.floor(value / base) * base
	}

}
