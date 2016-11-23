//
//  TweetCell.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/11/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIComponents
import Entities

class TweetCell: UITableViewCell {
	
	static func height(with tweet: Tweet, width: CGFloat) -> CGFloat {
		return TweetView.height(tweet: tweet, width: width - 10) + 15
	}
	
	private let tweetView = TweetView()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		contentView.addSubview(tweetView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var tweet: Tweet? {
		get { return tweetView.tweet }
		set { tweetView.tweet = newValue }
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		tweetView.frame = CGRect(x: 5, y: 0, width: bounds.width - 10, height: bounds.height - 5)
	}
}
