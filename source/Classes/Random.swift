//
//  Random.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public class Random {
	public static func range<T: IntegerNumber>(_ range: Range<T>) -> T {
		let min = range.lowerBound
		let max = range.upperBound
		return T(arc4random_uniform(UInt32(number: max - min))) + min
	}
	
	public static func range<T: FloatingNumber>(min: T, max: T) -> T {
		return (T(arc4random()) / T(UInt32.max)) * (max-min) + min
	}
}





















