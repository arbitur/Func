//
//  UITableView+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public extension UITableView {
	
	func cell <T: UITableViewCell> (for id: String) -> T? {
		return self.dequeueReusableCell(withIdentifier: id) as? T
	}
	
	
	func setTableHeaderViewWithAutoLayout(_ view: UIView) {
		self.tableHeaderView = view
		view.setNeedsLayout()
		view.layoutIfNeeded()
		view.frame.size = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
		self.tableHeaderView = view
	}
	
	
	func setTableFooterViewWithAutoLayout(_ view: UIView) {
		self.tableFooterView = view
		view.setNeedsLayout()
		view.layoutIfNeeded()
		view.frame.size = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
		self.tableFooterView = view
	}
	
	
	
	func deselectSelectedRow(animated: Bool) {
		guard let indexPath = self.indexPathForSelectedRow else {
			return
		}
		
		self.deselectRow(at: indexPath, animated: animated)
	}
	
	
	func deselectSelectedRows(animated: Bool) {
		self.indexPathsForSelectedRows?.forEach {
			self.deselectRow(at: $0, animated: animated)
		}
	}
}
