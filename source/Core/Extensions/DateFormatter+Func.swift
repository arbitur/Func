//
//  DateFormatter+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public extension DateFormatter {
	
	static func reformat(dateString: String, format old: String, newFormat new: String) -> String? {
		return Date(dateString, format: DateFormat(old))?.format(DateFormat(new))
	}
	
	
	
	convenience init(format: String) {
		self.init()
		self.dateFormat = format
	}
}
