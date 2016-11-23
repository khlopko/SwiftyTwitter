//
//  Request.swift
//
//  Created by Kirill Khlopko on 10/6/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Tools
import Entities

public protocol TokenProvider {
	static var token: String { get }
	static func clearCached()
}

open class DataRequest {
	
	public static var tokenProvider: TokenProvider.Type?
	
	public private(set) var task: URLSessionTask?
	public var request: URLRequest? { return task?.originalRequest }
	public var response: HTTPURLResponse? { return task?.response as? HTTPURLResponse }
	
	let session: URLSession
	open let urlString: String
	
	open var method: Method = .get
	open var contentType: ContentType = .url
	open var parameters: [String: String] = [:]
	open var headers: [String: String] = [:]
	
	public var resultClosure: ((Result<Any>) -> ())?
	
	public init(session: URLSession = SessionManager.default.session, urlString: String) {
		self.session = session
		self.urlString = urlString
	}
	
	public func resume() {
		guard let url = URL(string: urlString) else {
			fatalError("Incorrect URL string: \(urlString)")
		}
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request = contentType.convertParameters(parameters, request: request)
		headers["Content-Type"] = "\(contentType.rawValue);charset=UTF-8"
		headers["Accept-Encoding"] = "gzip"
		if let token = DataRequest.tokenProvider?.token {
			headers["Authorization"] = token
		}
		request.allHTTPHeaderFields = headers
		task = session.dataTask(with: request) { [weak self] data, response, error in
			self?.handleCompletion(data: data, error: error)
		}
		task?.resume()
	}
	
	public func cancel() {
		task?.cancel()
		task = nil
	}
	
	private func handleCompletion(data: Data?, error: Error?) {
		jsonResult(data: data, error: error) { [weak self] result in
			if let error = WebError(result.value) {
				if error.server?.code == WebError.Server.DefaultCode.invalidOrExpiredToken {
					DataRequest.tokenProvider?.clearCached()
					self?.resume()
					return
				}
				Run.inMain {
					self?.resultClosure?(.failure(error))
				}
				return
			}
			Run.inMain {
				self?.resultClosure?(result)
			}
		}
	}
}
