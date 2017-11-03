//
//  DebugViewController.swift
//  Func
//
//  Created by Philip Fryklund on 20/Oct/17.
//

import UIKit





open class DebugViewController: UIViewController {
	private lazy var className: String = {
		return String(describing: type(of: self))
	}()
	
	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("\(className).viewWillAppear(\(animated))")
	}
	
	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		print("\(className).viewDidAppear(\(animated))")
	}
	
	override open func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		print("\(className).viewWillDisappear(\(animated))")
	}
	
	override open func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		print("\(className).viewDidDisappear(\(animated))")
	}
	
	deinit {
		print("~\(className)")
	}
}
