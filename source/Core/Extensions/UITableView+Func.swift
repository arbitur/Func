//
//  UITableView+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public protocol TableViewCellLoadable: class {
	
	static var reuseIdentifier: String { get }
}





public extension UITableView {
	
	func cell <T: UITableViewCell> (for id: String) -> T? {
		return self.dequeueReusableCell(withIdentifier: id) as? T
	}
	
	
	func cell <T: UITableViewCell & TableViewCellLoadable> (ofType type: T.Type) -> T {
		return self.dequeueReusableCell(withIdentifier: type.reuseIdentifier) as! T
	}
	
	
	func setTableHeaderViewWithAutoLayout(_ view: UIView) {
		self.tableHeaderView = view
		view.setNeedsLayout()
		view.layoutIfNeeded()
		view.frame.size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		self.tableHeaderView = view
	}
	
	
	func setTableFooterViewWithAutoLayout(_ view: UIView) {
		self.tableFooterView = view
		view.setNeedsLayout()
		view.layoutIfNeeded()
		view.frame.size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
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
