//
//  Enum.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 01/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation

public protocol CanGenerateRandomValues {
    static func random() -> Self
}


public extension CanGenerateRandomValues where Self: Hashable {
    public static func random() -> Self {
        return arrayOfEnumCases(Self.self).random()
    }
}


public func arrayOfEnumCases<T: Hashable>(_ enumeration: T.Type) -> [T] {
    var array = [T]()
    for item in iterateEnum(enumeration) {
        array.append(item)
    }
    return array
}


// http://stackoverflow.com/a/28341290/471960
public func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}


