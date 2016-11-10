//
//  SessionManager.swift
//  WebLibrary
//
//  Created by Kirill Khlopko on 10/6/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Foundation

public class SessionManager {
    
    static let `default` = SessionManager()
    
    let session: URLSession
    
    private static let defaultHeaders: [String: String] = {
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
            }.joined(separator: ", ")
        return [
            "Accept-Language": acceptLanguage,
        ]
    }()
    
    init(configuration: URLSessionConfiguration = .default) {
        configuration.httpAdditionalHeaders = SessionManager.defaultHeaders
        configuration.timeoutIntervalForResource = 30
        configuration.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: configuration)
    }
}
