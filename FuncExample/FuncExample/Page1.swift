//
//  Page1.swift
//  FuncExample
//
//  Created by Philip Fryklund on 17/Apr/17.
//  Copyright © 2017 Arbitur. All rights reserved.
//

import UIKit
import Func
import WebKit





class Page1: TableViewController {
	override var examples: Examples {
		return [
			("Alert", alert),
			("ActionSheet", actionSheet),
			("AlertDialog", alertDialog),
			("SheetDialog", sheetDialog),
			("Views", openViews)
		]
	}
	
	
	
	func alert() {
		let alert = UIAlertController(title: "Title", message: nil, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Normal", style: UIAlertActionStyle.default, handler: nil))
		alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: nil))
//		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
		self.navigationController?.present(alert)
	}
	
	func actionSheet() {
		let alert = UIAlertController(title: "Title", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
		alert.addAction(UIAlertAction(title: "Normal", style: UIAlertActionStyle.default, handler: nil))
		alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: nil))
//		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
		self.navigationController?.present(alert)
	}
	
	func alertDialog() {
		let webView = WKWebView()
		webView.load(URLRequest(url: "https://google.se"))
		
		let alert = AlertDialog(title: "Title", subtitle: "Subtitle")
			.setCustomView(webView) {
				webView.lac.height.equal(to: $0.view.lac.height, priority: 500)
			}
//			.addNormal(title: "Normal", callback: {})
//			.addDelete(title: "Delete", callback: {})
			.addCancel(title: "Cancel")
		self.navigationController?.present(alert)
	}
	
	func sheetDialog() {
//		let delegate = PickerDelegate(rows: (0..<5).map({ "Test \($0)" }))
//		let picker = UIPickerView()
//		picker.delegate = delegate
//		picker.dataSource = delegate
//		picker.lac.height.equal(to: 150)
		
		let webView = WKWebView()
		webView.load(URLRequest(url: "https://google.se"))
		
		let sheet = SheetDialog(title: "Intervall", subtitle: nil)
			.setCustomView(webView) {
				webView.lac.height.equal(to: $0.view.lac.height, priority: 500)
			}
//			.addNormal(title: "Välj intervall") {
//				print(delegate.rows[picker.selectedRow(inComponent: 0)])
//			}
//			.addDelete(title: "Delete", callback: {})
			.addCancel(title: "Cancel")
		self.navigationController?.present(sheet)
	}
	
	
	func openViews() {
		let vc = ViewsVC()
		self.navigationController?.pushViewController(vc, animated: true)
	}
}


class PickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
	let rows: [String]
	
	init(rows: [String]) {
		self.rows = rows
	}
	
	deinit {
		print("~PickerDelegate")
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return rows.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return rows[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		print(rows[row])
	}
}



















