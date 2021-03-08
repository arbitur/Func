//
//  FuncExampleTests.swift
//  FuncExampleTests
//
//  Created by Philip Fryklund on 15/Aug/17.
//  Copyright © 2017 Arbitur. All rights reserved.
//

import XCTest
@testable import Func





class ArrayTests: XCTestCase {

	func test() {

		let arr = [1,2,3]
		XCTAssertTrue(arr.random ?== arr)

		XCTAssertEqual(["hej", "värld"].joined(by: " "), "hej värld")
	}


    func testSafe() {
		let ints = [1,2,3,4]
		let doubles = [0.0, 1.0, 1.5, 1.75, 2.0]
		let strings = ["a","b","c","d"]

		XCTAssertNotNil(ints[safe: 2])
		XCTAssertNil(ints[safe: -5])

		XCTAssertNotNil(doubles[safe: 2])
		XCTAssertNil(doubles[safe: 50])

		XCTAssertNotNil(strings[safe: 2])
		XCTAssertNil(strings[safe: 50])
	}


	func testSplit() {
		let ints1 = [1,2,3,4].split()
		let doubles1 = [0.0, 1.0, 1.5, 1.75, 2.0].split()
		let strings1 = ["a","b","c","d"].split()

		XCTAssertEqual(ints1.first, [1,2])
		XCTAssertEqual(ints1.last, [3,4])
		XCTAssertEqual(doubles1.first, [0.0, 1.0, 1.5])
		XCTAssertEqual(doubles1.last, [1.75, 2.0])
		XCTAssertEqual(strings1.first, ["a","b"])
		XCTAssertEqual(strings1.last, ["c","d"])

		let ints2 = [1,2,3,4].split(arrays: 2)
		let doubles2 = [0.0, 1.0, 1.5, 1.75, 2.0].split(arrays: 3)
		let strings2 = ["a","b","c","d"].split(arrays: 10)

		XCTAssertEqual(ints2, [[1,2], [3,4]])
		XCTAssertEqual(doubles2, [[0.0, 1.0], [1.5, 1.75], [2.0]])
		XCTAssertEqual(strings2, [["a"], ["b"], ["c"], ["d"], [], [], [], [], [], []])

		let ints3 = [1,2,3,4].split(capacity: 2)
		let doubles3 = [0.0, 1.0, 1.5, 1.75, 2.0].split(capacity: 3)
		let strings3 = ["a","b","c","d"].split(capacity: 10)

		XCTAssertEqual(ints3, [[1,2], [3,4]])
		XCTAssertEqual(doubles3, [[0.0, 1.0, 1.5], [1.75, 2.0]])
		XCTAssertEqual(strings3, [["a","b","c","d"]])
	}


	func testAppendRemove() {
		var arr = [1,2,3,4,5,6]
		arr.remove(to: 3)
		XCTAssertEqual(arr, [4,5,6])
		arr.remove(from: 1)
		XCTAssertEqual(arr, [4])
		arr.remove(element: 4)
		XCTAssertEqual(arr, [])

		arr ++= 42
		arr += [10, 20, 30]
		XCTAssertEqual(arr, [42, 10, 20, 30])
		arr --= 20
		XCTAssertEqual(arr, [42, 10, 30])
	}


	func testMath() {
		XCTAssertEqual([1,2,3,4,5].sum()!, 15)
		XCTAssertEqual([0.5, 1, 1.5, 0.25].sum(), 3.25)

		print(Float.nan == Float.nan)

		XCTAssertNil([Int]().sum())
		XCTAssertTrue([Float]().sum().isNaN)
	}


	func testMergeDictionaries() {
		XCTAssertEqual([["a":1], ["b":2]].merged(), ["a":1, "b":2])
		XCTAssertEqual([["a":1], ["a":2]].merged(), ["a":2])
	}

}


func XCTAssertEqual <T> (_ lhs: [T], _ rhs: [T]) where T: Collection, T.Iterator.Element: Equatable {
	for i in 0..<lhs.count {
		XCTAssertEqual(Array(lhs[i]), Array(rhs[i]))
	}
}





class DictionaryTest: XCTestCase {

