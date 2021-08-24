//
//  NotificationCenter+Func.swift
//  Func
//
//  Created by Philip Fryklund on 2021-04-03.
//

import Foundation


public extension NotificationCenter {
	
	/// Keep a strong reference to returned object, once that object gets released the observer will be removed.
	func observe(_ name: Notification.Name?, object: Any? = nil, queue: OperationQueue? = nil, using block: @escaping (Notification) -> Void) -> AnyObject {
		let token = self.addObserver(forName: name, object: object, queue: nil, using: block)
		return NotificationToken(notificationCenter: self, token: token)
	}
}


private class NotificationToken {
	private let notificationCenter: NotificationCenter
	private let token: Any
	
	init(notificationCenter: NotificationCenter = .default, token: Any) {
		self.notificationCenter = notificationCenter
		self.token = token
	}
	
	deinit {
		notificationCenter.removeObserver(token)
	}
}
