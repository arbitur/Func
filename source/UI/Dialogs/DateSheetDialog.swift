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
}
