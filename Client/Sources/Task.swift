//
//  RequestCommand.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/16/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Foundation

open class Task<Value> {
	
	public let request: DataRequest
	
	public typealias Mapper = (Any) -> Value
	private let mapper: Mapper
	
	public init(path: ServicePathProvider, mapper: @escaping Mapper) {
		request = DataRequest(urlString: path.fullURLString)
		self.mapper = mapper
	}
	
	open func execute(_ completion: @escaping (Result<Value>) -> ()) {
		request.resultClosure = { [weak self] data in
			guard let sSelf = self else {
				return
			}
			let value = data => sSelf.mapper
			completion(value)
		}
		request.resume()
	}
}
