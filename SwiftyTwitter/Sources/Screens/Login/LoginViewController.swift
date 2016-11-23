//
//  LoginViewController.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 10/14/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIComponents
import AccessProvider
import Tools

final class LoginViewController: ViewController, LoginViewDelegate, KeyboardListenerDelegate {
	
	private weak var contentView: LoginView?
	private let auth = Authentication()
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		let contentView = LoginView()
		self.contentView = contentView
		view = contentView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let username = Settings.shared.username {
			contentView?.usernameValue = username
		}
		contentView?.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		KeyboardListener.shared.addDelegate(delegate: self)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		KeyboardListener.shared.removeDelegate(delegate: self)
	}
	
	// MARK: - KeyboardListenerDelegate
	
	func keyboardListener(_ listener: KeyboardListener, willAnimateWithDuration duration: TimeInterval) {
		contentView?.bottomInset += listener.diff
	}
	
	func keyboardListener(_ listener: KeyboardListener, animateWithDuration duration: TimeInterval) {
		contentView?.layoutIfNeeded()
	}
	
	// MARK: - LoginViewDelegate
	
	func loginView(_ view: LoginView, handleUsername username: String?) {
		guard let username = username, !username.isEmpty else {
			ErrorNotification.show(with: .fieldEmpty(name: "username"))
			return
		}
		processUsername(username)
	}
	
	func loginViewHandleReset(_ view: LoginView) {
		auth.invalidate()
	}
	
	private func processUsername(_ username: String, animated: Bool = true) {
		auth.perform(
			success: { [weak self] in
				let navigation = NavigationController(rootViewController: FeedViewController(username: username))
				self?.present(navigation, animated: animated, completion: nil)
			},
			failure: { error in
				ErrorNotification.show(with: error)
		})
	}
}
