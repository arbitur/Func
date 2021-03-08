//
//  DebugTimer.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import Foundation
import Darwin.Mach.mach_time





public struct DebugTimer {
	
	private static let base: UInt64 = {
		var base = mach_timebase_info(numer: 0, denom: 0)
		mach_timebase_info(&base)
		return UInt64(base.numer / base.denom)
	}()
	
	private let start: UInt64
	
	
	
	public func nano() -> UInt64 {
		return (mach_absolute_time() - start) * DebugTimer.base
	}
	
	public func micro() -> UInt64 {
		return nano() / 1000
	}
	
	public func milli() -> UInt64 {
		return micro() / 1000
	}
	
	
	
	public func formatNano() -> String {
		return "\(nano()) ns"
	}
	
	public func formatMicro() -> String {
		return "\(micro()) us"
	}
	
	public func formatMilli() -> String {
		return "\(milli()) ms"
	}
	
	
	
	public init() {
		start = mach_absolute_time()
	}
}

