//
//  Weak.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 10/14/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import Foundation

public class Weak<Value: AnyObject> {
    
    public weak var value: Value?
    
    public init(_ value: Value) {
        self.value = value
    }
}
