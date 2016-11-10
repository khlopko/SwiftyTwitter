//
//  Request.swift
//  WebLibrary
//
//  Created by Kirill Khlopko on 10/6/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Tools
import Entities

open class DataRequest {
    
    private(set) var task: URLSessionTask?
    var request: URLRequest? { return task?.originalRequest }
    var response: HTTPURLResponse? { return task?.response as? HTTPURLResponse }

    let session: URLSession
    let urlString: String
    
    var method: Method = .get
    var contentType: ContentType = .url
    var parameters: [String: String] = [:]
    var headers: [String: String] = [:]
    
    var resultClosure: ((Result<JSON>) -> ())?
    
    init(session: URLSession = SessionManager.default.session, urlString: String) {
        self.session = session
        self.urlString = urlString
    }
    
    func resume() {
        guard let url = URL(string: urlString) else {
            fatalError("Incorrect URL string: \(urlString)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted])
        headers["Content-Type"] = contentType.rawValue
        request.allHTTPHeaderFields = headers
        task = session.dataTask(with: request) { [weak self] data, _, error in
            self?.handleCompletion(data: data, error: error)
        }
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
        task = nil
    }
    
    private func handleCompletion(data: Data?, error: Error?) {
        jsonResult(data: data, error: error) { [weak self] result in
            DispatchQueue.main.async {
                self?.resultClosure?(result)
            }
        }
    }
}
