//
//  LoginView.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 10/14/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIComponents
import Tools

protocol LoginViewDelegate: class {
	
	func loginView(_ view: LoginView, handleUsername username: String?)
	func loginViewHandleReset(_ view: LoginView)
}

final class LoginView: UIView, UITextFieldDelegate {
	
	weak var delegate: LoginViewDelegate?
	var bottomInset: CGFloat = 0 {
		didSet { setNeedsLayout() }
	}
	var usernameValue: String? {
		get { return username.text }
		set { username.text = newValue }
	}
	
	private let twitterLetter = LoginView.makeTwitterLetter()
	private let username = UITextField() ->> LoginView.initialize(username:)
	private let done = UIButton() ->> LoginView.initialize(done:)
	
	private var inputs: [UITextField] {
		return [username]
	}
	private var editIndex = 0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .paleCornflowerBlue
		inputs.forEach { $0.delegate = self }
		let all: [UIView] = [twitterLetter, username, done]
		all.forEach(addSubview)
		done.addTarget(self, action: #selector(handle(done:)), for: .touchUpInside)
		addGestures()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layoutTwitterLetter()
		let vertical: [UIView] = [done, username]
		var yShift: CGFloat = bottomInset
		for view in vertical {
			view.frame = CGRect(
				x: 0, y: bounds.height - yShift - Constant.itemHeight,
				width: bounds.width, height: Constant.itemHeight)
			yShift += Constant.itemHeight
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField === inputs.last {
			handle(done: done)
		} else if let index = inputs.index(where: { $0 === textField }) {
			inputs[index + 1].becomeFirstResponder()
		}
		return true
	}
	
	func handle(done: UIButton) {
		endEditing(true)
		delegate?.loginView(self, handleUsername: username.text)
	}
	
	func handle(gesture: UIGestureRecognizer) {
		if gesture.state == .possible || !username.isEditing {
			return
		}
		let point = gesture.location(in: self)
		if !username.frame.contains(point) && !done.frame.contains(point) {
			endEditing(true)
		}
	}
	
	func handle(reset: UITapGestureRecognizer) {
		endEditing(true)
		delegate?.loginViewHandleReset(self)
	}
	
	private func addGestures() {
		let gestures = [UITapGestureRecognizer(), UIPanGestureRecognizer()]
		gestures.forEach {
			$0.addTarget(self, action: #selector(handle(gesture:)))
			addGestureRecognizer($0)
		}
		if Settings.shared.inDeveloperMode {
			let tap = UITapGestureRecognizer()
			tap.addTarget(self, action: #selector(handle(reset:)))
			twitterLetter.addGestureRecognizer(tap)
		}
	}
	
	private struct Constant {
		static let itemHeight: CGFloat = 54
	}
	
	private func layoutTwitterLetter() {
		twitterLetter.frame = CGRect(
			x: 0,
			y: round(bounds.height * 0.15),
			width: round(bounds.width * 0.5),
			height: round(bounds.height * 0.5))
		twitterLetter.center.x = center.x
	}
	
	private static func initialize(username: UITextField) {
		username.keyboardType = .emailAddress
		username.returnKeyType = .next
		username.autocorrectionType = .no
		username.autocapitalizationType = .none
		username.backgroundColor = UIColor.pictonBlue.withAlphaComponent(0.5)
		username.textColor = UIColor.white.withAlphaComponent(0.8)
		username.textAlignment = .center
		username.attributedPlaceholder = NSAttributedString(
			string: "Username",
			attributes: [NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.4)])
		username.tintColor = .white
	}
	
	private static func initialize(done: UIButton) {
		done.setTitle("Explore", for: .normal)
		done.backgroundColor = .pictonBlue
		done.setTitleColor(UIColor.white.withAlphaComponent(0.75), for: .normal)
	}
	
	private static func makeTwitterLetter() -> TwitterLetterView {
		let view = TwitterLetterView()
		view.isUserInteractionEnabled = true
		view.fillColor = UIColor.white.withAlphaComponent(0.85)
		return view
	}
}
