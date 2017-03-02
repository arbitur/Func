//
//  UITableView+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UITableView {
	func cell<T: UITableViewCell>(for id: String) -> T? {
		return self.dequeueReusableCell(withIdentifier: id) as? T
	}
}