	func testMerge() {
		var d1 = Dict()
		(0..<1000).forEach { i in
			d1["key\(i)"] = i
		}
		var d2 = Dict()
		((d1.count/2)..<(d1.count/2 + d1.count)).forEach { i in
			d2["key\(i)"] = i*2
		}

		self.measure {
			let d3 = d1.merged(with: d2)
			d1.merge(with: d2)
			XCTAssertEqual(d1, d3)
		}
	}

}





class CGPointTests: XCTestCase {

	func test() {
		XCTAssertEqual(CGPoint.init(10, 10), CGPoint(x: 10.0, y: 10.0))

		let p = CGPoint.init(angle: .pi, magnitude: 10)
		XCTAssertTrue(p.x.shorten(decimals: 10) == -10)
		XCTAssertTrue(p.y.shorten(decimals: 10) == 0)

		XCTAssertEqual(CGPoint.init(angle: CGFloat(90).rad, magnitude: 100).angle, CGFloat(90).rad)
		XCTAssertEqual(CGPoint.init(angle: CGFloat(-90).rad, magnitude: 100).angle, CGFloat(-90).rad)
		XCTAssertEqual(CGPoint.init(angle: CGFloat(50).rad, magnitude: 100).angle, CGFloat(50).rad)
		XCTAssertEqual(CGPoint.init(angle: CGFloat(-50).rad, magnitude: 100).angle, CGFloat(-50).rad)
		XCTAssertEqual(CGPoint.init(angle: CGFloat(22.5).rad, magnitude: 100).angle, CGFloat(22.5).rad)
		XCTAssertEqual(CGPoint.init(angle: 10, magnitude: 100).magnitude, 100)

		let p1 = CGPoint(10, 10)
		let p2 = CGPoint(15, 15)
		XCTAssertEqual(p1.angle(to: p2), .pi/4)
		XCTAssertEqual(Int(p1.distance(to: p2)), 7)
	}


	func testOperators() {
		var point = CGPoint()
		point += 10
		XCTAssertEqual(point, CGPoint(10, 10))
		point -= 5
		XCTAssertEqual(point, CGPoint(5, 5))
		point *= 10
		XCTAssertEqual(point, CGPoint(50, 50))
		point /= 2
		XCTAssertEqual(point, CGPoint(25, 25))

		point += CGPoint(10, 15)
		XCTAssertEqual(point, CGPoint(35, 40))
		point -= CGPoint(5, 10)
		XCTAssertEqual(point, CGPoint(30, 30))
		point *= CGPoint(2, 3.5)
		XCTAssertEqual(point, CGPoint(60, 105))
		point /= CGPoint(6, 7)
		XCTAssertEqual(point, CGPoint(10, 15))

		let p = CGPoint(10, 10)
		XCTAssertEqual(p + 10, CGPoint(20, 20))
		XCTAssertEqual(p - 5, CGPoint(5, 5))
		XCTAssertEqual(p * 5, CGPoint(50, 50))
		XCTAssertEqual(p / 5, CGPoint(2, 2))
		XCTAssertEqual(p + CGPoint(10, 15), CGPoint(20, 25))
		XCTAssertEqual(p - CGPoint(100, 50), CGPoint(-90, -40))
		XCTAssertEqual(p * CGPoint(10, 15), CGPoint(100, 150))
		XCTAssertEqual(p / CGPoint(4, 2), CGPoint(2.5, 5))
	}

}





class CGRectTests: XCTestCase {

	func test() {
		var r = CGRect(size: CGSize(width: 100, height: 100))
		XCTAssertEqual(r, CGRect(x: 0, y: 0, width: 100, height: 100))

		r.top = 10
		XCTAssertEqual(r, CGRect(x: 0, y: 10, width: 100, height: 100))
		XCTAssertEqual(r.bottom, 110)
		r.bottom = 105
		XCTAssertEqual(r, CGRect(x: 0, y: 5, width: 100, height: 100))
		XCTAssertEqual(r.top, 5)
		r.left = 10
		XCTAssertEqual(r, CGRect(x: 10, y: 5, width: 100, height: 100))
		XCTAssertEqual(r.right, 110)
		r.right = 105
		XCTAssertEqual(r, CGRect(x: 5, y: 5, width: 100, height: 100))
		XCTAssertEqual(r.left, 5)

		r.topLeft = CGPoint(-5, -5)
		XCTAssertEqual(r, CGRect(x: -5, y: -5, width: 100, height: 100))
		XCTAssertEqual(r.bottomRight, CGPoint(95, 95))
		r.topRight = CGPoint(10, 80)
		XCTAssertEqual(r, CGRect(x: -90, y: 80, width: 100, height: 100))
		XCTAssertEqual(r.bottomLeft, CGPoint(-90, 180))
		r.bottomLeft = CGPoint(80, -20)
		XCTAssertEqual(r, CGRect(x: 80, y: -120, width: 100, height: 100))
		XCTAssertEqual(r.topRight, CGPoint(180, -120))
		r.bottomRight = CGPoint(120, 150)
		XCTAssertEqual(r, CGRect(x: 20, y: 50, width: 100, height: 100))
		XCTAssertEqual(r.topLeft, CGPoint(20, 50))

		XCTAssertEqual(r.center, CGPoint(70, 100))

		r.widt = 50
		XCTAssertEqual(r, CGRect(x: 20, y: 50, width: 50, height: 100))
		XCTAssertEqual(r.width, 50)
		r.heigt = 50
		XCTAssertEqual(r, CGRect(x: 20, y: 50, width: 50, height: 50))
		XCTAssertEqual(r.height, 50)
	}

}





