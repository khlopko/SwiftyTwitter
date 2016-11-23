//
//  String+frame.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/13/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Foundation

public extension String {
	
	func width(font: UIFont) -> CGFloat {
		let string = NSString(string: self)
		let width = string.size(attributes: [NSFontAttributeName: font]).width
		return ceil(width)
	}
	
	func height(width: CGFloat, font: UIFont) -> CGFloat {
		let inputSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
		let outputSize = self.boundingRect(
			with: inputSize,
			options: [.usesLineFragmentOrigin, .usesFontLeading],
			attributes: [NSFontAttributeName: font],
			context: nil)
		return ceil(outputSize.height)
	}
}
