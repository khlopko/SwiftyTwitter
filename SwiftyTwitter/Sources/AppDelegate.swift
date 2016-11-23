//
//  AppDelegate.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 10/14/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIComponents
import Tools
import AccessProvider

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	fileprivate let router = Router()
	private let auth = Authentication()
	
	func application(_ application: UIApplication,
	                 didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		ErrorNotification.isAutohideEnabled = true
		ErrorNotification.showTimeInterval = 5
		return router.setupWindow(rootViewController: LoginViewController())
	}
}

extension UIViewController {
	
	var router: Router? {
		return (UIApplication.shared.delegate as? AppDelegate)?.router
	}
}
