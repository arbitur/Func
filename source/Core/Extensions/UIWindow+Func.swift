//
//  UIWindow+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UIWindow {
	
	static var current: UIWindow? {
		guard let window = UIApplication.shared.delegate?.window else {
			return nil
		}
		return window
	}
	
	
	
	var topViewController: UIViewController? {
		var vc = UIWindow.current?.rootViewController
		
		while true {
			let newVc: UIViewController?
			
			if let nav = vc as? UINavigationController {
				newVc = nav.visibleViewController
			}
			else if let tab = vc as? UITabBarController {
				newVc = tab.selectedViewController
			}
			else {
				newVc = vc?.presentedViewController
			}
			
			if newVc == nil { break }
			vc = newVc
		}
		
		return vc
	}
}
