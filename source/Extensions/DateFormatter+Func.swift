//
//  DateFormatter+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public extension DateFormatter {
	static func reformatDateString(_ dateString: String, oldFormat old: String, newFormat new: String) -> String {
		return Date(dateString, format: .custom(old))!.format(.custom(new))
	}
	
	
	
	convenience init(format: String) {
		self.init()
		self.dateFormat = format
	}
}
