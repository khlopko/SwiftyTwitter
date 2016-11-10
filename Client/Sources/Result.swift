//
//  Result.swift
//  WebLibrary
//
//  Created by Kirill Khlopko on 10/6/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Tools

public enum Result<Data> {
    
    case success(Data)
    case failure(Error)
}

// MARK: - Map operator

precedencegroup Map {
    associativity: left
    higherThan: Specify
}

infix operator => : Map

public func => <In, Out>(result: Result<In>, closure: (In) -> (Out)) -> Result<Out> {
    switch result {
    case .success(let data):
        return Result<Out>.success(closure(data))
    case .failure(let error):
        return Result<Out>.failure(error)
    }
}
