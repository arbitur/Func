//
//  UITableViewCell+Func.swift
//  Func
//
//  Created by Philip Fryklund on 6/Dec/18.
//

import UIKit





public extension UITableViewCell {
	
	var parentTableView: UITableView? {
		return self.precendents.first(where: { $0 is UITableView }) as? UITableView
	}
}
