//
//  Router.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 10/14/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIKit

final class Router {
    
    fileprivate let mainWindow = UIWindow(frame: UIScreen.main.bounds)
    fileprivate var windowSetted = false
    
    @discardableResult
    func setupWindow(rootViewController: UIViewController) -> Bool {
        if windowSetted {
            return false
        }
        mainWindow.backgroundColor = .white
        mainWindow.rootViewController = rootViewController
        mainWindow.makeKeyAndVisible()
        windowSetted = true
        return true
    }
    
    func changeRootViewController(with viewController: UIViewController, animated: Bool) {
        let duration = animated ? 0.3 : 0
        UIView.transition(
            with: mainWindow,
            duration: duration,
            options: .transitionFlipFromTop,
            animations: { self.mainWindow.rootViewController = viewController },
            completion: nil)
    }
}
