//
//  Feed.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/10/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Entities
import Tools

public final class Feed {
	
	public var errorHandler: ((Error) -> ())?
	public var newTweetsHandler: ((Int) -> ())?
	
	private var tweets: [Tweet] = []
	private var request: FeedRequest
	
	public var count: Int {
		return tweets.count
	}
	
	public init(username: String) {
		Settings.shared.username = username
		request = FeedRequest(username: username)
		request.success = { [weak self] new in
			self?.tweets.append(contentsOf: new)
			self?.newTweetsHandler?(new.count)
		}
		request.failure = { [weak self] error in
			self?.errorHandler?(error)
		}
	}
	
	public func removeCachedUsername() {
		Settings.shared.username = nil
	}
	
	public func tryLoadNext() {
		request.next()
	}
	
	public subscript(index: Int) -> Tweet {
		return tweets[index]
	}
}
