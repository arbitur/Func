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
		if let w = UIApplication.shared.delegate?.window, let window = w {
			return window
		}
		return nil
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
