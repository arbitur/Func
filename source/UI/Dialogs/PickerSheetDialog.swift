//
//  PickerSheetDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 28/Apr/17.
//
//

import UIKit

public typealias PickerSheetDialog = PickerSheetDialogController // For backwards compatibility

open class PickerSheetDialogController <T: Equatable> : SheetDialogController {
	
	public let pickerView = UIPickerView()
	internal var data = [[T]]()
	
	private var delegate: PickerViewDelegate!
	
	
	public var selectedValues: [(rowIndex: Int, value: T)] {
		return data.indices.map { column in
			let row = pickerView.selectedRow(inComponent: column)
			return (row, data[column][row])
		}
	}
	
	public func addValues(_ values: [T]) {
		data.append(values)
	}
	
	public func setValues(_ values: [T], inColumn column: Int) {
		data[column] = values
		pickerView.reloadComponent(column)
	}
	
	
	public typealias DidSelectClosure = (UIPickerView, IndexPath, T) -> ()
	private var _didSelectValue: DidSelectClosure?
	public func didSelectValue(_ closure: @escaping DidSelectClosure) {
		_didSelectValue = closure
	}
	
	public typealias TitleForRowClosure = (IndexPath, T) -> String?
	private var _titleForValue: TitleForRowClosure?
	public func titleForValue(_ closure: @escaping TitleForRowClosure) {
		_titleForValue = closure
	}
	
	public func selectRow(_ row: Int, inColumn column: Int, animated: Bool) {
		pickerView.selectRow(row, inComponent: column, animated: animated)
		pickerView.delegate?.pickerView?(pickerView, didSelectRow: row, inComponent: column)
	}
	
	@discardableResult
	public func selectValue(_ value: T, inColumn column: Int, animated: Bool) -> Bool {
		guard let row = data[column].firstIndex(of: value) else {
			return false
		}
		selectRow(row, inColumn: column, animated: animated)
		return true
	}
	
	
	public required init(title: String?, subtitle: String?) {
		super.init(title: title, subtitle: subtitle)
		
		addCustomView(pickerView)
		
		delegate = PickerViewDelegate.init(
			numberOfComponents: { [unowned self] in self.data.count },
			numberOfRowsInComponent: { [unowned self] in self.data[$0].count },
			titleForRow: { [unowned self] in
				let value = self.data[$0.section][$0.row]
				return self._titleForValue?($0, value) ?? "\(value)"
			},
			didSelectRow: { [unowned self] in
				self._didSelectValue?(self.pickerView, $0, self.data[$0.section][$0.row])
			}
		)
		
		pickerView.delegate = delegate
		pickerView.dataSource = delegate
	}
	
	public override init(nibName: String?, bundle: Bundle?) { fatalError() }
	public required init?(coder aDecoder: NSCoder) { fatalError() }
}


private class PickerViewDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
	
	let numberOfComponents: () -> Int
	let numberOfRowsInComponent: (Int) -> Int
	let titleForRow: (IndexPath) -> String?
	let didSelectRow: (IndexPath) -> ()
	
	init(numberOfComponents: @escaping () -> Int, numberOfRowsInComponent: @escaping (Int) -> Int, titleForRow: @escaping (IndexPath) -> String?, didSelectRow: @escaping (IndexPath) -> ()) {
		self.numberOfComponents = numberOfComponents
		self.numberOfRowsInComponent = numberOfRowsInComponent
		self.titleForRow = titleForRow
		self.didSelectRow = didSelectRow
	}
	
	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return numberOfComponents()
	}
	
	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return numberOfRowsInComponent(component)
	}
	
	open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return titleForRow(IndexPath(row: row, section: component))
	}
	
	open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		didSelectRow(IndexPath(row: row, section: component))
	}
}
