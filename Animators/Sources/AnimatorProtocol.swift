//
//  AnimatorProtocol.swift
//  GoChat
//
//  Created on 4/13/16.
//  Copyright © 2016 GoChat Inc. All rights reserved.
//

import UIKit

public protocol AnimatorProtocol: UIViewControllerAnimatedTransitioning {
	func validateViewControllers(fromVC: UIViewController, toVC: UIViewController) -> Bool
}
