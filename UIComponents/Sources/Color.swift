//
//  Color.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/11/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIKit

public extension UIColor {
 
	public static var amaranth: UIColor { return rgba(238, 45, 67) }
	
	public static var malibu: UIColor { return rgba(109, 184, 224) }
	
	public static var paleCornflowerBlue: UIColor { return rgba(191, 223, 242) }
	public static var pictonBlue: UIColor { return rgba(80, 165, 211) }
	public static var pictonBlueDarker: UIColor { return rgba(5, 90, 131) }
}

private func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
	return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
}
