//
//  Serialization.swift
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
	
	func jsonResult(data: Data?, error: Error?, completion: (Result<Any>) -> ()) {
		let serializer = ResponseSerializer<Any> { response, data, error in
			if let error = error {
				return .failure(error)
			}
			guard let data = data else {
				return .failure(SerializationError.dataEmptyOrNil)
			}
			do {
				let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
				return .success(object)
			} catch let excpError {
				return .failure(excpError)
			}
		}
		let result = serializer.serialize(response, data, error)
		completion(result)
	}
}
