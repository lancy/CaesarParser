//
//  JSONOperator.swift
//  JSONHelper
//
//  Created by Chenyu Lan on 5/15/15.
//  Copyright (c) 2015 Chenyu Lan. All rights reserved.
//

import Foundation

// MARK: - Protocol

/// Use for Class, Nested Type
public protocol JSONDeserializable {
    init(json: JSONDictionary)
}

/// Use for Primitive Type
public protocol JSONConvertible {
    static func convert(_ json: JSONObject) -> Self?
}

// MARK: - Deserialization

struct Deserialization {

    // MARK: - Utils

    /// Convert object to nil if is Null
    fileprivate static func convertToNilIfNull(_ object: JSONObject?) -> JSONObject? {
        return object is NSNull ? nil : object
    }

    // MARK: - JSONConvertible Type Deserialization

    static func convertAndAssign<T: JSONConvertible>(_ property: inout T?, fromJSONObject jsonObject: JSONObject?) {
        if let data: JSONObject = convertToNilIfNull(jsonObject), let convertedValue = T.convert(data) {
            property = convertedValue
        } else {
            property = nil
        }
    }

    static func convertAndAssign<T: JSONConvertible>(_ property: inout T, fromJSONObject jsonObject: JSONObject?) {
        var newValue: T?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { property = newValue }
    }

    static func convertAndAssign<T: JSONConvertible>(_ array: inout [T]?, fromJSONObject jsonObject: JSONObject?) {
        if let dataArray = convertToNilIfNull(jsonObject) as? [JSONObject] {
            array = [T]()
            for data in dataArray {
                if let property = T.convert(data) {
                    array!.append(property)
                }
            }
        } else {
            array = nil
        }
    }

