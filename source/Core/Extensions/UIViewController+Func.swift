//
//  UIViewController+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UIViewController {
	
	func present(_ viewController: UIViewController) {
		self.present(viewController, animated: true, completion: nil)
	}
	
	
	
	func canPerformSegue(id: String) -> Bool {
		let segues = self.value(forKey: "storyboardSegueTemplates") as? [NSObject]
		let filtered = segues?.filter { $0.value(forKey: "identifier") as? String == id }
		
		return (filtered?.count ?? 0) > 0
	}
	
	func performSegue(id: String, sender: Any?) -> Bool {
		if canPerformSegue(id: id) {
			self.performSegue(withIdentifier: id, sender: sender)
			return true
		}
		return false
	}
}
