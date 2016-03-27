//
//  JSONSerializable.swift
//  Caesar
//
//  Created by lancy on 5/17/15.
//  Copyright (c) 2015 Chenyu Lan. All rights reserved.
//

import Foundation


extension Int: JSONSerializable {
    public func toJSONObject() -> JSONObject {
        return self
    }
}

extension String: JSONSerializable {
    public func toJSONObject() -> JSONObject {
        return self
    }
}

extension Double: JSONSerializable {
    public func toJSONObject() -> JSONObject {
        return self
    }
}


extension Float: JSONSerializable {
    public func toJSONObject() -> JSONObject {
        return self
    }
}

extension Bool: JSONSerializable {
    public func toJSONObject() -> JSONObject {
        return self
    }
}

extension String: CustomStringConvertible {
    public var description: String {
        return self
    }
}
