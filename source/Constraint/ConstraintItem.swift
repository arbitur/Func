//
//  ConstraintItem.swift
//  Func
//
//  Created by Philip Fryklund on 25/Dec/17.
//

import Foundation





/// The Type used for first or second item depending on `Item` (UIView or UILayoutSupport)
public protocol ConstraintItem {
	associatedtype Item
	var item: Item { get }
	var attribute: NSLayoutAttribute { get }
	init(item: Item, attribute: NSLayoutAttribute)
}


/// The Type used for first and second item `Item` (UIView)
public protocol ConstraintableConstraintItem: ConstraintItem {
	var superview: UIView? { get }
	func prepareItem()
}


internal extension ConstraintableConstraintItem {
	
	func constraintTo(_ constant: ConstraintConstant, relation: NSLayoutRelation, multiplier: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
		let constant: CGFloat = constant.constant(for: self.attribute)
		let constraint = NSLayoutConstraint.init(item: self.item, attribute: self.attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constant)
		constraint.priority = priority
		prepareItem()
		constraint.activate()
		return constraint
	}
	
	func constraintTo <T: ConstraintItem> (_ item: T, constant: ConstraintConstant, relation: NSLayoutRelation, multiplier: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
		let constant: CGFloat = constant.constant(for: self.attribute)
		let constraint = NSLayoutConstraint.init(item: self.item, attribute: self.attribute, relatedBy: relation, toItem: item.item, attribute: item.attribute, multiplier: multiplier, constant: constant)
		constraint.priority = priority
		prepareItem()
		constraint.activate()
		return constraint
	}
	
	func constraintToSuperview(_ constant: ConstraintConstant, relation: NSLayoutRelation, multiplier: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
		guard let superview = superview else {
			fatalError("\(self.item) needs to have a parent for this operation")
		}
		
		let item = ConstraintViewItem(item: superview, attribute: attribute)
		return constraintTo(item, constant: constant, relation: relation, multiplier: multiplier, priority: priority)
	}
}


public extension ConstraintableConstraintItem {
	
	@discardableResult
	public func equalTo(_ constant: ConstraintConstant, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
		return self.constraintTo(constant, relation: .equal, multiplier: multiplier, priority: priority)
	}
	@discardableResult
	public func equalTo <T: ConstraintItem> (_ item: T, constant: ConstraintConstant = 0, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
		return self.constraintTo(item, constant: constant, relation: .equal, multiplier: multiplier, priority: priority)
	}
	
	
	@discardableResult
	public func lessThan(_ constant: ConstraintConstant, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
		return self.constraintTo(constant, relation: .lessThanOrEqual, multiplier: multiplier, priority: priority)
	}
	@discardableResult
	public func lessThan <T: ConstraintItem> (_ item: T, constant: ConstraintConstant = 0, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
		return self.constraintTo(item, constant: constant, relation: .lessThanOrEqual, multiplier: multiplier, priority: priority)
	}
	
	
	@discardableResult
	public func greaterThan(_ constant: ConstraintConstant, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
		return self.constraintTo(constant, relation: .greaterThanOrEqual, multiplier: multiplier, priority: priority)
	}
	@discardableResult
	public func greaterThan <T: ConstraintItem> (_ item: T, constant: ConstraintConstant = 0, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
		return self.constraintTo(item, constant: constant, relation: .greaterThanOrEqual, multiplier: multiplier, priority: priority)
	}
	
	
	
	@discardableResult
	public func equalToSuperview(_ constant: ConstraintConstant = 0, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
		return self.constraintToSuperview(constant, relation: .equal, multiplier: multiplier, priority: priority)
	}
	
	@discardableResult
	public func lessThanSuperview(_ constant: ConstraintConstant = 0, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
		return self.constraintToSuperview(constant, relation: .lessThanOrEqual, multiplier: multiplier, priority: priority)
	}
	
	@discardableResult
	public func greaterThanSuperview(_ constant: ConstraintConstant = 0, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
		return self.constraintToSuperview(constant, relation: .greaterThanOrEqual, multiplier: multiplier, priority: priority)
	}
}





/// A Type as ConstraintItem with Item UIView, can be first item
public struct ConstraintViewItem: ConstraintableConstraintItem {
	public let item: UIView
	public var attribute: NSLayoutAttribute
	public var superview: UIView? {
		return item.superview
	}
	
	public init(item: UIView, attribute: NSLayoutAttribute) {
		self.item = item
		self.attribute = attribute
	}
	
	public func prepareItem() {
		item.translatesAutoresizingMaskIntoConstraints = false
	}
}





/// A Type as ConstraintItem with Item UILayoutGuide, can be first item
public struct ConstraintLayoutGuideItem: ConstraintableConstraintItem {
	public let item: UILayoutGuide
	public var attribute: NSLayoutAttribute
	public var superview: UIView? {
		return item.owningView
	}
	
	public init(item: UILayoutGuide, attribute: NSLayoutAttribute) {
		self.item = item
		self.attribute = attribute
	}
	
	public func prepareItem() {
		item.owningView?.translatesAutoresizingMaskIntoConstraints = false
	}
}




/// A Type as ConstraintItem with Item UILayoutSupport, cannot be first item
public struct ConstraintLayoutSupportItem: ConstraintItem {
	public let item: UILayoutSupport
	public var attribute: NSLayoutAttribute
	
	public init(item: UILayoutSupport, attribute: NSLayoutAttribute) {
		self.item = item
		self.attribute = attribute
	}
}
