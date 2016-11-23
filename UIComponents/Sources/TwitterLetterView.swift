//
//  TwitterLetterView.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/11/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIKit

private let pi = CGFloat(M_PI)

public final class TwitterLetterView: UIView {
	
	public var fillColor = UIColor.white {
		didSet { setNeedsDisplay() }
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .clear
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func draw(_ rect: CGRect) {
		let path = UIBezierPath()
		let rounding: CGFloat = rect.height * 0.1
		let vertical: CGFloat = rect.height * 0.2
		let rightLine: CGFloat = rect.width - rounding * 3
		
		path.addArc(
			withCenter: CGPoint(x: rounding, y: rounding), radius: rounding,
			startAngle: pi, endAngle: 0, clockwise: true)
		path.addLine(to: CGPoint(x: rounding + rounding, y: vertical))
		path.addLine(to: CGPoint(x: rounding + rounding + rightLine, y: vertical))
		path.addArc(
			withCenter: CGPoint(x: rounding + rounding + rightLine, y: vertical + rounding),
			radius: rounding,
			startAngle: pi * 1.5, endAngle: pi * 0.5, clockwise: true)
		path.addLine(to: CGPoint(x: rounding + rounding, y: vertical + rounding * 2))
		path.addLine(to: CGPoint(x: rounding + rounding, y: vertical + rounding * 4))
		path.addQuadCurve(
			to: CGPoint(
				x: rounding + rounding + rounding * 1.75, y: vertical + rounding * 4 + rounding * 0.75),
			controlPoint: CGPoint(
				x: rounding + rounding, y: vertical + rounding * 4 + rounding * 0.75))
		path.addLine(to: CGPoint(x: rect.maxX, y: vertical + rounding * 4 + rounding * 0.75))
		path.addArc(
			withCenter: CGPoint(
				x: rect.maxX - rounding, y: vertical + rounding * 4 + rounding * 0.75 + rounding),
			radius: rounding,
			startAngle: pi * 1.5, endAngle: pi * 0.5, clockwise: true)
		path.addLine(to: CGPoint(
			x: rounding - rounding * 2, y: vertical + rounding * 4 + rounding * 0.75 + rounding * 2))
		path.addArc(
			withCenter: CGPoint(x: rounding * 2, y: vertical + rounding * 4 + rounding * 0.75),
			radius: rounding * 2,
			startAngle: pi * 0.5, endAngle: pi, clockwise: true)
		
		fillColor.setFill()
		path.fill()
	}
}
