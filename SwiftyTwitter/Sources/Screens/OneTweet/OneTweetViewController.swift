//
//  OneTweetViewController.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/13/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIComponents
import Entities
import Animators

class OneTweetViewController: ViewController, InteractiveScrollViewControllerProtocol {
	
	fileprivate weak var contentView: OneTweetView?
	
	private let tweet: Tweet
	
	var pan: UIPanGestureRecognizer? {
		return nil
	}
	var mainView: UIView {
		return view
	}
	
	init(tweet: Tweet) {
		self.tweet = tweet
		super.init(nibName: nil, bundle: nil)
		modalPresentationStyle = .custom
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		let contentView = OneTweetView()
		self.contentView = contentView
		view = contentView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.hidesBarsOnSwipe = false
		navigationItem.title = "\(tweet.user.fullname)'s tweet"
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: ImageDrawer.drawBack(color: .white, size: CGSize(width: 44, height: 44)),
			style: .plain, target: self, action: #selector(handle(back:)))
		contentView?.tweet = tweet
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	
	func handle(back: UIBarButtonItem) {
		_ = navigationController?.popViewController(animated: true)
	}
}
