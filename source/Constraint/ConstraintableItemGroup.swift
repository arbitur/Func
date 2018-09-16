//
//  ConstraintableGroup.swift
//  Func
//
//  Created by Philip Fryklund on 25/Dec/17.
//

import Foundation





/// The Type used for first or second item with multiple attributes depending on `Item` (UIView or UILayoutSupport)
public protocol ConstraintItemGroup {
	associatedtype Item
	var item: Item { get }
	var attributes: [NSLayoutAttribute] { get }
	init(item: Item, attributes: [NSLayoutAttribute])
	
	func prepareItem()
	var superview: UIView? { get }
}


internal extension ConstraintItemGroup {
	
	func constraintTo(_ constant: ConstraintConstant, relation: NSLayoutRelation, multiplier: CGFloat, priority: UILayoutPriority) -> [NSLayoutConstraint] {
		prepareItem()
		
		return attributes.map { attribute in
			let constant: CGFloat = constant.constant(for: attribute)
			let constraint = NSLayoutConstraint.init(item: self.item, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constant)
			constraint.priority = priority
			constraint.activate()
			return constraint
		}
	}
	
	func constraintTo(_ item: ConstraintItemGroupTarget, constant: ConstraintConstant, relation: NSLayoutRelation, multiplier: CGFloat, priority: UILayoutPriority) -> [NSLayoutConstraint] {
		prepareItem()
		
		return attributes.map { attribute in
			let constant: CGFloat = constant.constant(for: attribute)
			let constraint = NSLayoutConstraint.init(item: self.item, attribute: attribute, relatedBy: relation, toItem: item, attribute: attribute, multiplier: multiplier, constant: constant)
			constraint.priority = priority
			constraint.activate()
			return constraint
		}
	}
	
	func constraintToSuperview(_ constant: ConstraintConstant, relation: NSLayoutRelation, multiplier: CGFloat, priority: UILayoutPriority) -> [NSLayoutConstraint] {
		guard let superview = superview else {
			fatalError("\(self.item) needs to have a parent for this operation")
		}
		
		return constraintTo(superview, constant: constant, relation: relation, multiplier: multiplier, priority: priority)
	}
}


public extension ConstraintItemGroup {
	
	@discardableResult
	public func equalTo(_ constant: ConstraintConstant, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
		return self.constraintTo(constant, relation: .equal, multiplier: multiplier, priority: priority)
	}
	@discardableResult
	public func equalTo <T: ConstraintItemGroupTarget> (_ item: T, constant: ConstraintConstant = 0, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
		return self.constraintTo(item, constant: constant, relation: .equal, multiplier: multiplier, priority: priority)
	}
	
	
	@discardableResult
	public func lessThan(_ constant: ConstraintConstant, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
		return self.constraintTo(constant, relation: .lessThanOrEqual, multiplier: multiplier, priority: priority)
	}
	@discardableResult
	public func lessThan <T: ConstraintItemGroupTarget> (_ item: T, constant: ConstraintConstant = 0, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
		return self.constraintTo(item, constant: constant, relation: .lessThanOrEqual, multiplier: multiplier, priority: priority)
	}
	
	
	@discardableResult
	public func greaterThan(_ constant: ConstraintConstant, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
		return self.constraintTo(constant, relation: .greaterThanOrEqual, multiplier: multiplier, priority: priority)
	}
	@discardableResult
	public func greaterThan <T: ConstraintItemGroupTarget> (_ item: T, constant: ConstraintConstant = 0, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
		return self.constraintTo(item, constant: constant, relation: .greaterThanOrEqual, multiplier: multiplier, priority: priority)
	}
	
	
	
	@discardableResult
	public func equalToSuperview(_ constant: ConstraintConstant = 0, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
		return self.constraintToSuperview(constant, relation: .equal, multiplier: multiplier, priority: priority)
	}
	
	@discardableResult
	public func lessThanSuperview(_ constant: ConstraintConstant = 0, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
		return self.constraintToSuperview(constant, relation: .lessThanOrEqual, multiplier: multiplier, priority: priority)
	}
	
	@discardableResult
	public func greaterThanSuperview(_ constant: ConstraintConstant = 0, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
		return self.constraintToSuperview(constant, relation: .greaterThanOrEqual, multiplier: multiplier, priority: priority)
	}
}





/// A Type as ConstraintItemGroup with Item UIView, can be first item
public struct ConstraintViewItemGroup: ConstraintItemGroup {
	public let item: UIView
	public var attributes: [NSLayoutAttribute]
	public var superview: UIView? {
		return item.superview
	}
	
	public init(item: UIView, attributes: [NSLayoutAttribute]) {
		self.item = item
		self.attributes = attributes
	}
	
	public func prepareItem() {
		item.translatesAutoresizingMaskIntoConstraints = false
	}
}





public struct ConstraintLayoutGuideItemGroup: ConstraintItemGroup {
	public let item: UILayoutGuide
	public var attributes: [NSLayoutAttribute]
	public var superview: UIView? {
		return item.owningView
	}
	
	public init(item: UILayoutGuide, attributes: [NSLayoutAttribute]) {
		self.item = item
		self.attributes = attributes
	}
	
	public func prepareItem() {
		superview?.translatesAutoresizingMaskIntoConstraints = false
	}
}





/// Type to restrict classes of second item for ConstraintItemGroup
public protocol ConstraintItemGroupTarget {}

extension UIView: ConstraintItemGroupTarget {}
extension UILayoutGuide: ConstraintItemGroupTarget {}
//extension UILayoutSupport: ConstraintItemGroupTarget {}

