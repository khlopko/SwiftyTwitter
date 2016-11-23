//
//  InteractiveScrollAnimator.swift
//
//  Created on 10/6/16.
//  Copyright © 2016. All rights reserved.
//

import UIComponents
import Tools

// MARK: - InteractiveScrollViewControllerProtocol

public protocol InteractiveScrollViewControllerProtocol: class {
	
	var pan: UIPanGestureRecognizer? { get }
	var mainView: UIView { get }
}

// MARK: - InteractiveScrollAnimator

public final class InteractiveScrollAnimator: InteractiveAnimator, UIViewControllerInteractiveTransitioning {
	
	fileprivate var context: UIViewControllerContextTransitioning?
	fileprivate let transformScale: CGFloat = 0.85
	fileprivate var reverse = false
	fileprivate var startPoint: CGPoint?
	private weak var pan: UIPanGestureRecognizer?
	
	public override var isInteractive: Bool {
		didSet {
			if !isInteractive, let pan = pan {
				pan.removeTarget(self, action: #selector(handlePan))
			}
			startPoint = nil
		}
	}
	
	public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
		context = transitionContext
		prepareContext()
		guard let pan = from.pan else {
			finishInteractiveTransition()
			return
		}
		self.pan = pan
		pan.addTarget(self, action: #selector(handlePan))
	}
	
	func handlePan(_ pan: UIPanGestureRecognizer) {
		let translation = pan.location(in: containerView)
		let velocity = pan.velocity(in: containerView)
		switch pan.state {
		case .changed:
			handlePanChange(translation: translation)
		case .ended:
			handlePanEnd(velocity: velocity)
		default:
			cancelInteractiveTransition()
		}
	}
}

// MARK: - AnimatorProtocol

extension InteractiveScrollAnimator: AnimatorProtocol {
	
	public func validateViewControllers(fromVC: UIViewController, toVC: UIViewController) -> Bool {
		let valid =
			fromVC is InteractiveScrollViewControllerProtocol &&
				toVC is InteractiveScrollViewControllerProtocol
		return valid
	}
}

// MARK: - UIViewControllerAnimatedTransitioning

extension InteractiveScrollAnimator: UIViewControllerAnimatedTransitioning {
	
	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.4
	}
	
	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		context = transitionContext
		prepareContext()
		if !isInteractive {
			let animation = reverse ? reverseAnimation : defaultAnimation
			startAnimation(animation)
		}
	}
}

// MARK: - Private Support

private extension InteractiveScrollAnimator {
	
	func prepareContext() {
		let origin: CGPoint
		if let navigationFrame = toViewController.navigationController?.navigationBar.frame {
			origin = CGPoint(x: 0, y: navigationFrame.maxY)
		} else {
			origin = .zero
		}
		var size = containerView.bounds.size
		size.height -= origin.y
		to.mainView.frame = CGRect(origin: origin, size: size)
		if reverse {
			containerView.insertSubview(to.mainView, belowSubview: from.mainView)
			to.mainView.alpha = 0
			to.mainView.transform = CGAffineTransform(scaleX: transformScale, y: transformScale)
		} else {
			containerView.insertSubview(to.mainView, aboveSubview: from.mainView)
			to.mainView.frame.origin.x = containerView.frame.maxX
		}
		to.mainView.layoutIfNeeded()
		containerView.backgroundColor = .white
	}
	
	func startAnimation(_ animation: @escaping () -> ()) {
		UIView.animate(
			withDuration: transitionDuration(using: context),
			animations: animation,
			completion: completion)
	}
	
	func completion(_ finished: Bool) {
		guard let context = context else { return }
		containerView.backgroundColor = .white
		let wasCancelled = context.transitionWasCancelled
		from.mainView.transform = CGAffineTransform.identity
		to.mainView.transform = CGAffineTransform.identity
		if wasCancelled {
			from.mainView.frame = containerView.bounds
		} else {
			reverse = !reverse
		}
		isInteractive = false
		context.completeTransition(!wasCancelled)
	}
	
