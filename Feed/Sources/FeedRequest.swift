//
//  FeedRequest.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/10/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Client
import Entities
import Tools

final class FeedRequest {
	
	private let task = Task(path: ServerResource.General.timeline, mapper: FeedResponse.init)
	private var previousResponse: FeedResponse?
	
	var success: (([Tweet]) -> ())?
	var failure: ((Error) -> ())?
	
	private var isInProgress = false
	
	init(username: String) {
		task.request.method = .get
		task.request.contentType = .url
		task.request.parameters = [
			"count": "20",
			"screen_name": username,
		]
	}
	
	func next() {
		if isInProgress {
			return
		}
		isInProgress = true
		if let response = previousResponse, !response.maxID.isEmpty {
			task.request.parameters["max_id"] = response.maxID
		}
		task.execute { [weak self] result in
			self?.handleResult(result)
		}
	}
	
	private func handleResult(_ result: Result<FeedResponse>) {
		switch result {
		case let .success(response):
			previousResponse = response
			success?(response.tweets)
		case let .failure(error):
			failure?(error)
		}
		isInProgress = false
	}
}

extension FeedRequest {
	
	struct FeedResponse {
		
		let maxID: String
		let tweets: [Tweet]
		
		init(_ data: Any) {
			if let jsons = data as? [JSON] {
				tweets = jsons.map(Tweet.init)
			} else {
				tweets = []
			}
			maxID = tweets.last?.id ?? ""
		}
	}
}
