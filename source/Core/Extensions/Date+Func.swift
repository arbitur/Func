//
//  Date+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public extension Date {
//	var components: Date.Components {
//		let calendar = Calendar.current
//		return calendar.dateComponents(in: calendar.timeZone, from: self)
//	}
//
//	
//	
//	func getComponents(_ units: Set<Calendar.Component>) -> Date.Components {
//		return Calendar.current.dateComponents(units, from: self)
//	}
	
	public static var now: Date {
		return Date()
	}
	
	
	
	func format(_ format: DateFormat = .dateTime) -> String {
		return DateFormatter.init(format: format.rawValue).string(from: self)
	}
	
	func format(_ style: DateFormatter.Style) -> String {
		return DateFormatter.init(style: style).string(from: self)
	}
	
	func format(_ dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
		return DateFormatter.init(dateStyle: dateStyle, timeStyle: timeStyle).string(from: self)
	}
	
	
	
	init?(_ string: String, format: DateFormat = .dateTime) {
		guard let date = DateFormatter(format: format.rawValue).date(from: string) else {
			return nil
		}
		self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
	}
	
	
	init?(_ string: String, style: DateFormatter.Style) {
		guard let date = DateFormatter(style: style).date(from: string) else {
			return nil
		}
		self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
	}
	
	
	init?(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int = 0, second: Int = 0) {
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = hour
		components.minute = minute
		components.second = second
		components.nanosecond = 0
		
		guard let date = Calendar.current.date(from: components) else {
			return nil
		}
		self = date
	}
}



public struct DateFormat: ExpressibleByStringLiteral {
	public static let date: DateFormat = "yyyy-MM-dd"
	public static let time: DateFormat = "HH:mm"
	public static let dateTime: DateFormat = "yyyy-MM-dd HH:mm"
	
	public let rawValue: String
	
	public init(_ rawValue: String) {
		self.rawValue = rawValue
	}
	
	public init(stringLiteral value: StringLiteralType) {
		self.rawValue = value
	}
}





public extension Date {
	
	private var components: DateComponents {
		return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
	}

	
	
	var year: Int {
		get { return Calendar.current.component(.year, from: self) }
		set {
			var c = self.components
			c.year = newValue
			self = Calendar.current.date(from: c)!
		}
	}
	
	var month: Int {
		get { return Calendar.current.component(.month, from: self) }
		set {
			var c = self.components
			c.month = newValue
			self = Calendar.current.date(from: c)!
		}
	}
	
	var week: Int {
		get { return Calendar.current.component(.weekOfYear, from: self) }
		set {
			var c = self.components
			c.weekOfYear = newValue
			self = Calendar.current.date(from: c)!
		}
	}
	
	var day: Int {
		get { return Calendar.current.component(.day, from: self) }
		set {
			var c = self.components
			c.day = newValue
			self = Calendar.current.date(from: c)!
		}
	}
	
	var hour: Int {
		get { return Calendar.current.component(.hour, from: self) }
		set {
			var c = self.components
			c.hour = newValue
			self = Calendar.current.date(from: c)!
		}
	}
	
	var minute: Int {
		get { return Calendar.current.component(.minute, from: self) }
		set {
			var c = self.components
			c.minute = newValue
			self = Calendar.current.date(from: c)!
		}
	}
	
	var second: Int {
		get { return Calendar.current.component(.second, from: self) }
		set {
			var c = self.components
			c.second = newValue
			self = Calendar.current.date(from: c)!
		}
	}
	
}





public extension Date {
	
	public enum Component {
		case years(Int)
		case months(Int)
		case weeks(Int)
		case days(Int)
		
		case hours(Int)
		case minutes(Int)
		case seconds(Int)
		case milliseconds(Int)
		
		
		fileprivate var properties: (component: Calendar.Component, value: Int) {
			switch self {
				case .years(let v)			: return (.year, v)
				case .months(let v)			: return (.month, v)
				case .weeks(let v)			: return (.weekOfYear, v)
				case .days(let v)			: return (.day, v)
				
				case .hours(let v)			: return (.hour, v)
				case .minutes(let v)		: return (.minute, v)
				case .seconds(let v)		: return (.second, v)
				case .milliseconds(let v)	: return (.nanosecond, v * 1_000_000)
			}
		}
	}
	
}



public func + (date: Date, components: [Date.Component]) -> Date {
	var date = date
	
	for component in components {
		date += component
	}
	
	return date
}

public func + (date: Date, component: Date.Component) -> Date {
	let (c, v) = component.properties
	return Calendar.current.date(byAdding: c, value: v, to: date)!
}



public func - (date: Date, components: [Date.Component]) -> Date {
	var date = date
	
	for component in components {
		date -= component
	}
	
	return date
}

public func - (date: Date, component: Date.Component) -> Date {
	let (c, v) = component.properties
	return Calendar.current.date(byAdding: c, value: -v, to: date)!
}



public func += (date: inout Date, components: [Date.Component]) {
	date = date + components
}

public func += (date: inout Date, component: Date.Component) {
	date = date + component
}



public func -= (date: inout Date, components: [Date.Component]) {
	date = date - components
}

public func -= (date: inout Date, component: Date.Component) {
	date = date - component
}

















//public func + (date: Date, time: Double) -> Date {
//	return date.addingTimeInterval(time)
//}
//
//public func - (date: Date, time: TimeInterval) -> Date {
//	return date.addingTimeInterval(-time)
//}
//
//public func += (date: inout Date, time: TimeInterval) {
//	date = date.addingTimeInterval(time)
//}
//
//public func -= (date: inout Date, time: TimeInterval) {
//	date = date.addingTimeInterval(-time)
//}











