//
//  Regex.swift
//  Func
//
//  Created by Philip Fryklund on 19/Aug/19.
//

import Foundation





public class Regex {
	
	public enum Pattern: String {
		case email = "^[\\w!#$%&'*+/=?^`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?$"
	}
}
