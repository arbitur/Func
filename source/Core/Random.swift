//
//  Random.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation





public class Random {
	
	public static func range <T> (_ range: Range<T>) -> T where T: IntegerNumber {
		let min = range.lowerBound
		let max = range.upperBound
		return T(arc4random_uniform(UInt32(number: max - min))) + min
	}
	
	public static func range <T> (_ range: CountableClosedRange<T>) -> T where T: IntegerNumber {
		let min = range.lowerBound
		let max = range.upperBound
		return T(arc4random_uniform(UInt32(number: max - min))) + min
	}
	
	public static func range <T> (min: T, max: T) -> T where T: FloatingNumber {
		return (T(arc4random()) / T(UInt32.max)) * (max-min) + min
	}
	
	
	public static func flipCoin() -> Bool {
		return arc4random().isEven
	}
}





















