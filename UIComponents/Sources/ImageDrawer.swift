//
//  ImageDrawer.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/13/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Foundation

public struct ImageDrawer {
	
	public static func drawBack(color: UIColor, size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		let path = UIBezierPath()
		path.lineWidth = 2
		path.move(to: CGPoint(x: size.width * 0.25, y: size.height * 0.25))
		path.addLine(to: CGPoint(x: 2, y: size.height * 0.5))
		path.addLine(to: CGPoint(x: size.width * 0.25, y: size.height * 0.75))
		color.setStroke()
		path.stroke()
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}
}
