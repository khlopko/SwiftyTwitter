//
//  ContentType.swift
//
//  Created by Kirill Khlopko on 10/6/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Foundation

public enum ContentType: String {
	
	case json = "application/json"
	case url = "application/x-www-form-urlencoded"
	
	func convertParameters(_ parameters: [String: String], request: URLRequest) -> URLRequest {
		switch self {
		case .json:
			return jsonParameters(parameters, request: request)
		case .url:
			return urlEncodedParameters(parameters, request: request)
		}
	}
	
	private func jsonParameters(_ parameters: [String: String], request: URLRequest) -> URLRequest {
		var request = request
		let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
		request.httpBody = jsonData
		return request
	}
	
	private func urlEncodedParameters(_ parameters: [String: String], request: URLRequest) -> URLRequest {
		var request = request
		guard let string = parameters
			.map({ "\($0.key)=\($0.value)" })
			.joined(separator: "&")
			.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
				return request
		}
		if let url = request.url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
			components.percentEncodedQuery = string
			request.url = components.url
		}
		return request
	}
}
