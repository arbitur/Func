//
//  UIAlertController+Func.swift
//  Func
//
//  Created by Philip Fryklund on 2021-02-26.
//

import UIKit



public extension UIAlertController {
	
	@discardableResult
	func addDefault(title: String, handler: Closure?) -> UIAlertAction {
		let action = UIAlertAction(title: title, style: .default) { _ in handler?() }
		self.addAction(action)
		return action
	}
	
	@discardableResult
	func addDestructive(title: String, handler: Closure?) -> UIAlertAction {
		let action = UIAlertAction(title: title, style: .destructive) { _ in handler?() }
		self.addAction(action)
		return action
	}
	
	@discardableResult
	func addCancel(title: String, handler: Closure?) -> UIAlertAction {
		let action = UIAlertAction(title: title, style: .cancel) { _ in handler?() }
		self.addAction(action)
		return action
	}
}

