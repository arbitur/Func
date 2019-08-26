//
//  UITextField+Func.swift
//  Func
//
//  Created by Philip Fryklund on 13/Aug/19.
//

import Foundation





public extension UITextField {
	
	var cursorPosition: Int? {
		get {
			guard let selectedTextRange = self.selectedTextRange else {
				return nil
			}
			return self.offset(from: self.beginningOfDocument, to: selectedTextRange.start)
		}
		set {
			guard let cursorPosition = newValue, let position = self.position(from: self.beginningOfDocument, offset: cursorPosition) else {
				self.cursorPosition = nil
				return
			}
			self.selectedTextRange = self.textRange(from: position, to: position)
		}
	}
}
