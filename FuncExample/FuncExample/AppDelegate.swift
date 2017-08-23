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
import CoreLocation





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

		loadWindow()
		
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

		GeocodingAPI.loggingMode = .url
		GeocodingAPI.key = "AIzaSyCBWku312Br8Rsh8YXhzNkDN3vsy2Iz6yA"
		
		ReverseGeocode(
			coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 10),
			resultTypes: [.streetAddress],
			locationTypes: [.roofTop],
			language: "sv"
		)
		.fetch(
			success: { response in
				print(response)
			},
			failure: { error in
				print("Error:", error)
			}
		)
		
		Geocode(address: "Östermalmstorg 1", components: [.locality: "Östermalm"], region: "sv")
		.fetch(
			success: { response in
				print(response)
			},
			failure: { error in
				print("Error:", error)
			}
		)
		
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















