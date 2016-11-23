//
//  Error.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/10/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

public enum AppError: Error {
	
	case fieldEmpty(name: String?)
	case undefined
	
	public var localizedDescription: String {
		switch self {
		case .undefined:
			return "Someting goes wrong... Please, try again or later"
		case let .fieldEmpty(name):
			if let name = name {
				return "Please, fill \(name) field and try again"
			} else {
				return "You have empty fields, but they are requeired. Please, fill them and try again"
			}
		}
	}
}
