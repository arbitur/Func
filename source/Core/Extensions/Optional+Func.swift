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
			case .none: return "nil: \(Wrapped.self)"
			case .some(let d): return "\(d)"
		}
	}
}





extension Optional: Comparable where Wrapped: Comparable {
	
	// Optional <=> Optional
	
	public static func < (lhs: Optional<Wrapped>, rhs: Optional<Wrapped>) -> Bool {
		switch lhs {
		case .some(let v): return v < rhs
		case .none: return false
		}
	}
	
	public static func <= (lhs: Optional<Wrapped>, rhs: Optional<Wrapped>) -> Bool {
		switch lhs {
		case .some(let v): return v <= rhs
		case .none: return false
		}
	}
	
	public static func >= (lhs: Optional<Wrapped>, rhs: Optional<Wrapped>) -> Bool {
		switch lhs {
		case .some(let v): return v >= rhs
		case .none: return false
		}
	}
	
	public static func > (lhs: Optional<Wrapped>, rhs: Optional<Wrapped>) -> Bool {
		switch lhs {
		case .some(let v): return v > rhs
		case .none: return false
		}
	}
	
	
	// Optional <=> Wrapped
	
	public static func < (lhs: Optional<Wrapped>, rhs: Wrapped) -> Bool {
		switch lhs {
		case .some(let v): return v < rhs
		case .none: return false
		}
	}
	
	public static func <= (lhs: Optional<Wrapped>, rhs: Wrapped) -> Bool {
		switch lhs {
		case .some(let v): return v <= rhs
		case .none: return false
		}
	}
	
	public static func >= (lhs: Optional<Wrapped>, rhs: Wrapped) -> Bool {
		switch lhs {
		case .some(let v): return v >= rhs
		case .none: return false
		}
	}
	
	public static func > (lhs: Optional<Wrapped>, rhs: Wrapped) -> Bool {
		switch lhs {
		case .some(let v): return v > rhs
		case .none: return false
		}
	}
	
	
	// Wrapped <=> Optional
	
	public static func < (lhs: Wrapped, rhs: Optional<Wrapped>) -> Bool {
		switch rhs {
		case .some(let v): return lhs < v
		case .none: return false
		}
	}
	
	public static func <= (lhs: Wrapped, rhs: Optional<Wrapped>) -> Bool {
		switch rhs {
		case .some(let v): return lhs <= v
		case .none: return false
		}
	}
	
	public static func >= (lhs: Wrapped, rhs: Optional<Wrapped>) -> Bool {
		switch rhs {
		case .some(let v): return lhs >= v
		case .none: return false
		}
	}
	
	public static func > (lhs: Wrapped, rhs: Optional<Wrapped>) -> Bool {
		switch rhs {
		case .some(let v): return lhs > v
		case .none: return false
		}
	}
}
