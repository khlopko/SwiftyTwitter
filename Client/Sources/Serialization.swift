//
//  Serialization.swift
//  Schedulee
//
//  Created by Kirill Khlopko on 9/22/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Tools
import Entities

enum SerializationError: Error {
    case dataEmptyOrNil
    case undefined
}

protocol ResponseSerializerProtocol {
    associatedtype Serialized
    var serialize: (HTTPURLResponse?, Data?, Error?) -> (Result<Serialized>) { get }
}

struct ResponseSerializer<Value>: ResponseSerializerProtocol {
    
    typealias Serialized = Value
    
    var serialize: (HTTPURLResponse?, Data?, Error?) -> (Result<Value>)
    
    init(_ serialize: @escaping (HTTPURLResponse?, Data?, Error?) -> (Result<Value>)) {
        self.serialize = serialize
    }
}

extension DataRequest {
    
    func jsonResult(data: Data?, error: Error?, completion: (Result<JSON>) -> ()) {
        let serializer = ResponseSerializer<JSON> { response, data, error in
            if let error = error {
                return Result.failure(error)
            }
            guard let data = data else { return Result.failure(SerializationError.dataEmptyOrNil) }
            do {
                let object = try JSONSerialization
                    .jsonObject(with: data, options: [.mutableContainers, .allowFragments])
                if let json = object as? JSON {
                    return Result.success(json)
                } else {
                    return Result.failure(SerializationError.dataEmptyOrNil)
                }
            } catch let excpError {
                return Result.failure(excpError)
            }
        }
        let result = serializer.serialize(response, data, error)
        completion(result)
    }
}