class CGSizeTests: XCTestCase {

	func test() {
		let size = CGSize(10, 50)
		XCTAssertEqual(size, CGSize(width: 10.0, height: 50.0))
		XCTAssertEqual(size.aspectRatio, 0.2)
	}


	func testOperators() {
		var s = CGSize()
		s += 10
		XCTAssertEqual(s, CGSize(10, 10))
		s -= 5
		XCTAssertEqual(s, CGSize(5, 5))
		s *= 10
		XCTAssertEqual(s, CGSize(50, 50))
		s /= 2
		XCTAssertEqual(s, CGSize(25, 25))

		s += CGSize(10, 15)
		XCTAssertEqual(s, CGSize(35, 40))
		s -= CGSize(5, 10)
		XCTAssertEqual(s, CGSize(30, 30))
		s *= CGSize(2, 3.5)
		XCTAssertEqual(s, CGSize(60, 105))
		s /= CGSize(6, 7)
		XCTAssertEqual(s, CGSize(10, 15))

		let s2 = CGSize(10, 10)
		XCTAssertEqual(s2 + 10, CGSize(20, 20))
		XCTAssertEqual(s2 - 5, CGSize(5, 5))
		XCTAssertEqual(s2 * 5, CGSize(50, 50))
		XCTAssertEqual(s2 / 5, CGSize(2, 2))
		XCTAssertEqual(s2 + CGSize(10, 15), CGSize(20, 25))
		XCTAssertEqual(s2 - CGSize(100, 50), CGSize(-90, -40))
		XCTAssertEqual(s2 * CGSize(10, 15), CGSize(100, 150))
		XCTAssertEqual(s2 / CGSize(4, 2), CGSize(2.5, 5))
	}

}





class MathTests: XCTestCase {

	func test() {
		let a: Double = Math.ceil(10.5, base: 0.2)
		let b: Double = 10.6
		print(a, "==", b, a == b)
		print(a.sign, b.sign)
		print(a.significand, b.significand)
		print(a.exponent, b.exponent)

		XCTAssertEqual(Math.ceil(0.0, base: 10), 0.0)
		XCTAssertEqual(Math.ceil(1.0, base: 10), 10.0)
		XCTAssertEqual(Math.ceil(4.0, base: 5), 5.0)
		XCTAssertEqual(Math.ceil(6.0, base: 5), 10.0)
		XCTAssertNotEqual(Math.ceil(62, base: 30), 60)

		XCTAssertEqual(Math.round(0.0, base: 10), 0.0)
		XCTAssertEqual(Math.round(1.0, base: 10), 0.0)
		XCTAssertEqual(Math.round(6.0, base: 10), 10.0)
		XCTAssertEqual(Math.round(43, base: 5), 45)
	}
}









class StringTests: XCTestCase {
	
