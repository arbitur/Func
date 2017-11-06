//
//  UIBezierPath+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UIBezierPath {
	
	func addRect(_ p1: CGPoint, p2: CGPoint) {
		self.move(to: p1)
		self.addLine(to: CGPoint(p2.x, p1.y))
		self.addLine(to: p2)
		self.addLine(to: CGPoint(p1.x, p2.y))
		self.close()
	}
	
	
	func addRect(_ rect: CGRect) {
		let topLeft = rect.origin
		let bottomRight = CGPoint(x: topLeft.x + rect.size.width, y: topLeft.y + rect.size.height)
		self.addRect(topLeft, p2: bottomRight)
	}
	
	
	
	func stroke(_ color: UIColor) {
		color.setStroke()
		self.stroke()
	}
	
	func fill(_ color: UIColor) {
		color.setFill()
		self.fill()
	}
}
