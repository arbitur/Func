//
//  Result+Func.swift
//  Func
//
//  Created by Arbitur on 2020-09-17.
//

import Foundation


public extension Swift.Result {
	
	var value: Success? {
		switch self {
		case .success(let value): return value
		case .failure: return nil
		}
	}
	
	var error: Failure? {
		switch self {
		case .success: return nil
		case .failure(let error): return error
		}
	}
}
