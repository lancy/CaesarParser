//
//  JSONSerialization.swift
//  Caesar
//
//  Created by lancy on 5/17/15.
//  Copyright (c) 2015 Chenyu Lan. All rights reserved.
//

import Foundation

// MARK: - Protocol

/// convert to JSON object
public protocol Serializable {
    func toJSONObject() -> JSONObject
}

// MARK: - Serialization

struct Serialization {

    // MARK: - General Type Serialization

    static func convertAndAssign<T: Serializable>(property: T?, inout toJSONObject jsonObject: JSONObject?) -> JSONObject? {
        if let property = property {
            jsonObject = property.toJSONObject()
        }
        return jsonObject
    }

    // MARK: - Array Serialization

    static func convertAndAssign<T: Serializable>(properties: [T]?, inout toJSONObject jsonObject: JSONObject?) -> JSONObject? {
        if let properties = properties {
            jsonObject = properties.map { p in p.toJSONObject() }
        }
        return jsonObject
    }

    // MARK: - Map Serialization

    static func convertAndAssign<T, U where T: Serializable, U: CustomStringConvertible, U: Hashable>(map: [U: T]?, inout toJSONObject jsonObject: JSONObject?) -> JSONObject? {
        if let jsonMap = map {
            var json = JSONDictionary()
            for (key, value) in jsonMap {
                json[key.description] = value.toJSONObject()
            }
            jsonObject = json
        }
        return jsonObject
    }

    // MARK: - Raw Representable (Enum) Serialization

    static func convertAndAssign<T: RawRepresentable where T.RawValue: Serializable>(property: T?, inout toJSONObject value: JSONObject?) -> JSONObject? {
        if let jsonValue: JSONObject = property?.rawValue.toJSONObject() {
            value = jsonValue
        }
        return value
    }

    static func convertAndAssign<T: RawRepresentable where T.RawValue: Serializable>(properties: [T]?, inout toJSONObject jsonObject: JSONObject?) -> JSONObject? {
        if let properties = properties {
            jsonObject = properties.map { p in p.rawValue.toJSONObject() }
        }
        return jsonObject
    }

}

// MARK: - Operator for use in serialization operations.

infix operator --> { associativity right precedence 150 }

public func --> <T: Serializable>(property: T?, inout jsonObject: JSONObject?) -> JSONObject? {
    return Serialization.convertAndAssign(property, toJSONObject: &jsonObject)
}

public func --> <T: Serializable>(properties: [T]?, inout jsonObject: JSONObject?) -> JSONObject? {
    return Serialization.convertAndAssign(properties, toJSONObject: &jsonObject)
}

public func --> <T, U where T: Serializable, U: CustomStringConvertible, U: Hashable>(map: [U: T]?, inout jsonObject: JSONObject?) -> JSONObject? {
    return Serialization.convertAndAssign(map, toJSONObject: &jsonObject)
}

public func --> <T: RawRepresentable where T.RawValue: Serializable>(property: T?, inout jsonObject: JSONObject?) -> JSONObject? {
    return Serialization.convertAndAssign(property, toJSONObject: &jsonObject)
}

public func --> <T: RawRepresentable where T.RawValue: Serializable>(property: [T]?, inout jsonObject: JSONObject?) -> JSONObject? {
    return Serialization.convertAndAssign(property, toJSONObject: &jsonObject)
}
