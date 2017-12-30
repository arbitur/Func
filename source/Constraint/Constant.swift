//
//  Constant.swift
//  Func
//
//  Created by Philip Fryklund on 25/Dec/17.
//

import Foundation





/// Make sure the intended value gets returned for NSLayoutConstraint's constant
public protocol ConstraintConstant {
	func constant(for attribute: NSLayoutAttribute) -> CGFloat
}


extension Int: ConstraintConstant {
	
	public func constant(for attribute: NSLayoutAttribute) -> CGFloat {
		return CGFloat(self)
	}
}

extension Double: ConstraintConstant {
	
	public func constant(for attribute: NSLayoutAttribute) -> CGFloat {
		return CGFloat(self)
	}
}

extension CGFloat: ConstraintConstant {
	
	public func constant(for attribute: NSLayoutAttribute) -> CGFloat {
		return self
	}
}

extension CGSize: ConstraintConstant {
	
	public func constant(for attribute: NSLayoutAttribute) -> CGFloat {
		switch attribute {
			case .width: return self.width
			case .height: return self.height
			default: fatalError("`CGSize` Should only be used for size")
		}
	}
}

extension CGPoint: ConstraintConstant {
	
	public func constant(for attribute: NSLayoutAttribute) -> CGFloat {
		switch attribute {
			case .centerX: return self.x
			case .centerY: return self.y
			default: fatalError("`CGPoint` Should only be used for points")
		}
	}
}

extension UIEdgeInsets: ConstraintConstant {
	
	public func constant(for attribute: NSLayoutAttribute) -> CGFloat {
		switch attribute {
			case .top: return self.top
			case .bottom: return -self.bottom
			case .left: return self.left
			case .right: return -self.left
			default: fatalError("`UIEdgeInsets` Should only be used for egdes")
		}
	}
}
