//
//  WebError.swift
//
//  Created by Kirill Khlopko on 10/6/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Entities
import Tools

public enum WebError: Error {
	
	case response(reason: ResponseErrorReason)
	case server(Server)
	
	public enum ResponseErrorReason: Error {
		case emptyData
	}
	
	var localizedDescription: String {
		switch self {
		case let .response(reason):
			return reason.localizedDescription
		case let .server(info):
			return info.text
		}
	}
	
	var server: Server? {
		switch self {
		case let .server(info):
			return info
		default:
			return nil
		}
	}
	
	init?(_ data: Any?) {
		guard let json = data as? JSON else {
			return nil
		}
		if let errors = (json["errors"] as? [AnyObject])?.first as? JSON {
			self = .server(Server(text: parse(errors["message"]), url: nil, code: errors["code"] as? Int))
		} else {
			self = .server(Server(text: parse(json["error"]), url: json["request"] as? String, code: nil))
		}
	}
}

extension WebError {
	
	public struct Server {
		public let text: String
		public let url: String?
		public let code: Int?
	}
}

extension WebError.Server {
	
	struct DefaultCode {
		static let invalidOrExpiredToken = 89
	}
}

public extension WebError.ResponseErrorReason {
	
	var localizedDescription: String {
		switch self {
		case .emptyData:
			return "Response data is empty or not in JSON format."
		}
	}
}