	func test() {
		let string = "Hello World!"
		
		XCTAssertEqual(string.reversed, "!dlroW olleH")
		XCTAssertEqual("".ifEmpty(string), string)
		XCTAssertEqual(string.extracted(to: 5), "Hello")
		XCTAssertEqual(string.extracted(from: 6), "World!")
		XCTAssertEqual(string.extracted(characters: .letters), "HelloWorld")
		XCTAssertEqual(string.removed(characters: .letters), " !")
		XCTAssertEqual(string[2...5], "llo")
		XCTAssertEqual(string[...5], "Hello")
		XCTAssertEqual(string[2...], "llo World!")
		XCTAssertEqual(string.split(" "), ["Hello", "World!"])
		XCTAssertEqual("12345678".grouped(separator: " ", size: 4), "1234 5678")
		XCTAssertEqual("123456".grouped(separator: " ", size: 4), "1234 56")
		XCTAssertEqual("123456789".grouped(separator: " ", size: 4), "1234 5678 9")
		
		let base64 = string.base64Encoded()!
		XCTAssertEqual(string, base64.base64Decoded()!)
		
		XCTAssertTrue("ello" ?== string)
	}
	
	
	func testTextAttributes() {
		let p: [TextAttributes] = [
			.font(UIFont.systemFont(ofSize: 17)),
			.paragraphStyle(NSParagraphStyle.default),
			.foreground(UIColor.red),
			.background(UIColor.blue),
			.ligature(1),
			.kern(1.0),
			.strikethroughStyle(NSUnderlineStyle.byWord),
			.strikethrough(UIColor.green),
			.underlineStyle(NSUnderlineStyle.patternDash),
			.underlineColor(UIColor.yellow),
			.strokeColor(UIColor.orange),
			.strokeWidth(2.0),
//			.shadow(NSShadow),
//			.textEffect(String),
//			.attachment(NSTextAttachment),
			.link("https://google.se"),
			.baselineOffset(1.0),
			.obliqueness(1.0),
			.expansion(1.0),
//			.writingDirection([NSNumber]),
			.verticalGlyphForm(1)
		]
		let pd = p.attributedDictionary
		
		let d: [NSAttributedStringKey: Any] = [
			.font: UIFont.systemFont(ofSize: 17),
			.paragraphStyle: NSParagraphStyle.default,
			.foregroundColor: UIColor.red,
			.backgroundColor: UIColor.blue,
			.ligature: 1,
			.kern: Float(1.0),
			.strikethroughStyle: NSUnderlineStyle.byWord.rawValue,
			.strikethroughColor: UIColor.green,
			.underlineStyle: NSUnderlineStyle.patternDash.rawValue,
			.underlineColor: UIColor.yellow,
			.strokeColor: UIColor.orange,
			.strokeWidth: Float(2.0),
//			.shadow(NSShadow),
//			.textEffect(String),
//			.attachment(NSTextAttachment),
			.link: "https://google.se",
			.baselineOffset: Float(1.0),
			.obliqueness: Float(1.0),
			.expansion: Float(1.0),
//			.writingDirection([NSNumber]),
			.verticalGlyphForm: 1
		]
		
		for key in pd.keys {
			let a = "\(pd[key]!)"
			let b = "\(d[key]!)"
			XCTAssertEqual(a, b)
		}
	}
}








class DateTests: XCTestCase {
	
	func testFormat() {
		let dateText = "2017-05-19 05:30:20"
		let date = Date(dateText, format: .dateTimeSec)!
		var dc = DateComponents()
		dc.year = 2017
		dc.month = 5
		dc.day = 19
		dc.hour = 5
		dc.minute = 30
		dc.second = 20
		let date2 = Calendar.current.date(from: dc)!
		
		XCTAssertEqual(date, date2)
		XCTAssertEqual(dateText, date2.format(.dateTimeSec))
	}
	
	func testMutations() {
		var date = Date("2017-05-19 05:30:20", format: .dateTimeSec)!
		date.year += 3
		XCTAssertEqual(date, Date("2020-05-19 05:30:20", format: .dateTimeSec))
		date.month -= 10
		XCTAssertEqual(date, Date("2019-07-19 05:30:20", format: .dateTimeSec))
		date.day += 13
		XCTAssertEqual(date, Date("2019-08-01 05:30:20", format: .dateTimeSec))
		date.hour += 10
		XCTAssertEqual(date, Date("2019-08-01 15:30:20", format: .dateTimeSec))
		date.minute += 15
		XCTAssertEqual(date, Date("2019-08-01 15:45:20", format: .dateTimeSec))
		date.second += 90
		XCTAssertEqual(date, Date("2019-08-01 15:46:50", format: .dateTimeSec))
	}
	
