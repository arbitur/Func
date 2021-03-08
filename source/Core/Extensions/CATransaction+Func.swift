//
//  CATransaction+Func.swift
//  Func
//
//  Created by Philip Fryklund on 15/Dec/17.
//

import Foundation





public extension CATransaction {
	
	static func performWithoutAnimation(_ animation: Closure) {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		animation()
		CATransaction.commit()
	}
}
