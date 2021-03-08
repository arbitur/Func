//
//  Constraintable.swift
//  Func
//
//  Created by Philip Fryklund on 25/Dec/17.
//

import Foundation





/// A Type that is able to be first or second item for NSLayoutConstraint
public protocol Constraintable {
	associatedtype Item
	var item: Item { get }
}





/// A Type that is able to add constraints to all NSLayoutAttribute's
public protocol FullyConstraintable: Constraintable {
	associatedtype ConstraintItemType: ConstraintItem
	associatedtype ConstraintItemGroupType: ConstraintItemGroup
}


public extension FullyConstraintable where Self.Item == ConstraintItemType.Item, Self.Item == ConstraintItemGroupType.Item {
	
	var left: ConstraintItemType { return ConstraintItemType(item: item, attribute: .left) }
	var right: ConstraintItemType { return ConstraintItemType(item: item, attribute: .right) }
	var top: ConstraintItemType { return ConstraintItemType(item: item, attribute: .top) }
	var bottom: ConstraintItemType { return ConstraintItemType(item: item, attribute: .bottom) }
	var width: ConstraintItemType { return ConstraintItemType(item: item, attribute: .width) }
	var height: ConstraintItemType { return ConstraintItemType(item: item, attribute: .height) }
	var centerX: ConstraintItemType { return ConstraintItemType(item: item, attribute: .centerX) }
	var centerY: ConstraintItemType { return ConstraintItemType(item: item, attribute: .centerY) }
	
	// Im not really using these anyways
//	public var leading: ConstraintItemType { return ConstraintItemType(item: item, attribute: .leading) }
//	public var trailing: ConstraintItemType { return ConstraintItemType(item: item, attribute: .trailing) }
//	public var lastBaseline: ConstraintItemType { return ConstraintItemType(item: item, attribute: .lastBaseline) }
//	public var leftMargin: ConstraintItemType { return ConstraintItemType(item: item, attribute: .leftMargin) }
//	public var rightMargin: ConstraintItemType { return ConstraintItemType(item: item, attribute: .rightMargin) }
//	public var topMargin: ConstraintItemType { return ConstraintItemType(item: item, attribute: .topMargin) }
//	public var bottomMargin: ConstraintItemType { return ConstraintItemType(item: item, attribute: .bottomMargin) }
//	public var leadingMargin: ConstraintItemType { return ConstraintItemType(item: item, attribute: .leadingMargin) }
//	public var trailingMargin: ConstraintItemType { return ConstraintItemType(item: item, attribute: .trailingMargin) }
//	public var centerXWithinMargins: ConstraintItemType { return ConstraintItemType(item: item, attribute: .centerXWithinMargins) }
//	public var centerYWithinMargins: ConstraintItemType { return ConstraintItemType(item: item, attribute: .centerYWithinMargins) }
	
	
	
	/// Return a new ConstraintItemGroup
	subscript (_ attributes: NSLayoutConstraint.Attribute...) -> ConstraintItemGroupType {
		return ConstraintItemGroupType(item: item, attributes: attributes)
	}
	var horizontalEdges: ConstraintItemGroupType { return ConstraintItemGroupType(item: item, attributes: [.right, .left]) }
	var verticalEdges: ConstraintItemGroupType { return ConstraintItemGroupType(item: item, attributes: [.top, .bottom]) }
	var edges: ConstraintItemGroupType { return ConstraintItemGroupType(item: item, attributes: [.top, .left, .bottom, .right]) }
	var edgesMargin: ConstraintItemGroupType { return ConstraintItemGroupType(item: item, attributes: [.topMargin, .leftMargin, .bottomMargin, .rightMargin]) }
	var center: ConstraintItemGroupType { return ConstraintItemGroupType(item: item, attributes: [.centerX, .centerY]) }
	var size: ConstraintItemGroupType { return ConstraintItemGroupType(item: item, attributes: [.width, .height]) }
	
	
	/// Closure for multiple constraints on same first item
	func make(_ instructions: (Self) -> ()) {
		instructions(self)
	}
}


/// Convenience methods
public extension FullyConstraintable where Self.Item == ConstraintItemType.Item, Self.Item == ConstraintItemGroupType.Item, Self.ConstraintItemType: ConstraintableConstraintItem {
	
	/// height = width * multiplier
	@discardableResult
	func aspectRatio(_ multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
		return self.height.equalTo(self.width, multiplier: multiplier)
	}
}





/// Exposes the ConstraintItem's to be added to NSLayoutConstraints, fits Swift 3 Design Guidelines
public struct ConstraintView: FullyConstraintable {
	public var item: UIView
	public typealias ConstraintItemType = ConstraintViewItem
	public typealias ConstraintItemGroupType = ConstraintViewItemGroup
}





/// Exposes the ConstraintItem's to be added to NSLayoutConstraints, fits Swift 3 Design Guidelines
public struct ConstraintLayoutGuide: FullyConstraintable {
	public var item: UILayoutGuide
	public typealias ConstraintItemType = ConstraintLayoutGuideItem
	public typealias ConstraintItemGroupType = ConstraintLayoutGuideItemGroup
}





/// Exposes the ConstraintItem's to be added to NSLayoutConstraints, fits Swift 3 Design Guidelines
public struct ConstraintLayoutSupport: Constraintable {
	public var item: UILayoutSupport
	public typealias ConstraintItemType = ConstraintLayoutSupportItem
	
	
	public var top: ConstraintItemType { return ConstraintItemType(item: item, attribute: .top) }
	public var height: ConstraintItemType { return ConstraintItemType(item: item, attribute: .height) }
	public var bottom: ConstraintItemType { return ConstraintItemType(item: item, attribute: .bottom) }
}
