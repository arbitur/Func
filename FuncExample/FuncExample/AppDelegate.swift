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
		
//		let vc = Page1()
//		let nc = UINavigationController(rootViewController: vc)
//		nc.navigationBar.isTranslucent = false
//		window.rootViewController = nc
		
		
//		let slide = SlideMenuController()
//		slide.rootViewController = RootVC()
//		slide.menuViewController = MenuVC()
//		window.rootViewController = slide
		
		let slide2 = SlideMenuController()
		slide2.rootViewController = RootVC()
		slide2.menuViewController = MenuVC()
		window.rootViewController = slide2
		
//		let tabController = SlideTabController_NEW()
//		tabController.addChildViewController(RootVC())
//		tabController.addChildViewController(RootVC())
//		tabController.addChildViewController(RootVC())
//		window.rootViewController = tabController
		
		print("iPhone screen size:", UIScreen.main.screenSize.rawValue)
	}
}

class MenuVC: DebugViewController {
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
		self.dismiss(animated: true, completion: nil)
	}
	
	override func loadView() {
		self.view = UIView(backgroundColor: .red)
	}
}

class RootVC: DebugViewController {
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let vc = RootVC()
		vc.title = "Text \(Random.range(0..<10))"
		self.slideMenuController?.rootViewController = vc
	}
	
	override func loadView() {
		let label = UILabel()
		label.backgroundColor = .random
		label.isUserInteractionEnabled = true
		label.textAlignment = .center
		label.textColor = .white
		label.text = self.title ?? "RootVC"
		self.view = label
	}
}




extension AppDelegate: UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

//		loadWindow()
		
		
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
















