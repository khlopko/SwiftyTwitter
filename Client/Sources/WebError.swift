//
//  WebError.swift
//  WebLibrary
//
//  Created by Kirill Khlopko on 10/6/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Foundation

public enum WebError: Error {
    
    case responseError(reason: ResponseError)
    
    public enum ResponseError: Error {
        case emptyData
    }
    
    var localizedDescription: String {
        switch self {
        case let .responseError(reason):
            return reason.localizedDescription
        }
    }
}

public extension WebError.ResponseError {
    
    var localizedDescription: String {
        switch self {
        case .emptyData:
            return "Response data is empty or not in JSON format."
        }
    }
}