    static func convertAndAssign<T: JSONConvertible>(_ array: inout [T], fromJSONObject jsonObject: JSONObject?) {
        var newValue: [T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { array = newValue }
    }

    // MARK: - Custom Type Deserialization

    static func convertAndAssign<T: JSONDeserializable>(_ instance: inout T?, fromJSONObject jsonObject: JSONObject?) {
        if let data = convertToNilIfNull(jsonObject) as? JSONDictionary {
            instance = T(json: data)
        } else {
            instance = nil
        }
    }

    static func convertAndAssign<T: JSONDeserializable>(_ instance: inout T, fromJSONObject jsonObject: JSONObject?) {
        var newValue: T?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { instance = newValue }
    }

    static func convertAndAssign<T: JSONDeserializable>(_ array: inout [T]?, fromJSONObject jsonObject: JSONObject?) {
        if let dataArray = convertToNilIfNull(jsonObject) as? [JSONDictionary] {
            array = [T]()
            for data in dataArray {
                array!.append(T(json: data))
            }
        } else {
            array = nil
        }
    }

    static func convertAndAssign<T: JSONDeserializable>(_ array: inout [T], fromJSONObject jsonObject: JSONObject?) {
        var newValue: [T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newArray = newValue { array = newArray }
    }

    // MARK: - Custom Map Deserialiazation

    static func convertAndAssign<T, U>(_ map: inout [U: T]?, fromJSONObject jsonObject: JSONObject?) where T: JSONConvertible, U: JSONConvertible, U: Hashable {
        if let dataMap = convertToNilIfNull(jsonObject) as? JSONDictionary {
            map = [U: T]()
            for (key, data) in dataMap {
                if let convertedKey = U.convert(key), let convertedValue = T.convert(data) {
                    map![convertedKey] = convertedValue
                }
            }
        } else {
            map = nil
        }
    }

    static func convertAndAssign<T, U>(_ map: inout [U: T], fromJSONObject jsonObject: JSONObject?) where T: JSONConvertible, U: JSONConvertible, U: Hashable {
        var newValue: [U: T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { map = newValue }
    }

    static func convertAndAssign<T, U>(_ map: inout [U: T]?, fromJSONObject jsonObject: JSONObject?) where T: JSONDeserializable, U: JSONConvertible, U: Hashable {
        if let dataMap = convertToNilIfNull(jsonObject) as? [String: JSONDictionary] {
            map = [U: T]()
            for (key, data) in dataMap {
                if let convertedKey = U.convert(key) {
                    map![convertedKey] = T(json: data)
                }
            }
        } else {
            map = nil
        }
    }

    static func convertAndAssign<T, U>(_ map: inout [U: T], fromJSONObject jsonObject: JSONObject?) where T: JSONDeserializable, U: JSONConvertible, U: Hashable {
        var newValue: [U: T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { map = newValue }
    }

    // MARK: - Raw Value Representable (Enum) Deserialization

    static func convertAndAssign<T: RawRepresentable>(_ property: inout T?, fromJSONObject jsonObject: JSONObject?) where T.RawValue: JSONConvertible  {
        var newEnumValue: T?
        var newRawEnumValue: T.RawValue?
        Deserialization.convertAndAssign(&newRawEnumValue, fromJSONObject: jsonObject)
        if let unwrappedNewRawEnumValue = newRawEnumValue {
            if let enumValue = T(rawValue: unwrappedNewRawEnumValue) {
                newEnumValue = enumValue
            }
        }
        property = newEnumValue
    }

    static func convertAndAssign<T: RawRepresentable>(_ property: inout T, fromJSONObject jsonObject: JSONObject?) where T.RawValue: JSONConvertible {
        var newValue: T?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { property = newValue }
    }

    static func convertAndAssign<T: RawRepresentable>(_ array: inout [T]?, fromJSONObject jsonObject: JSONObject?) where T.RawValue: JSONConvertible {
        if let dataArray = convertToNilIfNull(jsonObject) as? [JSONObject] {
            array = [T]()
            for data in dataArray {
                var newValue: T?
                Deserialization.convertAndAssign(&newValue, fromJSONObject: data)
                if let newValue = newValue { array!.append(newValue) }
            }
        } else {
            array = nil
        }
    }

    static func convertAndAssign<T: RawRepresentable>(_ array: inout [T], fromJSONObject jsonObject: JSONObject?) where T.RawValue: JSONConvertible {
        var newValue: [T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newArray = newValue { array = newArray }
    }

}

// MARK: - Operator for use in deserialization operations.

infix operator <-- : AssignmentPrecedence

// MARK: - JSONConvertible Type Deserialization

public func <-- <T: JSONConvertible>(property: inout T?, jsonObject: JSONObject?) {
    Deserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

public func <-- <T: JSONConvertible>(property: inout T, jsonObject: JSONObject?) {
    Deserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

public func <-- <T: JSONConvertible>(array: inout [T]?, jsonObject: JSONObject?) {
    Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

public func <-- <T: JSONConvertible>(array: inout [T], jsonObject: JSONObject?) {
    Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

// MARK: - Custom Type Deserialization

public func <-- <T: JSONDeserializable>(instance: inout T?, jsonObject: JSONObject?) {
    Deserialization.convertAndAssign(&instance, fromJSONObject: jsonObject)
}

public func <-- <T: JSONDeserializable>(instance: inout T, jsonObject: JSONObject?) {
    Deserialization.convertAndAssign(&instance, fromJSONObject: jsonObject)
}

public func <-- <T: JSONDeserializable>(array: inout [T]?, jsonObject: JSONObject?) {
    Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

public func <-- <T: JSONDeserializable>(array: inout [T], jsonObject: JSONObject?) {
    Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

// MARK: - Custom Map Deserialiazation

public func <-- <T, U>(map: inout [U: T]?, jsonObject: JSONObject?) where T: JSONConvertible, U: JSONConvertible, U: Hashable {
    Deserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

public func <-- <T, U>(map: inout [U: T], jsonObject: JSONObject?) where T: JSONConvertible, U: JSONConvertible, U: Hashable {
    return Deserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

public func <-- <T, U>(map: inout [U: T]?, jsonObject: JSONObject?) where T: JSONDeserializable, U: JSONConvertible, U: Hashable {
    return Deserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

public func <-- <T, U>(map: inout [U: T], jsonObject: JSONObject?) where T: JSONDeserializable, U: JSONConvertible, U: Hashable {
    return Deserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

// MARK: - Raw Value Representable (Enum) Deserialization

public func <-- <T: RawRepresentable>(property: inout T?, jsonObject: JSONObject?) where T.RawValue: JSONConvertible {
    return Deserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

public func <-- <T: RawRepresentable>(property: inout T, jsonObject: JSONObject?) where T.RawValue: JSONConvertible {
    return Deserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

public func <-- <T: RawRepresentable>(array: inout [T]?, jsonObject: JSONObject?) where T.RawValue: JSONConvertible {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

public func <-- <T: RawRepresentable>(array: inout [T], jsonObject: JSONObject?) where T.RawValue: JSONConvertible {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}