	func handlePanChange(translation: CGPoint) {
		if startPoint == nil {
			startPoint = translation
		}
		let deltaY = (startPoint?.y ?? 0) - translation.y
		let newY = from.mainView.frame.origin.y - deltaY
		if deltaY < 0 && newY > 0 {
			cancelInteractiveTransition()
			return
		}
		from.mainView.frame.origin = CGPoint(x: 0, y: newY)
		let maxTransformShift = containerView.frame.height * 0.5
		let currentY = fabs(from.mainView.frame.origin.y)
		let k = min(1, currentY / maxTransformShift)
		let scale = k * 0.1 + 0.9
		to.mainView.alpha = k
		to.mainView.transform = CGAffineTransform(scaleX: scale, y: scale)
		startPoint = translation
	}
	
	func handlePanEnd(velocity: CGPoint) {
		let halfContainer = fabs(from.mainView.frame.minY) >= containerView.frame.height * 0.5
		if fabs(velocity.y) > 1000 || halfContainer {
			finishInteractiveTransition()
		} else {
			cancelInteractiveTransition()
		}
	}
	
	func finishInteractiveTransition() {
		context?.finishInteractiveTransition()
		startAnimation(interactiveAnimation)
	}
	
	func cancelInteractiveTransition() {
		context?.cancelInteractiveTransition()
		guard let state = from.pan?.state else { return }
		switch state {
		case .ended, .possible:
			UIView.animate(
				withDuration: 0.2,
				delay: 0,
				options: [.allowUserInteraction],
				animations: cancelAnimation,
				completion: completion)
		default:
			completion(true)
		}
	}
}

// MARK: - Animations

private extension InteractiveScrollAnimator {
	
	func defaultAnimation() {
		from.mainView.transform = CGAffineTransform(scaleX: transformScale, y: transformScale)
		from.mainView.alpha = 0
		to.mainView.frame.origin.x = 0
	}
	
	func reverseAnimation() {
		from.mainView.frame.origin.x = from.mainView.frame.width
		to.mainView.transform = CGAffineTransform.identity
		to.mainView.alpha = 1
	}
	
	func interactiveAnimation() {
		from.mainView.frame.origin.y = -from.mainView.frame.height
		from.mainView.alpha = 0.5
		to.mainView.transform = CGAffineTransform.identity
		to.mainView.alpha = 1
	}
	
	func cancelAnimation() {
		from.mainView.frame = containerView.bounds
		from.mainView.alpha = 1
		to.mainView.alpha = 0
	}
}

// MARK: - Private computed properties

private extension InteractiveScrollAnimator {
	
	var containerView: UIView {
		guard let containerView = context?.containerView else {
			fatalError("Illegal state, containerView is nil!")
		}
		return containerView
	}
	var to: InteractiveScrollViewControllerProtocol {
		guard let toVC = toViewController as? InteractiveScrollViewControllerProtocol else {
			fatalError("Illegal state: toVC do not confirm InteractiveScrollViewControllerProtocol!")
		}
		return toVC
	}
	var from: InteractiveScrollViewControllerProtocol {
		guard let from = fromViewController as? InteractiveScrollViewControllerProtocol else {
			fatalError("Illegal state: fromVC do not confirm InteractiveScrollViewControllerProtocol!")
		}
		return from
	}
	var fromViewController: UIViewController {
		guard let viewController = context?.viewController(forKey: .from) else {
			fatalError("Illegal state: fromVC do not confirm InteractiveScrollViewControllerProtocol!")
		}
		return viewController
	}
	var toViewController: UIViewController {
		guard let viewController = context?.viewController(forKey: .to) else {
			fatalError("Illegal state: toVC do not confirm InteractiveScrollViewControllerProtocol!")
		}
		return viewController
	}
}