	func testOperators() {
		var date = Date("2017-05-19 05:30:20", format: .dateTimeSec)!
		date += .years(3)
		XCTAssertEqual(date, Date("2020-05-19 05:30:20", format: .dateTimeSec))
		date -= .months(10)
		XCTAssertEqual(date, Date("2019-07-19 05:30:20", format: .dateTimeSec))
		date += .days(13)
		XCTAssertEqual(date, Date("2019-08-01 05:30:20", format: .dateTimeSec))
		date += .hours(10)
		XCTAssertEqual(date, Date("2019-08-01 15:30:20", format: .dateTimeSec))
		date += .minutes(15)
		XCTAssertEqual(date, Date("2019-08-01 15:45:20", format: .dateTimeSec))
		date += .seconds(90)
		XCTAssertEqual(date, Date("2019-08-01 15:46:50", format: .dateTimeSec))
		
		let date2 = Date("2017-05-19 05:30:20", format: .dateTimeSec)!
		XCTAssertEqual(date2 + .years(3), Date("2020-05-19 05:30:20", format: .dateTimeSec))
		XCTAssertEqual(date2 + [.years(3), .months(-10)], Date("2019-07-19 05:30:20", format: .dateTimeSec))
		XCTAssertEqual(date2 + [.years(3), .months(-10), .days(13)], Date("2019-08-01 05:30:20", format: .dateTimeSec))
		XCTAssertEqual(date2 + [.years(3), .months(-10), .days(13), .hours(10)], Date("2019-08-01 15:30:20", format: .dateTimeSec))
		XCTAssertEqual(date2 + [.years(3), .months(-10), .days(13), .hours(10), .minutes(15)], Date("2019-08-01 15:45:20", format: .dateTimeSec))
		XCTAssertEqual(date2 + [.years(3), .months(-10), .days(13), .hours(10), .minutes(15), .seconds(90)], Date("2019-08-01 15:46:50", format: .dateTimeSec))
	}
}













class NumberTests: XCTestCase {
	
	func testInits() {
		XCTAssertEqual(Int("100"), 100)
		XCTAssertEqual(Int("-100"), -100)
		XCTAssertNil(Int("100.00"))
		XCTAssertNil(Int("--100"))
		XCTAssertNil(Int("aaa100"))
		
		XCTAssertEqual(CGFloat("100"), 100)
		XCTAssertEqual(CGFloat("-100"), -100)
		XCTAssertEqual(CGFloat("100.5005"), 100.5005)
		XCTAssertNil(CGFloat("--100"))
		XCTAssertNil(CGFloat("aaa100"))
	}
	
	func testArithmetics() {
		XCTAssertEqual(f(Int(10), +, Int(20)), 30)
		XCTAssertEqual(f(Int(10), -, Int(20)), -10)
		XCTAssertEqual(f(Int(10), *, Int(20)), 200)
		XCTAssertEqual(f(Int(10), /, Int(20)), 0)
		XCTAssertEqual(f(Int(10), %, Int(20)), 10)
		
		XCTAssertEqual(f(UInt(10), +, UInt(20)), 30)
		XCTAssertEqual(f(UInt(10), -, UInt(10)), 0)
		XCTAssertEqual(f(UInt(10), *, UInt(20)), 200)
		XCTAssertEqual(f(UInt(10), /, UInt(20)), 0)
		XCTAssertEqual(f(UInt(10), %, UInt(20)), 10)
		
		XCTAssertEqual(f(Float(10.5), +, Float(20.1)), 30.6)
		XCTAssertEqual(f(Float(10.5), -, Float(20.1)), -9.6)
		XCTAssertEqual(f(Float(10.5), *, Float(20.1)), 211.05)
		XCTAssertEqual(f(Float(10.5), /, Float(2.5)), 4.2)
		XCTAssertEqual(f(Float(10.5), %, Float(20.1)), -9.6)
		
		XCTAssertEqual(f(CGFloat(10.5), +, CGFloat(20.1)), 30.6)
		XCTAssertEqual(f(CGFloat(10.5), -, CGFloat(20.5)), -10)
		XCTAssertEqual(f(CGFloat(10.5), *, CGFloat(20.1)), 211.05)
		XCTAssertEqual(f(CGFloat(10.5), /, CGFloat(2.5)), 4.2)
		XCTAssertEqual(f(CGFloat(10.5), %, CGFloat(20)), -9.5)
	}
	
