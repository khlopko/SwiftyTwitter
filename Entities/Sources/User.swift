//
//  User.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/11/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Tools

public struct User: WebEntity {
	
	public let id: String
	public let fullname: String
	public let username: String
	public let tweetsCount: Int64
	public let profile: Profile
	
	public init(_ json: JSON) {
		id = parse(json["id_str"])
		fullname = parse(json["name"])
		username = parse(json["screen_name"])
		tweetsCount = parse(json["statuses_count"])
		profile = Profile(json)
	}
}

public struct Profile: WebEntity {
	
	public let backgroundColor: String
	public let backgroundImageURL: String
	public let imageURL: String
	
	public init(_ json: JSON) {
		backgroundColor = parse(json["profile_background_color"])
		backgroundImageURL = parse(json["profile_background_image_url_https"])
		imageURL = parse(json["profile_image_url_https"])
	}
}
