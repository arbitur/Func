//
//  AppDelegate.swift
//  FuncExample
//
//  Created by Philip Fryklund on 28/Feb/17.
//  Copyright © 2017 Arbitur. All rights reserved.
//

import UIKit
import Func
import Alamofire





@UIApplicationMain
class AppDelegate: UIResponder {
	var window: UIWindow?


	fileprivate func loadWindow() {
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.makeKeyAndVisible()
		self.window = window
		
		let vc = Page1()
		let nc = UINavigationController(rootViewController: vc)
		nc.navigationBar.isTranslucent = false
		window.rootViewController = nc
	}
}




extension AppDelegate: UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
//		let color = UIColor.cyan
//		print(color.rgba)
//		print(color.hsl)
//		print(color.hsb)
//		
//		print()
//		
//		do {
//			try Archiver.archive(["a": 1, "b": "cdefg"], forKey: "test")
//		}
//		catch {
//			print(error.localizedDescription)
//		}
//		
//		let test: Dict? = Archiver.unarchive(forKey: "test")
//		print("Unarchived", test ?? "nil")
		
//		let geocoding = Geocoding(address: "Östermalmstorg 1, Stockholm")
//		geocoding.fetch { response in
//			guard let response = response else { return print("No results") }
//			print(response.status, response.results.first?.formattedAddress ?? "nan")
//		}
		
//		loadWindow()
		
//		print(Float.nan.ifNan(23.0))
//		print(Int(true))
//		print(Bool(0))
		
		
		let json: Dict = [
			"int": 42,
			"string": "123",
			"bool": true,
			"test": [
				"a": 123
			]
		]
		
		let test = Test(json: json)
		print(test)
		
		Alamofire.request("http://127.0.0.1:8080/users", method: .get).responseJSON { response in
			switch response.result {
			case .success(let v):
				let arr = v as! [Dict]
				let users = arr.flatMap(User.init)
				print(users)
			default: return
			}
		}
		
		return true
	}
}


struct User: Func.Decodable {
	let id: Int
	let name: String
	let email: String?
	let isHidden: Bool
	let date: Date
	let array: [String]
	
	init?(json: Dict) {
		do {
			id = try json.decode("id")
			name = try json.decode("name")
			email = try? json.decode("email")
			isHidden = try json.decode("hidden")
			date = try json.decode("date", format: .dateTimeSec)
			array = try json.decode("array")
		}
		catch {
			print(error.localizedDescription)
			return nil
		}
	}
}


struct Test: Func.Decodable {
	let int: Int
	let string: String?
	let bool: Bool
	let test: Test2
	
	
	init?(json: Dict) {
		do {
			int = try json <-- "int"
			string = try? json <-- "string"
			bool = try json <-- "bool"
			test = try json <-- "test"
		}
		catch {
			print(error.localizedDescription)
			return nil
		}
	}
}

struct Test2: Func.Decodable {
	let a: Int
	
	init?(json: Dict) {
		a = try! json <-- "a"
	}
}















