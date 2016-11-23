//
//  Tweet.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/10/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Tools

public struct Tweet: WebEntity {
	
	public let id: String
	public let text: String
	public let user: User
	public let createdAt: Date
	
	public init(_ json: JSON) {
		user = User(parse(json["user"]))
		text = parse(json["text"])
		id = parse(json["id_str"])
		createdAt = Tools.DateFormatter.date(
			from: parse(json["created_at"]), usingFormat: .web)
	}
}
