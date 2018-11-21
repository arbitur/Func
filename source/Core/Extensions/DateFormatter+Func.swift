//
//  DateFormatter+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public extension DateFormatter {
	
	static func reformat(dateString: String, format old: DateFormat, newFormat new: DateFormat) -> String? {
		return Date(dateString, format: old)?.format(new)
	}
	
	
	
	convenience init(format: String, locale: Locale) {
		self.init()
		self.locale = locale
		self.dateFormat = format
	}
	
	convenience init(style: Style) {
		self.init()
		self.timeStyle = style
		self.dateStyle = style
	}
	
	convenience init(dateStyle: Style, timeStyle: Style) {
		self.init()
		self.dateStyle = dateStyle
		self.timeStyle = timeStyle
	}
}
