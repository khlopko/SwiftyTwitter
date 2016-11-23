//
//  Parse.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/11/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//


// MARK: - Parse function

public func parse<In, Out: Convertible>(_ input: In?) -> Out {
	return Out.cast(input)
}

public func parse<In, Out>(_ input: In?, _ map: (In) -> (Out)) -> [Out] {
	let array: [In] = parse(input)
	let result = array.map(map)
	return result
}

// MARK: - Convertible

public protocol Convertible {
	static func cast<T>(_ input: T) -> Self
}

extension String: Convertible {
	
	public static func cast<T>(_ input: T) -> String {
		switch input {
		case let str as String:
			return str
		case let conv as CustomStringConvertible:
			return conv.description
		default:
			return ""
		}
	}
}

extension Int: Convertible {
	
	public static func cast<T>(_ input: T) -> Int {
		switch input {
		case let int as Int:
			return int
		case let double as Double:
			return Int(double)
		case let string as String:
			if let int = Int(string) {
				return int
			}
			if let double = Double(string) {
				return Int(double)
			}
			return 0
		default:
			return 0
		}
	}
}

extension Int64: Convertible {
	
	public static func cast<T>(_ input: T) -> Int64 {
		switch input {
		case let int as Int:
			return Int64(int)
		case let int64 as Int64:
			return int64
		default:
			return 0
		}
	}
}

extension Double: Convertible {
	
	public static func cast<T>(_ input: T) -> Double {
		return input as? Double ?? 0
	}
}

extension Array: Convertible {
	
	public static func cast<T>(_ input: T) -> Array {
		return input as? [Element] ?? []
	}
}

extension Bool: Convertible {
	
	public static func cast<T>(_ input: T) -> Bool {
		return input as? Bool ?? false
	}
}

extension Dictionary: Convertible {
	
	public static func cast<T>(_ input: T) -> Dictionary {
		return input as? Dictionary ?? [:]
	}
}
