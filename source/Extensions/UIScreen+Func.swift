//
//  UIScreen+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Feb/17.
//
//

import UIKit





public extension UIScreen {
	var screenSize: ScreenSize {
		return ScreenSize()
	}
	
	
	
	
	public enum ScreenSize: Int {
		case inch3_5
		case inch4
		case inch4_7
		case inch5_5
//		case unknown
		
		fileprivate init() {
			switch UIScreen.main.nativeBounds.size {
				case CGSize(320, 480)	: fallthrough
				case CGSize(640, 960)	: self = .inch3_5
				case CGSize(640, 1136)	: self = .inch4
				case CGSize(750, 1334)	: self = .inch4_7
				case CGSize(1080, 1920)	: self = .inch5_5
				default					: self = .inch5_5
			}
		}
	}
}
