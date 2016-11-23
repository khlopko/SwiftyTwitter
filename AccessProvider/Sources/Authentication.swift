//
//  Authentication.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 10/14/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Tools
import Client
import Entities

public final class Authentication: TokenProvider {
	
	private static var _tokenStore: String? {
		didSet {
			if _tokenStore != nil {
				DataRequest.tokenProvider = Authentication.self
			}
		}
	}

	public static func clearCached() {
		Settings.shared.token = nil
	}
	
	public static var token: String {
		guard let token = _tokenStore else {
			fatalError("Accessing to API without authorization!")
		}
		return "Bearer \(token)"
	}
	
	private lazy var task: Task<String> = Task(path: ServerResource.Auth.getToken, mapper: self.handleData)
	
	private let apiKey = "Kgepp6nkzipHts7Cgfwph3JWe"
	private let apiSecret = "5Hn0V3YyvuPC4dCvbZnF0WsuQNkhUE20uRVGBYw9WTmzwJZLWh"
	private lazy var base64: String? = self.bearer.data(using: .utf8)?.base64EncodedString()
	private var bearer: String {
		return "\(encode(apiKey)):\(encode(apiSecret))"
	}
	
	public init() {
		configureTask(task, parameters: ["grant_type": "client_credentials"])
	}
	
	private func configureTask(_ task: Task<String>, parameters: [String: String]) {
		task.request.method = .get
		task.request.contentType = .url
		task.request.parameters = parameters
		task.request.headers = ["Authorization": "Basic \(base64 ?? "")"]
	}
	
	public func perform(success: @escaping () -> (),
	                    failure: @escaping (Error) -> ()) {
		if let token = Settings.shared.token {
			Authentication._tokenStore = token
			success()
			return
		}
		if base64 == nil {
			failure(AppError.undefined)
			return
		}
		task.execute { result in
			switch result {
			case let .success(token):
				Settings.shared.token = token
				Authentication._tokenStore = token
				success()
			case let .failure(error):
				failure(error)
			}
		}
	}
	
	public func invalidate() {
		guard let token = Authentication._tokenStore ?? Settings.shared.token else {
			return
		}
		let task = Task(path: ServerResource.Auth.invalidateToken, mapper: handleData)
		configureTask(task, parameters: ["access_token": token])
		task.execute { result in
			switch result {
			case let .success(token):
				Settings.shared.token = token
				Authentication._tokenStore = token
			case let .failure(error):
				print(error)
			}
		}
	}
	
	private func handleData(_ data: Any) -> String {
		if let json = data as? JSON, let token = json["access_token"] as? String {
			return token
		}
		return ""
	}
	
	private func encode(_ string: String) -> String {
		return string.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
	}
}

// MARK: - Credentials

extension Authentication {
	
	public struct Credentials {
		
		public let username: String
		public let password: String
		
		public init(username: String, password: String) {
			self.username = username
			self.password = password
		}
	}
}
