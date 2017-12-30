//
//  Extensions.swift
//  Func
//
//  Created by Philip Fryklund on 25/Dec/17.
//

import Foundation





public extension UIView {
	
	var lac: ConstraintView {
		return ConstraintView(item: self)
	}
}


public extension UILayoutGuide {
	
	var lac: ConstraintLayoutGuide {
		return ConstraintLayoutGuide(item: self)
	}
}


public extension UILayoutSupport {
	
	var lac: ConstraintLayoutSupport {
		return ConstraintLayoutSupport(item: self)
	}
}


public extension UIView {
	
	func add(view: UIView, instructions: (ConstraintView) -> ()) {
		self.addSubview(view)
		view.lac.make(instructions)
	}
}

public extension UIStackView {
	
	func add(arrangedView: UIView, instructions: (ConstraintView) -> ()) {
		self.addArrangedSubview(arrangedView)
		arrangedView.lac.make(instructions)
	}
	
	func insert(arrangedView: UIView, at index: Int, instructions: (ConstraintView) -> ()) {
		self.insertArrangedSubview(arrangedView, at: index)
		arrangedView.lac.make(instructions)
	}
}
