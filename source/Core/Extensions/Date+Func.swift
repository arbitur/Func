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
	
	static var now: Date {
		return Date()
	}
	
	
	
	func format(_ format: DateFormat = .dateTime, locale: Locale = Locale(identifier: "en_US_POSIX")) -> String {
		return DateFormatter.init(format: format.rawValue, locale: locale).string(from: self)
	}
	
	func format(style: DateFormatter.Style, locale: Locale? = nil) -> String {
		return DateFormatter.init(style: style, locale: locale).string(from: self)
	}
	
	func format(date dateStyle: DateFormatter.Style, time timeStyle: DateFormatter.Style, locale: Locale? = nil) -> String {
		return DateFormatter.init(dateStyle: dateStyle, timeStyle: timeStyle, locale: locale).string(from: self)
	}
	
	
	/// Reversed order of Date.timeIntervalSince(_:)
	func timeIntervalUntil(_ date: Date) -> TimeInterval {
		return date.timeIntervalSince(self)
	}
	
	
	
	init?(_ string: String, format: DateFormat = .dateTime, locale: Locale = Locale(identifier: "en_US_POSIX")) {
		guard let date = DateFormatter(format: format.rawValue, locale: locale).date(from: string) else {
			return nil
		}
		self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
	}
	
	
//	init?(_ string: String, style: DateFormatter.Style) {
//		guard let date = DateFormatter(style: style).date(from: string) else {
//			return nil
//		}
//		self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
//	}
	
	
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
	
	subscript (component: Calendar.Component) -> Int {
		get { return Calendar.current.component(component, from: self) }
		set {
			let diff = newValue - self[component]
			self = Calendar.current.date(byAdding: component, value: diff, to: self)!
		}
	}
	
	
	// Conveniences
	
	var year: Int {
		get { return self[.year] }
		set { self[.year] = newValue }
	}
	
	var month: Int {
		get { return self[.month] }
		set { self[.month] = newValue }
	}
	
	var week: Int {
		get { return self[.weekOfYear] }
		set { self[.weekOfYear] = newValue }
	}
	
	var day: Int {
		get { return self[.day] }
		set { self[.day] = newValue }
	}
	
	var hour: Int {
		get { return self[.hour] }
		set { self[.hour] = newValue }
	}
	
	var minute: Int {
		get { return self[.minute] }
		set { self[.minute] = newValue }
	}
	
	var second: Int {
		get { return self[.second] }
		set { self[.second] = newValue }
	}
}





public extension Date {
	
	enum Component {
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











