//
//  DateSheetDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 28/Apr/17.
//
//

import UIKit

public typealias DateSheetDialog = DateSheetDialogController // For backwards compatibility

open class DateSheetDialogController: SheetDialogController {
	
	public let datePicker = UIDatePicker()
	
	
	public required init(title: String?, subtitle: String?) {
		super.init(title: title, subtitle: subtitle)
		addCustomView(datePicker)
	}
	public override init(nibName: String?, bundle: Bundle?) { fatalError() }
	public required init?(coder aDecoder: NSCoder) { fatalError() }
}
