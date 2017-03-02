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
	
	
	
	
	func format(_ format: Format = .dateTime) -> String {
		return DateFormatter(format: format.format).string(from: self)
	}
	
	
	
	init?(_ string: String, format: Format) {
		if let date = DateFormatter(format: format.format).date(from: string) {
			self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
		}
		else {
			return nil
		}
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
	
	public enum Format {
		case date
		case time
		case dateTime
		case dateTimeSec
		case custom(String)
		
		fileprivate var format: String {
			switch self {
				case .date:				return "yyyy-MM-dd"
				case .time:				return "HH:mm"
				case .dateTime:			return "yyyy-MM-dd HH:mm"
				case .dateTimeSec:		return "yyyy-MM-dd HH:mm:ss"
				case .custom(let f):	return f
			}
		}
	}
	
}


public extension Date {
	
	public enum Component {
		case year(Int)
		case month(Int)
		case week(Int)
		case day(Int)
		
		case hour(Int)
		case minute(Int)
		case second(Int)
		
		
		fileprivate var properties: (component: Calendar.Component, value: Int) {
			switch self {
				case .year(let v):		return (.year, v)
				case .month(let v):		return (.month, v)
				case .week(let v):		return (.weekOfYear, v)
				case .day(let v):		return (.day, v)
				
				case .hour(let v):		return (.hour, v)
				case .minute(let v):	return (.minute, v)
				case .second(let v):	return (.second, v)
			}
		}
	}
	
}










public func + (date: Date, components: [Date.Component]) -> Date {
	var date = date
	
	for component in components {
		let (c, v) = component.properties
		date = Calendar.current.date(byAdding: c, value: v, to: date)!
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
		let (c, v) = component.properties
		date = Calendar.current.date(byAdding: c, value: -v, to: date)!
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











