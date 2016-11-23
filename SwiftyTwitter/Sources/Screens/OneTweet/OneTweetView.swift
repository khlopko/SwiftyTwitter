//
//  OneTweetView.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/13/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIComponents
import Entities

class OneTweetView: UIView {
	
	let mainTweet = TweetView()
	
	var tweet: Tweet? {
		didSet {
			mainTweet.tweet = tweet
			setNeedsLayout()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		addSubview(mainTweet)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layoutMainTweet()
	}
	
	private func layoutMainTweet() {
		let height: CGFloat
		if let tweet = tweet {
			height = TweetView.height(tweet: tweet, width: bounds.width) + 10
		} else {
			height = 0
		}
		mainTweet.frame = CGRect(x: 0, y: 0, width: bounds.width, height: height)
	}
}
