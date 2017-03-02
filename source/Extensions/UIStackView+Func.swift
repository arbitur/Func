//
//  UIStackView+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





@available(iOS 9.0, *)
public extension UIStackView {
	convenience init(axis: UILayoutConstraintAxis) {
		self.init(frame: CGRect.zero)
		self.axis = axis
	}
}
