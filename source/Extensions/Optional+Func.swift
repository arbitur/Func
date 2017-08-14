//
//  Optional.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Jul/17.
//
//

import Foundation





extension Optional: CustomStringConvertible {
	public var description: String {
		switch self {
			case .none: return "\(Wrapped.self)(nil)"
			case .some(let d): return "\(d)"
		}
	}
}
