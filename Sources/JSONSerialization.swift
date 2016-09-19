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
public protocol JSONSerializable {
    func toJSONObject() -> JSONObject
}

// MARK: - Serialization

struct Serialization {

    // MARK: - General Type Serialization

    static func convertAndAssign<T: JSONSerializable>(_ property: T?, toJSONObject jsonObject: inout JSONObject?) {
        if let property = property {
            jsonObject = property.toJSONObject()
        }
    }

    // MARK: - Array Serialization

    static func convertAndAssign<T: JSONSerializable>(_ properties: [T]?, toJSONObject jsonObject: inout JSONObject?) {
        if let properties = properties {
            jsonObject = properties.map { p in p.toJSONObject() }
        }
    }

    // MARK: - Map Serialization

    static func convertAndAssign<T, U>(_ map: [U: T]?, toJSONObject jsonObject: inout JSONObject?) where T: JSONSerializable, U: CustomStringConvertible, U: Hashable {
        if let jsonMap = map {
            var json = JSONDictionary()
            for (key, value) in jsonMap {
                json[key.description] = value.toJSONObject()
            }
            jsonObject = json
        }
    }

    // MARK: - Raw Representable (Enum) Serialization

    static func convertAndAssign<T: RawRepresentable>(_ property: T?, toJSONObject value: inout JSONObject?) where T.RawValue: JSONSerializable {
        if let jsonValue: JSONObject = property?.rawValue.toJSONObject() {
            value = jsonValue
        }
    }

    static func convertAndAssign<T: RawRepresentable>(_ properties: [T]?, toJSONObject jsonObject: inout JSONObject?) where T.RawValue: JSONSerializable {
        if let properties = properties {
            jsonObject = properties.map { p in p.rawValue.toJSONObject() }
        }
    }

}

// MARK: - Operator for use in serialization operations.

infix operator --> : AssignmentPrecedence

public func --> <T: JSONSerializable>(property: T?, jsonObject: inout JSONObject?) {
    Serialization.convertAndAssign(property, toJSONObject: &jsonObject)
}

public func --> <T: JSONSerializable>(properties: [T]?, jsonObject: inout JSONObject?) {
    Serialization.convertAndAssign(properties, toJSONObject: &jsonObject)
}

public func --> <T, U>(map: [U: T]?, jsonObject: inout JSONObject?) where T: JSONSerializable, U: CustomStringConvertible, U: Hashable {
    Serialization.convertAndAssign(map, toJSONObject: &jsonObject)
}

public func --> <T: RawRepresentable>(property: T?, jsonObject: inout JSONObject?) where T.RawValue: JSONSerializable {
    Serialization.convertAndAssign(property, toJSONObject: &jsonObject)
}

public func --> <T: RawRepresentable>(property: [T]?, jsonObject: inout JSONObject?) where T.RawValue: JSONSerializable {
    Serialization.convertAndAssign(property, toJSONObject: &jsonObject)
}
