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
		let alert = AlertDialog(title: "Title", subtitle: "Subtitle")
		alert.addCancel(title: "Cancel")
		self.navigationController?.present(alert)
	}
	
	func sheetDialog() {
		let webView = WKWebView()
		webView.load(URLRequest(url: "https://google.se"))
		
//		let sheet = SheetDialog(title: "Intervall", subtitle: nil)
//			.setCustomView(webView) {
//				webView.lac.height.equal(to: $0.view.lac.height, priority: 500)
//			}
//			.addCancel(title: "Cancel")
		
//		let sheet = DateSheetDialog(title: "Datum", subtitle: nil)
//		sheet.addNormal(title: "Välj Datum") { [unowned sheet] in
//			print(sheet.datePicker.date)
//		}
//		sheet.datePicker.minimumDate = Date()
		
//		let sheet = WebSheetDialog(title: nil, subtitle: nil)
//		sheet.load("https://google.se")
		
		let imageView = UIImageView(image: #imageLiteral(resourceName: "img_lights"))
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		let constraint = imageView.lac.height.equal(to: 0)
		
		let sheet = PickerSheetDialog(title: "Intervall", subtitle: nil)
		sheet.addColumn(rows: ["En gång", "Varje vecka", "Varannan vecka", "Varje månad"])
		sheet.addNormal(title: "Välj") { [unowned sheet] in
			print(sheet.data[0][sheet.picker.selectedRow(inComponent: 0)])
		}
		sheet.didSelectRow { [unowned sheet] column, row in
			print(sheet.data[column][row])
			constraint.isActive = row != 0
		}
		sheet.addCustomView(imageView, at: 0)
		sheet.didAddCustomViewToSuperview = { [unowned sheet] _, view in
			if view === sheet.picker {
				sheet.picker.selectRow(3, inComponent: 0, animated: false)
			}
		}
		
		self.navigationController?.present(sheet)
	}
	
	func openViews() {
	
		let vc = ViewsVC()
		self.navigationController?.pushViewController(vc, animated: true)
	}
}



















