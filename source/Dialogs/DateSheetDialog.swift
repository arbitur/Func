//
//  DateSheetDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 28/Apr/17.
//
//

import UIKit





open class DateSheetDialog: SheetDialog {
	public let datePicker = UIDatePicker()
	
	
	open override func viewDidLoad() {
		self.customViews.append(datePicker)
		super.viewDidLoad()
	}
	
//	public required init(title: String?, subtitle: String?) {
//		super.init(title: title, subtitle: subtitle)
//	}
//	public override init(nibName: String?, bundle: Bundle?) { fatalError() }
//	public required init?(coder aDecoder: NSCoder) { fatalError() }
}
