//
//  DateFormatter.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/16/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Foundation

public final class DateFormatter {
	
	private static let formatter: Foundation.DateFormatter = {
		let formatter = Foundation.DateFormatter()
		return formatter
	}()
	
	public enum Format: String {
		case web = "E MMM dd HH:mm:ss Z yyyy"
		case presentation = "dd MMMM yyyy, HH:mm:ss"
		
		var asString: String {
			return rawValue
		}
	}
	
	public static func string(from date: Date, usingFormat format: Format? = nil) -> String {
		let previousFormat = formatter.dateFormat
		if let format = format {
			formatter.dateFormat = format.asString
		}
		let dateString = formatter.string(from: date)
		formatter.dateFormat = previousFormat
		return dateString
	}
	
	public static func date(from string: String, usingFormat format: Format? = nil) -> Date {
		let previousFormat = formatter.dateFormat
		if let format = format {
			formatter.dateFormat = format.asString
		}
		let date = formatter.date(from: string)
		formatter.dateFormat = previousFormat
		return date ?? Date(timeIntervalSince1970: 0)
	}
}
