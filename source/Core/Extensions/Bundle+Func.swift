//
//  Bundle+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 22/Feb/17.
//
//

import UIKit





public extension Bundle {
	func image(name: String, type: String) -> UIImage? {
		if let path = self.path(forResource: name, ofType: type) {
			return UIImage(contentsOfFile: path)
		}
		return nil
	}
}
