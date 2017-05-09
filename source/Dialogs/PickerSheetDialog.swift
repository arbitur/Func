//
//  PickerSheetDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 28/Apr/17.
//
//

import UIKit





open class PickerSheetDialog: SheetDialog, UIPickerViewDelegate, UIPickerViewDataSource {
	public let pickerView = UIPickerView()
	
	public var data = [[String]]()
	
	public func addColumn(rows: [String]) {
		data.append(rows)
	}
	
	private var _didSelectRow: ((_ column: Int, _ row: Int)->())?
	public func setDidSelectRow(_ action: @escaping (_ column: Int, _ row: Int)->()) {
		_didSelectRow = action
	}
	
	
	
	open override func viewDidLoad() {
		self.customViews.append(pickerView)
		
		super.viewDidLoad()
		
		for c in 0..<pickerView.numberOfComponents {
			_didSelectRow?(c, pickerView.selectedRow(inComponent: c))
		}
	}
	
	public required init(title: String?, subtitle: String?) {
		super.init(title: title, subtitle: subtitle)
		pickerView.delegate = self
		pickerView.dataSource = self
	}
	public override init(nibName: String?, bundle: Bundle?) { fatalError() }
	public required init?(coder aDecoder: NSCoder) { fatalError() }
	
	
	
	
	
	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return data.count
	}
	
	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return data[component].count
	}
	
	open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return data[component][row]
	}
	
	open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		_didSelectRow?(component, row)
	}
}













