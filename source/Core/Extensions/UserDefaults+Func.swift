//
//  UserDefaults+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public extension UserDefaults {
	
	/// Clears all saved data
	func clear() {
		self.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
		self.synchronize()
	}
}
