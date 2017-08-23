//
//  UIResponder+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import UIKit





public extension UIResponder {
	private static var currentFirstResponder: UIResponder?
	
	static var first: UIResponder? {
		currentFirstResponder = nil
		UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(sender:)), to: nil, from: nil, for: nil)
		return currentFirstResponder
	}
	
	private dynamic func findFirstResponder(sender: AnyObject) {
		UIResponder.currentFirstResponder = self
	}
	
	
	
	var superViewController: UIViewController? {
		var parentResponder: UIResponder? = self
		
		while let responder = parentResponder {
			parentResponder = responder.next
			
			if let viewController = parentResponder as? UIViewController {
				return viewController
			}
		}
		
		return nil
	}
}
