//
//  Int8.swift
//  SloTheFlow
//
//  Created by Kyle Trambley on 1/7/17.
//  Copyright © 2017 Kyle Trambley. All rights reserved.
//

import Foundation

extension NSData {
    // Generic function that will take in 
    static func dataWithValue<T>(value: T) -> NSData {
        var variableValue = value
        return NSData(bytes: &variableValue, length: MemoryLayout<T>.size)
    }
    
    func int8Value() -> Int8 {
        var value: Int8 = 0
        getBytes(&value, length: MemoryLayout<Int8>.size)
        return value
    }
    
}
