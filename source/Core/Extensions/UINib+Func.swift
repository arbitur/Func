//
//  UINib+Func.swift
//  Alamofire
//
//  Created by Philip Fryklund on 5/Sep/18.
//

import Foundation





public extension UINib {
	
	convenience init(name: String) {
		self.init(nibName: name, bundle: .main)
	}
}
