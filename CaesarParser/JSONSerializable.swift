//
//  JSONSerializable.swift
//  Caesar
//
//  Created by lancy on 5/17/15.
//  Copyright (c) 2015 Chenyu Lan. All rights reserved.
//

import Foundation


extension Int: Serializable {
    public func toJSONObject() -> JSONObject {
        return self
    }
}

extension String: Serializable {
    public func toJSONObject() -> JSONObject {
        return self
    }
}

extension Double: Serializable {
    public func toJSONObject() -> JSONObject {
        return self
    }
}


extension Float: Serializable {
    public func toJSONObject() -> JSONObject {
        return self
    }
}

extension Bool: Serializable {
    public func toJSONObject() -> JSONObject {
        return self
    }
}

extension String: CustomStringConvertible {
    public var description: String {
        return self
    }
}
