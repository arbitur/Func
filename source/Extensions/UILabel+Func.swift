//
//  UILabel+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UILabel {

	func add(attributes: [String: Any], to part: String) {
		if let attr = self.attributedText, let text = self.text, let range = text.range(of: part) {
			let mattr = NSMutableAttributedString(attributedString: attr)
			
			let start = text.distance(from: text.startIndex, to: range.lowerBound)
			let length = text.distance(from: text.startIndex, to: range.upperBound) - start
			let range = NSMakeRange(start, length)
			
			mattr.addAttributes(attributes, range: range)
			
			self.attributedText = mattr
		}
	}
	
	convenience init(font: UIFont!, color: UIColor = .black, alignment: NSTextAlignment = .left) {
		self.init()
		self.font = font
		self.textColor = color
		self.textAlignment = alignment
//		self.numberOfLines = 0
	}
}
