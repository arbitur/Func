//
//  UIStoryboard+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UIStoryboard {
	
	func viewController <T: UIViewController> (for id: String? = nil) -> T {
		guard let id = id else {
			return self.instantiateInitialViewController() as! T
		}
		
		return self.instantiateViewController(withIdentifier: id) as! T
	}
}
