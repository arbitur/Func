//
//  UISegmentedControl+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UISegmentedControl {
	
	var items: [String] {
		get {
			return (0..<self.numberOfSegments).map { self.titleForSegment(at: $0) ?? "" }
		}
		set {
			self.setItems(newValue, animated: false)
		}
	}
	
	
	
	func setItems(_ items: [String], animated: Bool) {
		self.removeAllSegments()
		
		for (i, item) in items.enumerated() {
			self.insertSegment(withTitle: item, at: i, animated: animated)
		}
	}
}
