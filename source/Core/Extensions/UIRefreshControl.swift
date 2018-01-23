//
//  UIRefreshControl.swift
//  Alamofire
//
//  Created by Philip Fryklund on 22/Jan/18.
//

import Foundation





public extension UIRefreshControl {
	
	func addTarget(_ target: Any?, action: Selector) {
		self.addTarget(target, action: action, for: .valueChanged)
	}
	
	
	func sendActions(animated: Bool) {
		if animated {
			self.beginRefreshing()
		}
		self.sendActions(for: .valueChanged)
	}
}
