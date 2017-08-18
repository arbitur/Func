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
		
		let p = CGPoint.init(angle: .pi/2, magnitude: 10)
		XCTAssertTrue(p.x < 0.00000000001 && p.x > 0)
		XCTAssertEqual(p.y, 10)
		
		XCTAssertEqual(CGPoint.init(angle: CGFloat(90).rad, magnitude: 100).angle, CGFloat(90).rad)
		XCTAssertEqual(CGPoint.init(angle: CGFloat(-90).rad, magnitude: 100).angle, CGFloat(-90).rad)
		XCTAssertEqual(CGPoint.init(angle: CGFloat(45).rad, magnitude: 100).angle, CGFloat(45).rad)
		XCTAssertEqual(CGPoint.init(angle: CGFloat(-45).rad, magnitude: 100).angle, CGFloat(-45).rad)
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
		
		r.w = 50
		XCTAssertEqual(r, CGRect(x: 20, y: 50, width: 50, height: 100))
		XCTAssertEqual(r.width, 50)
		r.h = 50
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



















