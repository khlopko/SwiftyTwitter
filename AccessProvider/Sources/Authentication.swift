//
//  Authentication.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 10/14/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Foundation
import Client

public final class Authentication {
    
    private let urlString = "https://api.twitter.com/oauth2/token"
    
    private let apiKey = "Kgepp6nkzipHts7Cgfwph3JWe"
    private let apiSecret = "5Hn0V3YyvuPC4dCvbZnF0WsuQNkhUE20uRVGBYw9WTmzwJZLWh"
    private var base64: String? {
        return bearer.data(using: .utf8)?.base64EncodedString()
    }
    private var bearer: String {
        return "\(encode(apiKey)):\(encode(apiSecret))"
    }
    private var request: Request?
    
    public init() {
    }
    
    public func perform(with credentials: Credentials) {
        guard let base64 = base64 else {
            return
        }
        request = Request(urlString: urlString)
        request?.method = .post
        request?.headers = ["Authorization": "Basic \(base64)"]
        request?.parameters = ["grant_type": "client_credentials"]
        request?.resultClosure = { result in
            switch result {
            case let .success(json):
                print(json)
            case let .failure(error):
                print(error)
            }
        }
        request?.resume()
    }
    
    private func encode(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
}

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
