//
//  Optional.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Jul/17.
//
//

import Foundation





extension Optional {
	
	// Why? Remove it
	var isNil: Bool {
		switch self {
			case .none: return true
			case .some: return false
		}
	}
	
	
	
}

extension Optional: CustomStringConvertible {
	
	public var description: String {
		switch self {
			case .none: return "\(Wrapped.self)(nil)"
			case .some(let d): return "\(d)"
		}
	}
}
