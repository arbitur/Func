//
//  UITableView+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public protocol TableViewCellLoadable: AnyObject {
	static var reuseIdentifier: String { get }
}

public protocol TableViewCellLoadableFromNib: TableViewCellLoadable {
	static var nib: UINib { get }
}
extension TableViewCellLoadableFromNib {
	
	static var nib: UINib {
		UINib(nibName: "\(Self.self)", bundle: Bundle(for: Self.self))
	}
}





public extension UITableView {
	
	func dequeueCell <T: UITableViewCell> (withIdentifier id: String) -> T? {
		return self.dequeueReusableCell(withIdentifier: id) as? T
	}
	func dequeueCell <T: UITableViewCell> (withIdentifier id: String, for indexPath: IndexPath) -> T {
		return self.dequeueReusableCell(withIdentifier: id, for: indexPath) as! T
	}
	
	
	func dequeueCell <T: UITableViewCell & TableViewCellLoadable> (ofType type: T.Type = T.self) -> T? {
		return self.dequeueReusableCell(withIdentifier: type.reuseIdentifier) as? T
	}
	func dequeueCell <T: UITableViewCell & TableViewCellLoadable> (ofType type: T.Type = T.self, for indexPath: IndexPath) -> T {
		return self.dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! T
	}
	
	
	func dequeueHeaderFooter <T: UITableViewHeaderFooterView & TableViewCellLoadable> (ofType type: T.Type = T.self) -> T {
		return self.dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as! T
	}
	
	
	func registerCell <T: UITableViewCell & TableViewCellLoadableFromNib> (ofType type: T.Type) {
		self.register(type.nib, forCellReuseIdentifier: type.reuseIdentifier)
	}
	func registerCell <T: UITableViewCell & TableViewCellLoadable> (ofType type: T.Type) {
		self.register(type, forCellReuseIdentifier: type.reuseIdentifier)
	}
	
	func registerHeaderFooter <T: UITableViewHeaderFooterView & TableViewCellLoadableFromNib> (ofType type: T.Type) {
		self.register(type.nib, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
	}
	func registerHeaderFooter <T: UITableViewCell & TableViewCellLoadable> (ofType type: T.Type) {
		self.register(type, forCellReuseIdentifier: type.reuseIdentifier)
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
