//
//  UITableView+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UITableView {
	
	func cell <T> (for id: String) -> T where T: UITableViewCell {
		return self.dequeueReusableCell(withIdentifier: id) as! T
	}
	
	func deselectRow(animated: Bool) {
		guard let indexPath = self.indexPathForSelectedRow else {
			return
		}
		
		self.deselectRow(at: indexPath, animated: animated)
	}
	
	func deselectRows(animated: Bool) {
		self.indexPathsForSelectedRows?.forEach {
			self.deselectRow(at: $0, animated: animated)
		}
	}
}
