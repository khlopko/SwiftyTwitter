//
//  Run.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/10/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Foundation

public struct Run {
	
	public static func after(_ delay: Double, closure: @escaping () -> ()) {
		DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
	}
	
	public static func inMain(_ closure: @escaping () -> ()) {
		if Thread.isMainThread {
			closure()
		} else {
			DispatchQueue.main.async(execute: closure)
		}
	}
	
	private init() {
	}
}
