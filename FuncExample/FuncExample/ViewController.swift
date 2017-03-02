//
//  ViewController.swift
//  FuncExample
//
//  Created by Philip Fryklund on 28/Feb/17.
//  Copyright © 2017 Arbitur. All rights reserved.
//

import UIKit
import Func





class ViewController: UIViewController {
	let gradientView = RadialGradientView()
	
	
	
	override func loadView() {
		self.view = gradientView
		
		gradientView.colorComponents = [
			(UIColor.white.alpha(0.5), 0),
			(.blue, 0.5),
			(.black, 1)
		]
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = .red
	}
	
}

