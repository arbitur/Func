//
//  UINavigationController+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UINavigationController {
	
	var rootViewController: UIViewController? {
		get { return self.viewControllers.first }
		set {
			if let newValue = newValue {
				self.setViewControllers([newValue], animated: false)
			}
			else {
				self.setViewControllers([], animated: false)
			}
		}
	}
	
	func popToRootViewController(animated: Bool, completion: @escaping (UINavigationController)->()) {
		CATransaction.setCompletionBlock({ completion(self) })
		CATransaction.begin()
		self.popToRootViewController(animated: animated)
		CATransaction.commit()
	}
	
	func popToViewController(viewController: UIViewController, animated: Bool, completion: @escaping (UINavigationController)->()) {
		CATransaction.setCompletionBlock({ completion(self) })
		CATransaction.begin()
		self.popToViewController(viewController, animated: animated)
		CATransaction.commit()
	}
	
	func popViewController(animated: Bool, completion: @escaping (UINavigationController)->()) {
		CATransaction.setCompletionBlock({ completion(self) })
		CATransaction.begin()
		self.popViewController(animated: animated)
		CATransaction.commit()
	}
	
	func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping (UINavigationController)->()) {
		CATransaction.setCompletionBlock({ completion(self) })
		CATransaction.begin()
		self.pushViewController(viewController, animated: animated)
		CATransaction.commit()
	}
	
	
	
	func index(of viewController: UIViewController) -> Int? {
		return self.viewControllers.index(of: viewController)
	}
}
