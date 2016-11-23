//
//  ServerResource.swift
//
//  Created by Kirill Khlopko on 11/16/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Foundation

// MARK: - ServicePathProvider

public protocol ServicePathProvider {
	var fullURLString: String { get }
}

// MARK: - ServerResource

public struct ServerResource {
	
	private init() {
	}
	
	// MARK: - General
	
	public enum General: ServicePathProvider {
		
		case timeline
		
		public var fullURLString: String {
			return General.baseURL + suffix
		}
		
		private var suffix: String {
			switch self {
			case .timeline:
				return "statuses/user_timeline.json"
			}
		}
		
		private static let baseURL = "https://api.twitter.com/1.1/"
	}

	// MARK: - Auth
	
	public enum Auth: ServicePathProvider {
		
		case getToken
		case invalidateToken
		
		public var fullURLString: String {
			return Auth.baseURL + suffix
		}
		
		private var suffix: String {
			switch self {
			case .getToken:
				return "token"
			case .invalidateToken:
				return "invalidate_token"
			}
		}
		
		private static let baseURL = "https://api.twitter.com/oauth2/"
	}
}
