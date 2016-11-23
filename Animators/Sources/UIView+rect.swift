//
//  UIView+rect.swift
//
//  Created on 10/7/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

extension UIView {
	
	func rectInView(_ view: UIView) -> CGRect? {
		return superview?.convert(frame, to: view)
	}
}
