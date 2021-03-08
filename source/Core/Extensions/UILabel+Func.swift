//
//  UILabel+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UILabel {
	
	convenience init(font: UIFont!, color: UIColor = .black, alignment: NSTextAlignment = .left, lines: Int = 1) {
		self.init()
		self.font = font
		self.textColor = color
		self.textAlignment = alignment
		self.numberOfLines = lines
	}
}
