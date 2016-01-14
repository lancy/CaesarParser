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
public protocol Deserializable {
    static func modelFromJSONDictionary(json: JSONDictionary) -> Self
}

/// Use for Primitive Type
public protocol Convertible {
    static func convert(json: JSONObject) -> Self?
}

// MARK: - Deserialization

struct Deserialization {

    // MARK: - Utils

    /// Convert object to nil if is Null
    private static func convertToNilIfNull(object: JSONObject?) -> JSONObject? {
        return object is NSNull ? nil : object
    }

    // MARK: - Convertible Type Deserialization

    static func convertAndAssign<T: Convertible>(inout property: T?, fromJSONObject jsonObject: JSONObject?) -> T? {
        if let data: JSONObject = convertToNilIfNull(jsonObject), convertedValue = T.convert(data) {
            property = convertedValue
        } else {
            property = nil
        }
        return property
    }

    static func convertAndAssign<T: Convertible>(inout property: T, fromJSONObject jsonObject: JSONObject?) -> T {
        var newValue: T?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { property = newValue }
        return property
    }

    static func convertAndAssign<T: Convertible>(inout array: [T]?, fromJSONObject jsonObject: JSONObject?) -> [T]? {
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
        return array
    }

    static func convertAndAssign<T: Convertible>(inout array: [T], fromJSONObject jsonObject: JSONObject?) -> [T] {
        var newValue: [T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { array = newValue }
        return array
    }

    // MARK: - Custom Type Deserialization

    static func convertAndAssign<T: Deserializable>(inout instance: T?, fromJSONObject jsonObject: JSONObject?) -> T? {
        if let data = convertToNilIfNull(jsonObject) as? JSONDictionary {
            instance = T.modelFromJSONDictionary(data)
        } else {
            instance = nil
        }
        return instance
    }

    static func convertAndAssign<T: Deserializable>(inout instance: T, fromJSONObject jsonObject: JSONObject?) -> T {
        var newValue: T?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { instance = newValue }
        return instance
    }

    static func convertAndAssign<T: Deserializable>(inout array: [T]?, fromJSONObject jsonObject: JSONObject?) -> [T]? {
        if let dataArray = convertToNilIfNull(jsonObject) as? [JSONDictionary] {
            array = [T]()
            for data in dataArray {
                array!.append(T.modelFromJSONDictionary(data))
            }
        } else {
            array = nil
        }
        return array
    }

    static func convertAndAssign<T: Deserializable>(inout array: [T], fromJSONObject jsonObject: JSONObject?) -> [T] {
        var newValue: [T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newArray = newValue { array = newArray }
        return array
    }

    // MARK: - Custom Value Converter

    static func convertAndAssign<T>(inout property: T?, fromJSONObject bundle:(jsonObject: JSONObject?, converter: (JSONObject) -> T?)) -> T? {
        if let data: JSONObject = convertToNilIfNull(bundle.jsonObject), convertedValue = bundle.converter(data) {
            property = convertedValue
        }
        return property
    }

    static func convertAndAssign<T>(inout property: T, fromJSONObject bundle:(jsonObject: JSONObject?, converter: (JSONObject) -> T?)) -> T {
        var newValue: T?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: bundle)
        if let newValue = newValue { property = newValue }
        return property
    }

    // MARK: - Custom Map Deserialiazation

    static func convertAndAssign<T, U where T: Convertible, U: Convertible, U: Hashable>(inout map: [U: T]?, fromJSONObject jsonObject: JSONObject?) -> [U: T]? {
        if let dataMap = convertToNilIfNull(jsonObject) as? JSONDictionary {
            map = [U: T]()
            for (key, data) in dataMap {
                if let convertedKey = U.convert(key), convertedValue = T.convert(data) {
                    map![convertedKey] = convertedValue
                }
            }
        } else {
            map = nil
        }
        return map
    }

    static func convertAndAssign<T, U where T: Convertible, U: Convertible, U: Hashable>(inout map: [U: T], fromJSONObject jsonObject: JSONObject?) -> [U: T] {
        var newValue: [U: T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { map = newValue }
        return map
    }

    static func convertAndAssign<T, U where T: Deserializable, U: Convertible, U: Hashable>(inout map: [U: T]?, fromJSONObject jsonObject: JSONObject?) -> [U: T]? {
        if let dataMap = convertToNilIfNull(jsonObject) as? [String: JSONDictionary] {
            map = [U: T]()
            for (key, data) in dataMap {
                if let convertedKey = U.convert(key) {
                    map![convertedKey] = T.modelFromJSONDictionary(data)
                }
            }
        } else {
            map = nil
        }
        return map
    }

    static func convertAndAssign<T, U where T: Deserializable, U: Convertible, U: Hashable>(inout map: [U: T], fromJSONObject jsonObject: JSONObject?) -> [U: T] {
        var newValue: [U: T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { map = newValue }
        return map
    }

    // MARK: - Raw Value Representable (Enum) Deserialization

    static func convertAndAssign<T: RawRepresentable where T.RawValue: Convertible>(inout property: T?, fromJSONObject jsonObject: JSONObject?) -> T? {
        var newEnumValue: T?
        var newRawEnumValue: T.RawValue?
        Deserialization.convertAndAssign(&newRawEnumValue, fromJSONObject: jsonObject)
        if let unwrappedNewRawEnumValue = newRawEnumValue {
            if let enumValue = T(rawValue: unwrappedNewRawEnumValue) {
                newEnumValue = enumValue
            }
        }
        property = newEnumValue
        return property
    }

    static func convertAndAssign<T: RawRepresentable where T.RawValue: Convertible>(inout property: T, fromJSONObject jsonObject: JSONObject?) -> T {
        var newValue: T?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { property = newValue }
        return property
    }

    static func convertAndAssign<T: RawRepresentable where T.RawValue: Convertible>(inout array: [T]?, fromJSONObject jsonObject: JSONObject?) -> [T]? {
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
        return array
    }

    static func convertAndAssign<T: RawRepresentable where T.RawValue: Convertible>(inout array: [T], fromJSONObject jsonObject: JSONObject?) -> [T] {
        var newValue: [T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newArray = newValue { array = newArray }
        return array
    }

}

// MARK: - Operator for use in deserialization operations.

infix operator <-- { associativity right precedence 150 }

// MARK: - Convertible Type Deserialization

public func <-- <T: Convertible>(inout property: T?, jsonObject: JSONObject?) -> T? {
    return Deserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

public func <-- <T: Convertible>(inout property: T, jsonObject: JSONObject?) -> T {
    return Deserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

public func <-- <T: Convertible>(inout array: [T]?, jsonObject: JSONObject?) -> [T]? {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

public func <-- <T: Convertible>(inout array: [T], jsonObject: JSONObject?) -> [T] {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

// MARK: - Custom Type Deserialization

public func <-- <T: Deserializable>(inout instance: T?, jsonObject: JSONObject?) -> T? {
    return Deserialization.convertAndAssign(&instance, fromJSONObject: jsonObject)
}

public func <-- <T: Deserializable>(inout instance: T, jsonObject: JSONObject?) -> T {
    return Deserialization.convertAndAssign(&instance, fromJSONObject: jsonObject)
}

public func <-- <T: Deserializable>(inout array: [T]?, jsonObject: JSONObject?) -> [T]? {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

public func <-- <T: Deserializable>(inout array: [T], jsonObject: JSONObject?) -> [T] {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

// MARK: - Custom Value Converter

public func <-- <T>(inout property: T?, bundle:(jsonObject: JSONObject?, converter: (JSONObject) -> T?)) -> T? {
    return Deserialization.convertAndAssign(&property, fromJSONObject: bundle)
}

public func <-- <T>(inout property: T, bundle:(jsonObject: JSONObject?, converter: (JSONObject) -> T?)) -> T {
    return Deserialization.convertAndAssign(&property, fromJSONObject: bundle)
}

// MARK: - Custom Map Deserialiazation

public func <-- <T, U where T: Convertible, U: Convertible, U: Hashable>(inout map: [U: T]?, jsonObject: JSONObject?) -> [U: T]? {
    return Deserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

public func <-- <T, U where T: Convertible, U: Convertible, U: Hashable>(inout map: [U: T], jsonObject: JSONObject?) -> [U: T] {
    return Deserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

public func <-- <T, U where T: Deserializable, U: Convertible, U: Hashable>(inout map: [U: T]?, jsonObject: JSONObject?) -> [U: T]? {
    return Deserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

public func <-- <T, U where T: Deserializable, U: Convertible, U: Hashable>(inout map: [U: T], jsonObject: JSONObject?) -> [U: T] {
    return Deserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

// MARK: - Raw Value Representable (Enum) Deserialization

public func <-- <T: RawRepresentable where T.RawValue: Convertible>(inout property: T?, jsonObject: JSONObject?) -> T? {
    return Deserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

public func <-- <T: RawRepresentable where T.RawValue: Convertible>(inout property: T, jsonObject: JSONObject?) -> T {
    return Deserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

public func <-- <T: RawRepresentable where T.RawValue: Convertible>(inout array: [T]?, jsonObject: JSONObject?) -> [T]? {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

public func <-- <T: RawRepresentable where T.RawValue: Convertible>(inout array: [T], jsonObject: JSONObject?) -> [T] {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}
