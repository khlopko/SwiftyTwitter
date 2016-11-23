//
//  TweetView.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/12/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIComponents
import Entities
import Tools

private struct Constant {
	static let font = UIFont.systemFont(ofSize: 16)
	static let usernameFont = UIFont.systemFont(ofSize: 10)
}

final class TweetView: UIView {
	
	static func height(tweet: Tweet, width: CGFloat) -> CGFloat {
		return tweet.text.height(width: width - 20, font: Constant.font) + 32 + 16 + 10
	}
	
	private let container = TweetView.makeContainer()
	private let fullname = TweetView.makeLabel(font: Constant.font, color: .black)
	private let username = TweetView.makeLabel(font: Constant.usernameFont, color: .pictonBlueDarker)
	private let createdAt = TweetView.makeLabel(font: Constant.usernameFont, color: .darkGray)
	private let textView = TweetView.makeTextView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(container)
		let all: [UIView] = [username, fullname, createdAt, textView]
		all.forEach(container.addSubview)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var tweet: Tweet? {
		didSet {
			guard let tweet = tweet else {
				return
			}
			fullname.text = tweet.user.fullname
			username.text = "@\(tweet.user.username)"
			createdAt.text = Tools.DateFormatter.string(from: tweet.createdAt, usingFormat: .presentation)
			textView.text = tweet.text
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		container.frame = bounds
		layoutFullname()
		layoutUsername()
		layoutCreatedAt()
		layoutTextView()
	}
	
	// MARK: - Layout
	
	private func layoutFullname() {
		let width = fullname.text?.width(font: Constant.font) ?? 0
		fullname.frame = CGRect(x: 10, y: 0, width: width, height: 32)
	}
	
	private func layoutUsername() {
		let x = fullname.frame.maxX + 5
		let text = username.text ?? ""
		let font = Constant.usernameFont
		let estimatedWidth = text.width(font: font)
		let width = min(estimatedWidth, container.frame.width - 10 - x)
		username.frame = CGRect(x: x, y: 0, width: width, height: 32)
	}
	
	private func layoutCreatedAt() {
		createdAt.frame = CGRect(
			x: 10, y: fullname.frame.maxY, width: container.frame.width - 20, height: 16)
	}
	
	private func layoutTextView() {
		let y = createdAt.frame.maxY + 10
		textView.frame = CGRect(
			x: 10, y: y, width: container.frame.width - 20, height: container.frame.height - y)
	}
	
	// MARK: - Init subviews
	
	private static func makeContainer() -> UIView {
		let view = UIView()
		view.backgroundColor = UIColor.paleCornflowerBlue.withAlphaComponent(0.5)
		return view
	}
	
	private static func makeLabel(font: UIFont, color: UIColor) -> UILabel {
		let label = UILabel()
		label.font = font
		label.textColor = color
		return label
	}
	
	private static func makeTextView() -> UITextView {
		let view = UITextView()
		view.isEditable = false
		view.backgroundColor = .clear
		view.textContainerInset = .zero
		view.contentInset = .zero
		view.isScrollEnabled = false
		view.font = Constant.font
		view.textContainer.lineBreakMode = .byTruncatingTail
		view.isUserInteractionEnabled = false
		return view
	}
}
