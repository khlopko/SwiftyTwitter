//
//  AnimatorsProvider.swift
//
//  Created on 10/7/16.
//  Copyright © 2016. All rights reserved.
//

//import CustomUI
import Tools

open class AnimatorsProvider: NSObject {
	
	open var isInteractive = false {
		didSet {
			interactiveAnimator?.isInteractive = isInteractive
		}
	}
	
	fileprivate let scrollAnimator = InteractiveScrollAnimator()
	fileprivate var animators: [AnimatorProtocol] {
		return [scrollAnimator]
	}
	fileprivate weak var currentAnimator: AnimatorProtocol?
	fileprivate var interactiveAnimator: InteractiveAnimator? {
		return currentAnimator as? InteractiveAnimator
	}
	
	open func animatorForTransition(from fromVC: UIViewController,
	                                to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		let animator = animators
			.filter { $0.validateViewControllers(fromVC: fromVC, toVC: toVC) }
			.first
		currentAnimator = animator
		return animator
	}
	
	public func interactiveAnimatorForTransition() -> UIViewControllerInteractiveTransitioning? {
		interactiveAnimator?.isInteractive = isInteractive
		if isInteractive, let animator = interactiveAnimator as? UIViewControllerInteractiveTransitioning {
			return animator
		}
		return nil
	}
}
