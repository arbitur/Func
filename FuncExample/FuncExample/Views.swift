//
//  Views.swift
//  FuncExample
//
//  Created by Philip Fryklund on 27/Apr/17.
//  Copyright © 2017 Arbitur. All rights reserved.
//

import UIKit
import Func





class ViewsVC: UIViewController {
	let innerShadow = InnerShadowLayer()
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		innerShadow.innerShadowColor = UIColor.random.cgColor
		innerShadow.innerShadowRadius = Random.range(min: 0, max: innerShadow.bounds.height / 2)
	}
	
	override func loadView() {
		self.view = UIView(backgroundColor: .white)
		
		innerShadow.frame = CGRect(x: 10, y: 80, width: 300, height: 100)
		innerShadow.cornerRadius = 50
		innerShadow.innerShadowRadius = 10
		innerShadow.innerShadowColor = UIColor.red.alpha(0.5).cgColor
		self.view.layer.addSublayer(innerShadow)
		
		
		
		let label = UILabel()
		label.text = "asdf"
		label.setAttributes([.font(UIFont.systemFont(ofSize: 40)), TextAttributes.background(.red)])
		label.addAttributes([TextAttributes.foreground(.blue)], to: "sd")
		label.sizeToFit()
		self.view.add(view: label)
	}
}
