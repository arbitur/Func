//
//  AppDelegate.swift
//  FuncExample
//
//  Created by Philip Fryklund on 28/Feb/17.
//  Copyright © 2017 Arbitur. All rights reserved.
//

import UIKit
import Func





@UIApplicationMain
class AppDelegate: UIResponder {
	var window: UIWindow?


	fileprivate func loadWindow() {
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.makeKeyAndVisible()
		self.window = window
		
		let vc = Page1()
		let nc = UINavigationController(rootViewController: vc)
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
		
		loadWindow()
		
		return true
	}
}



















