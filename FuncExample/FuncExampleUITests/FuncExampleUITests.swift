//
//  FuncExampleUITests.swift
//  FuncExampleUITests
//
//  Created by Philip Fryklund on 22/Nov/17.
//  Copyright © 2017 Arbitur. All rights reserved.
//

import XCTest

class FuncExampleUITests: XCTestCase {
        
    let app = XCUIApplication()
	
	override func setUp() {
		self.continueAfterFailure = false
		app.launch()
	}
	
	
	func testSlideMenu() {
		
		let openSwipe = app.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.5))
		openSwipe.press(forDuration: 0.2, thenDragTo: openSwipe.withOffset(CGVector(dx: 200, dy: 0)))
		
		let closeSwipe = app.coordinate(withNormalizedOffset: CGVector(dx: 1.0, dy: 0.5))
		closeSwipe.press(forDuration: 0.2, thenDragTo: closeSwipe.withOffset(CGVector(dx: -200, dy: 0)))
		
	}
    
}
