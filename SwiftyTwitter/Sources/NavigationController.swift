//
//  NavigationController.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 10/14/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIKit
import Animators

class NavigationController: UINavigationController, UINavigationControllerDelegate {
	
	fileprivate let provider = AnimatorsProvider()
	
	var isInteractiveTransaction: Bool {
		get { return provider.isInteractive }
		set { provider.isInteractive = newValue }
	}
	
	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
		delegate = self
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		delegate = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func navigationController(_ navigationController: UINavigationController,
	                          interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
		-> UIViewControllerInteractiveTransitioning? {
			return provider.interactiveAnimatorForTransition()
	}
	
	func navigationController(_ navigationController: UINavigationController,
	                          animationControllerFor operation: UINavigationControllerOperation,
	                          from fromVC: UIViewController,
	                          to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return provider.animatorForTransition(from: fromVC, to: toVC)
	}
	
	func navigationController(_ navigationController: UINavigationController,
	                          didShow viewController: UIViewController, animated: Bool) {
		isInteractiveTransaction = false
	}
}

// MARK: - UIViewController+customNavigation

extension UIViewController {
	
	var customNavigation: NavigationController? {
		return navigationController as? NavigationController
	}
}
