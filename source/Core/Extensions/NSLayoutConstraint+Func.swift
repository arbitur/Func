//
//  NSLayoutConstraint+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 26/Apr/17.
//
//

import Foundation





public extension NSLayoutConstraint {
	
	func activate() {
		if !self.isActive {
			self.isActive = true
		}
	}
	
	func deactivate() {
		if self.isActive {
			self.isActive = false
		}
	}
}



public struct LayoutItem {
	
	let view: UIView
	let attribute: NSLayoutAttribute
	
	
	
	@discardableResult
	public func equal(to item: LayoutItem, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: Float = 1000) -> NSLayoutConstraint {
		return constraint(relation: .equal, item: item, multiplier: multiplier, constant: constant, priority: priority)
	}
	
	@discardableResult
	public func equal(to constant: CGFloat, multiplier: CGFloat = 1, priority: Float = 1000) -> NSLayoutConstraint {
		return constraint(relation: .equal, item: nil, multiplier: multiplier, constant: constant, priority: priority)
	}
	
	@discardableResult
	public func greater(than item: LayoutItem, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: Float = 1000) -> NSLayoutConstraint {
		return constraint(relation: .greaterThanOrEqual, item: item, multiplier: multiplier, constant: constant, priority: priority)
	}
	
	@discardableResult
	public func greater(than constant: CGFloat, multiplier: CGFloat = 1, priority: Float = 1000) -> NSLayoutConstraint {
		return constraint(relation: .greaterThanOrEqual, item: nil, multiplier: multiplier, constant: constant, priority: priority)
	}
	
	@discardableResult
	public func less(than item: LayoutItem, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: Float = 1000) -> NSLayoutConstraint {
		return constraint(relation: .lessThanOrEqual, item: item, multiplier: multiplier, constant: constant, priority: priority)
	}
	
	@discardableResult
	public func less(than constant: CGFloat, multiplier: CGFloat = 1, priority: Float = 1000) -> NSLayoutConstraint {
		return constraint(relation: .lessThanOrEqual, item: nil, multiplier: multiplier, constant: constant, priority: priority)
	}
	
	
	@discardableResult
	public func equalToSuperview(_ constant: CGFloat = 0, multiplier: CGFloat = 1, priority: Float = 1000) -> NSLayoutConstraint {
		return constraintSuperview(relation: .equal, multiplier: multiplier, constant: constant, priority: priority)
	}
	
	@discardableResult
	public func greaterThanSuperview(_ constant: CGFloat = 0, multiplier: CGFloat = 1, priority: Float = 1000) -> NSLayoutConstraint {
		return constraintSuperview(relation: .greaterThanOrEqual, multiplier: multiplier, constant: constant, priority: priority)
	}
	
	@discardableResult
	public func lessThanSuperview(_ constant: CGFloat = 0, multiplier: CGFloat = 1, priority: Float = 1000) -> NSLayoutConstraint {
		return constraintSuperview(relation: .lessThanOrEqual, multiplier: multiplier, constant: constant, priority: priority)
	}
	
	
	private func constraintSuperview(relation: NSLayoutRelation, multiplier: CGFloat, constant: CGFloat, priority: Float) -> NSLayoutConstraint {
		guard let superview = view.superview else {
			fatalError("ERROR: \(view) lacks a superview")
		}
		
		return constraint(relation: relation, item: LayoutItem(view: superview, attribute: attribute), multiplier: multiplier, constant: constant, priority: priority)
	}
	
	private func constraint(relation: NSLayoutRelation, item: LayoutItem?, multiplier: CGFloat, constant: CGFloat, priority: Float) -> NSLayoutConstraint {
		let constraint: NSLayoutConstraint
		
		if let item = item {
			constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: item.view, attribute: item.attribute, multiplier: multiplier, constant: constant)
		}
		else {
			constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constant)
		}
		
		view.translatesAutoresizingMaskIntoConstraints = false
		constraint.priority = priority
		constraint.activate()
		
		return constraint
	}
}



public struct LAC {
	let view: UIView
	
	public func make(_ instructions: (LAC) -> ()) {
		instructions(self)
	}
	
	public var left:		LayoutItem { return LayoutItem(view: view, attribute: .left) }
	public var right:		LayoutItem { return LayoutItem(view: view, attribute: .right) }
	public var top:			LayoutItem { return LayoutItem(view: view, attribute: .top) }
	public var bottom:		LayoutItem { return LayoutItem(view: view, attribute: .bottom) }
//	public var leading:	LayoutItem { return LayoutItem(view: view, attribute: .leading) }
//	public var trailing:	LayoutItem { return LayoutItem(view: view, attribute: .trailing) }
	public var width:		LayoutItem { return LayoutItem(view: view, attribute: .width) }
	public var height:		LayoutItem { return LayoutItem(view: view, attribute: .height) }
	public var centerX:		LayoutItem { return LayoutItem(view: view, attribute: .centerX) }
	public var centerY:		LayoutItem { return LayoutItem(view: view, attribute: .centerY) }
//	public var lastBaseline: LayoutItem { return LayoutItem(view: view, attribute: .lastBaseline) }
//	
//	@available(iOS 8.0, *)
//	public var firstBaseline: LayoutItem			{ return LayoutItem(view: view, attribute: .firstBaseline) }
//	@available(iOS 8.0, *)
//	public var leftMargin: LayoutItem				{ return LayoutItem(view: view, attribute: .leftMargin) }
//	@available(iOS 8.0, *)
//	public var rightMargin: LayoutItem				{ return LayoutItem(view: view, attribute: .rightMargin) }
//	@available(iOS 8.0, *)
//	public var topMargin: LayoutItem				{ return LayoutItem(view: view, attribute: .topMargin) }
//	@available(iOS 8.0, *)
//	public var bottomMargin: LayoutItem			{ return LayoutItem(view: view, attribute: .bottomMargin) }
//	@available(iOS 8.0, *)
//	public var leadingMargin: LayoutItem			{ return LayoutItem(view: view, attribute: .leadingMargin) }
//	@available(iOS 8.0, *)
//	public var trailingMargin: LayoutItem			{ return LayoutItem(view: view, attribute: .trailingMargin) }
//	@available(iOS 8.0, *)
//	public var centerXWithinMargins: LayoutItem	{ return LayoutItem(view: view, attribute: .centerXWithinMargins) }
//	@available(iOS 8.0, *)
//	public var centerYWithinMargins: LayoutItem	{ return LayoutItem(view: view, attribute: .centerYWithinMargins) }
}


public extension UIView {
	
	var lac: LAC {
		return LAC(view: self)
	}
}














