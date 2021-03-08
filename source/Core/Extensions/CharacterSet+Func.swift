//
//  CharacterSet+Func.swift
//  Func
//
//  Created by Philip Fryklund on 6/Dec/17.
//

import Foundation





public extension CharacterSet {
	
	init(_ string: String) {
		self.init(charactersIn: string)
	}
}


extension CharacterSet: ExpressibleByStringLiteral {
	
	public init(stringLiteral value: StringLiteralType) {
		self.init(value)
	}
}
