//
//  NSAttributedString+Func.swift
//  Func
//
//  Created by Philip Fryklund on 8/Dec/17.
//

import Foundation





public extension NSAttributedString {
	
	convenience init?(html: String) {
		guard
			let data = html.data(using: .utf16, allowLossyConversion: false),
			let string = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
		else {
			return nil
		}
		
		self.init(attributedString: string)
	}
}