	func f <T: Arithmetics> (_ lhs: T, _ function: (T, T) -> T, _ rhs: T) -> T {
		return function(lhs, rhs)
	}
	
	
	func testConversions() {
		func i <T: Number> (_ lhs: T) -> Int {
			return Int(number: lhs) + 100
		}
		func ui <T: Number> (_ lhs: T) -> UInt {
			return UInt(number: lhs) + 100
		}
		func d <T: Number> (_ lhs: T) -> Double {
			return Double(number: lhs) + 100.5
		}
		
		XCTAssertEqual(i(Int(100)), 200)
		XCTAssertEqual(i(UInt(100.5)), 200)
		XCTAssertEqual(i(Float(100)), 200)
		XCTAssertEqual(i(Double(100)), 200)
		
		XCTAssertEqual(ui(Int(100)), 200)
		XCTAssertEqual(ui(UInt(100.5)), 200)
		XCTAssertEqual(ui(Float(100)), 200)
		XCTAssertEqual(ui(Double(100)), 200)
		
		XCTAssertEqual(d(Int(100)), 200.5)
		XCTAssertEqual(d(UInt(100.5)), 200.5)
		XCTAssertEqual(d(Float(100)), 200.5)
		XCTAssertEqual(d(Double(100)), 200.5)
	}
}











class ColorTests: XCTestCase {
	
	func testRepresentations() {
		let c = UIColor.red
		let rgb = c.rgba
		let hsb = c.hsba
		let hsl = c.hsla
		XCTAssertEqual(c, UIColor(red: rgb.r, green: rgb.g, blue: rgb.b, alpha: rgb.a))
		XCTAssertEqual(c, UIColor(hue: hsb.h, saturation: hsb.s, brightness: hsb.b, alpha: hsb.a))
		XCTAssertEqual(c, UIColor(hue: hsl.h, saturation: hsl.s, lightness: hsl.l, alpha: hsl.a))
		
		XCTAssertEqual(hex(UIColor(hex: 0xcccccc)), 0xcccccc)
	}
	
	func testRGBA() {
		XCTAssertTrue(UIColor.red.rgba == (CGFloat(1),CGFloat(0),CGFloat(0),CGFloat(1)))
		XCTAssertTrue(UIColor.green.rgba == (CGFloat(0),CGFloat(1),CGFloat(0),CGFloat(1)))
		XCTAssertTrue(UIColor.blue.rgba == (CGFloat(0),CGFloat(0),CGFloat(1),CGFloat(1)))
		
		self.measure {
			let random = UIColor.random
			XCTAssertEqual(hex(random), hex(UIColor(hex: hex(random))))
		}
	}
	
	func testHSBA() {
		XCTAssertTrue(UIColor.red.hsba == (CGFloat(0),CGFloat(1),CGFloat(1),CGFloat(1)))
		XCTAssertTrue(UIColor.green.hsba == (CGFloat(120.0/360.0),CGFloat(1),CGFloat(1),CGFloat(1)))
		XCTAssertTrue(UIColor.blue.hsba == (CGFloat(240/360.0),CGFloat(1),CGFloat(1),CGFloat(1)))
		
		self.measure {
			let random = UIColor.random
			let (h, s, b, a) = random.hsba
			XCTAssertEqual(hex(random), hex(UIColor(hue: h, saturation: s, brightness: b, alpha: a)))
		}
	}
	
	func testHSLA() {
		XCTAssertTrue(UIColor.red.hsla == (CGFloat(0),CGFloat(1),CGFloat(0.5),CGFloat(1)))
		XCTAssertTrue(UIColor.green.hsla == (CGFloat(120.0/360.0),CGFloat(1),CGFloat(0.5),CGFloat(1)))
		XCTAssertTrue(UIColor.blue.hsla == (CGFloat(240/360.0),CGFloat(1),CGFloat(0.5),CGFloat(1)))
		
		self.measure {
			let random = UIColor.random
			let (h, s, l, a) = random.hsla
			XCTAssertEqual(hex(random), hex(UIColor(hue: h, saturation: s, lightness: l, alpha: a)))
		}
	}
	
	private func hex(_ color: UIColor) -> UInt {
		let (r, g, b, _) = color.rgba
		var hex: UInt = 0
		hex |= UInt((b * 255.0))
		hex |= UInt((g * 255.0)) << 8
		hex |= UInt((r * 255.0)) << 16
		return hex
	}
}
















