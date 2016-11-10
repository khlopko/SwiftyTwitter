//
//  Global.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 10/14/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Foundation

precedencegroup Specify {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator ->> : Specify

public func ->> <T>(object: T, specify: (T) -> ()) -> T {
    specify(object)
    return object
}
