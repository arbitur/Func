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
//		window.rootViewController = nc
		
		
		let slide = SlideMenuController()
		slide.rootViewController = nc//RootVC()
		slide.menuViewController = MenuVC()
		window.rootViewController = slide
	}
}

class MenuVC: DebugViewController, MenuViewControllable {
	weak var controller: SlideMenuController?
	
	func attached(to controller: SlideMenuController) {
	}
	
	
	private class VC: DebugViewController {
		override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
			self.slideMenuController?.openMenu()
		}
		override func loadView() {
			let label = UILabel(font: UIFont.systemFont(ofSize: 18), alignment: .center)
			label.backgroundColor = .white
			label.text = self.title
			label.isUserInteractionEnabled = true
			self.view = label
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let vc = VC()
		vc.title = "Text \(Random.range(0..<10))"
		controller?.rootViewController = vc
		self.close()
	}
	
	override func loadView() {
		self.view = UIView(backgroundColor: .red)
	}
}

class RootVC: DebugViewController {
	override func loadView() {
		self.view = UIView(backgroundColor: .green)
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

//		GeocodingAPI.loggingMode = .url
//		GeocodingAPI.key = "AIzaSyCBWku312Br8Rsh8YXhzNkDN3vsy2Iz6yA"
		
//		GeocodingAPI.request(Geocode(address: "Östermalmstorg 1, Stockholm"))
//		.success { status, response in
//			print(response)
//		}
//		.failure { error in
//			print(error)
//		}
		
		return true
	}
}
















