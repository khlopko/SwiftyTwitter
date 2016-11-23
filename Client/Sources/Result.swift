//
//  Result.swift
//
//  Created by Kirill Khlopko on 10/6/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Tools

public enum Result<Data> {
	
	case success(Data)
	case failure(Error)
	
	var value: Data? {
		switch self {
		case let .success(data):
			return data
		case .failure(_):
			return nil
		}
	}
	
	var error: Error? {
		switch self {
		case .success(_):
			return nil
		case let .failure(error):
			return error
		}
	}
}

// MARK: - Map operator

precedencegroup Map {
	associativity: left
	higherThan: Specify
}

infix operator => : Map

public func => <In, Out>(result: Result<In>, closure: (In) -> (Out)) -> Result<Out> {
	switch result {
	case let .success(data):
		return .success(closure(data))
	case let .failure(error):
		return .failure(error)
	}
}

public func => <In, Out>(result: Result<In>, closure: (In) -> (Result<Out>)) -> Result<Out> {
	switch result {
	case let .success(data):
		return closure(data)
	case let .failure(error):
		return .failure(error)
	}
}
