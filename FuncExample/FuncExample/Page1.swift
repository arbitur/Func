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
		let alert = UIAlertController(title: "Title", message: "Subtitle", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Normal", style: UIAlertActionStyle.default, handler: nil))
		alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: nil))
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
		self.navigationController?.present(alert)
	}
	
	func actionSheet() {
		let alert = UIAlertController(title: "Title", message: "Subtitle", preferredStyle: UIAlertControllerStyle.actionSheet)
		alert.addAction(UIAlertAction(title: "Normal", style: UIAlertActionStyle.default, handler: nil))
		alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: nil))
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
		self.navigationController?.present(alert)
	}
	
	func alertDialog() {
		let alert = AlertDialog(title: "Title", subtitle: "Subtitle")
		alert.addNormal(title: "Normal", action: {})
		alert.addDelete(title: "Delete", action: {})
		alert.addCancel(title: "Cancel")
		self.navigationController?.present(alert)
	}
	
	func sheetDialog() {
//		let webView = WKWebView()
//		webView.load(URLRequest(url: "https://google.se"))
//
//		let sheet = SheetDialog(title: "Intervall", subtitle: nil)
//		sheet.addCustomView(webView)
//		sheet.addCancel(title: "Cancel")
//		sheet.didAddCustomViewToSuperview = { vc, view in
//			webView.lac.height.equal(to: vc.view.lac.height, priority: 500)
//		}
		
		
//		let sheet = DateSheetDialog(title: "Datum", subtitle: nil)
//		sheet.addNormal(title: "Välj Datum") { [unowned sheet] in
//			print(sheet.datePicker.date)
//		}
//		sheet.datePicker.minimumDate = Date()
		
		
//		let sheet = WebSheetDialog(title: "Title", subtitle: "Subtitle", url: "https://google.se")
		
		
//		let imageView = UIImageView(image: #imageLiteral(resourceName: "img_lights"))
//		imageView.contentMode = .scaleAspectFill
//		imageView.clipsToBounds = true
//		let constraint = imageView.lac.height.equal(to: 0)
//
//		let sheet = PickerSheetDialog(title: "Intervall", subtitle: nil)
//		sheet.addColumn(rows: ["En gång", "Varje vecka", "Varannan vecka", "Varje månad"])
//		sheet.addNormal(title: "Välj") { [unowned sheet] in
//			print(sheet.data[0][sheet.pickerView.selectedRow(inComponent: 0)])
//		}
//		sheet.setDidSelectRow { [unowned sheet] column, row in
//			print(sheet.data[column][row])
//			constraint.isActive = row != 0
//		}
//		sheet.addCustomView(imageView, at: 0)
//		sheet.didAddCustomViewToSuperview = { [unowned sheet] _, view in
//			if view === sheet.pickerView {
//				sheet.pickerView.selectRow(3, inComponent: 0, animated: false)
//			}
//		}
		
		let sheet = SheetDialog(title: "Title", subtitle: "Subtitle")
		sheet.addNormal(title: "Normal", action: {})
		sheet.addDelete(title: "Delete", action: {})
		sheet.addCancel(title: "Cancel")
		
		self.navigationController?.present(sheet)
	}
	
	func openViews() {
	
		let vc = ViewsVC()
		self.navigationController?.pushViewController(vc, animated: true)
	}
}



















