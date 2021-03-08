//
//  UIDevice+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Feb/17.
//
//

import Foundation





public extension UIDevice {
	
	static var isSimulator: Bool {
		return TARGET_OS_SIMULATOR != 0
	}
}
