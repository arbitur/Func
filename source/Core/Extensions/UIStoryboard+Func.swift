//
//  UIStoryboard+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UIStoryboard {
	
	func viewController <T> (for id: String = "") -> T where T: UIViewController {
		if !id.isEmpty {
			return self.instantiateViewController(withIdentifier: id) as! T
		}
		
		return self.instantiateInitialViewController() as! T
	}
}
