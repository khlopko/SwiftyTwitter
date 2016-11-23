//
//  Settings.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/14/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Foundation

public final class Settings {
	
	public static let shared = Settings()
	
	public let inDeveloperMode = true
	
	public var token: String? {
		get { return UserDefaults.standard.string(forKey: Key.token) }
		set { UserDefaults.standard.set(newValue, forKey: Key.token) }
	}
	public var username: String? {
		get { return UserDefaults.standard.string(forKey: Key.username) }
		set { UserDefaults.standard.set(newValue, forKey: Key.username) }
	}
	
	private init() {
	}
}

private extension Settings {
	
	struct Key {
		static let token = "cachedBearerToken"
		static let username = "savedUsername"
	}
}
