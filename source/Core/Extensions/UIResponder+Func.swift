//
//  UIResponder+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import UIKit





public extension UIResponder {
	
	private static weak var currentFirstResponder: UIResponder?
	
	public static var first: UIResponder? {
		currentFirstResponder = nil
		UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(sender:)), to: nil, from: nil, for: nil)
		return currentFirstResponder
	}
	
	@objc private func findFirstResponder(sender: AnyObject) {
		UIResponder.currentFirstResponder = self
	}
}
