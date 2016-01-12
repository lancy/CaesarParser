//
//  JSONModel.swift
//  CaesarParser
//
//  Created by lancy on 1/12/16.
//  Copyright © 2016 Chenyu Lan. All rights reserved.
//

// MARK: - Protocol

/// Error when JSON serialization
public enum JSONError: ErrorType {
    case NotJSONDictionary
}

/// JSONModel that is confirm to Serializable and Deserializable
public protocol JSONModel: Serializable, Deserializable {
    init()
    mutating func convert(inout json: Convertor)
}

// MARK: - JSONModel Implementaion

/// JSONModel Defaut Implementation
public extension JSONModel {

    // MARK: - Serializable and Deserializable

    init(json: JSONDictionary) {
        var convertor = Convertor(type: .Deserialization, json: json)
        var model = Self()
        model.convert(&convertor)
        self = model
    }

    func toJSONObject() -> JSONObject {
        var convertor = Convertor(type: .Serialization, json: JSONDictionary())
        var model = self
        model.convert(&convertor)
        return convertor.json
    }

    // MARK: - Convenient Methods

    func toJSONDictionary() throws -> JSONDictionary {
        guard let jsonDictionary = toJSONObject() as? JSONDictionary else {
            throw JSONError.NotJSONDictionary
        }
        return jsonDictionary
    }

}

public struct Convertor {

    enum ConvertorType {
        case Serialization
        case Deserialization
    }

    let type: ConvertorType
    var json: JSONDictionary
    var currentKey: String?

    init(type: ConvertorType, json: JSONDictionary) {
        self.type = type
        self.json = json
    }

    public subscript(key: String) -> Convertor {
        mutating get {
            currentKey = key
            return self
        }
        set {
            currentKey = key
            json[key] = newValue.json[key]
        }
    }
}

// MARK: - Conversion

struct Conversion {

    // MARK: - Convertible

    static func convert<T where T: Convertible, T: Serializable> (inout property: T?, inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }

    static func convert<T where T: Convertible, T: Serializable> (inout property: T, inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }

    static func convert<T where T: Convertible, T: Serializable> (inout property: [T]?, inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }

    static func convert<T where T: Convertible, T: Serializable> (inout property: [T], inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }

    // MARK: - Raw Value Representable (Enum) Deserialization

    static func convert<T: RawRepresentable where T.RawValue: Convertible, T.RawValue: Serializable>(inout property: T?, inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }

    static func convert<T: RawRepresentable where T.RawValue: Convertible, T.RawValue: Serializable>(inout property: T, inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }

    // MARK: - Custom Type Deserialization

    static func convert<T where T: Deserializable, T: Serializable> (inout property: T?, inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }

    static func convert<T where T: Deserializable, T: Serializable> (inout property: T, inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }

    static func convert<T where T: Deserializable, T: Serializable> (inout property: [T]?, inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }

    static func convert<T where T: Deserializable, T: Serializable> (inout property: [T], inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }

    // MARK: - Custom Map Deserialiazation

    static func convert<T, U where T: Convertible, T: Serializable, U: Convertible, U: CustomStringConvertible, U: Hashable> (inout property: [U: T]?, inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }

    static func convert<T, U where T: Convertible, T: Serializable, U: Convertible, U: CustomStringConvertible, U: Hashable> (inout property: [U: T], inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }

    static func convert<T, U where T: Deserializable, T: Serializable, U: Convertible, U: CustomStringConvertible, U: Hashable> (inout property: [U: T]?, inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }

    static func convert<T, U where T: Deserializable, T: Serializable, U: Convertible, U: CustomStringConvertible, U: Hashable> (inout property: [U: T], inout convertor: Convertor) {
        guard let key = convertor.currentKey else { return }

        switch convertor.type {
        case .Deserialization:
            Deserialization.convertAndAssign(&property, fromJSONObject: convertor.json[key])
        case .Serialization:
            Serialization.convertAndAssign(property, toJSONObject: &convertor.json[key])
        }
    }


}

// MARK: - Operator for use in serialization operations.

infix operator <--> { associativity right precedence 150 }

// MARK: - Convertible Type

public func <--> <T where T: Convertible, T: Serializable> (inout property: T?, inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}

public func <--> <T where T: Convertible, T: Serializable> (inout property: T, inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}

public func <--> <T where T: Convertible, T: Serializable> (inout property: [T]?, inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}

public func <--> <T where T: Convertible, T: Serializable> (inout property: [T], inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}

// MARK: - Raw Value Representable (Enum) Deserialization

public func <--> <T: RawRepresentable where T.RawValue: Convertible, T.RawValue: Serializable>(inout property: T?, inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}

public func <--> <T: RawRepresentable where T.RawValue: Convertible, T.RawValue: Serializable>(inout property: T, inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}

// MARK: - Custom Type Deserialization

public func <--> <T where T: Deserializable, T: Serializable> (inout property: T?, inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}

public func <--> <T where T: Deserializable, T: Serializable> (inout property: T, inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}

public func <--> <T where T: Deserializable, T: Serializable> (inout property: [T]?, inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}

public func <--> <T where T: Deserializable, T: Serializable> (inout property: [T], inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}

// MARK: - Custom Map Deserialiazation

public func <--> <T, U where T: Convertible, T: Serializable, U: Convertible, U: CustomStringConvertible, U: Hashable> (inout property: [U: T]?, inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}

public func <--> <T, U where T: Convertible, T: Serializable, U: Convertible, U: CustomStringConvertible, U: Hashable> (inout property: [U: T], inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}

public func <--> <T, U where T: Deserializable, T: Serializable, U: Convertible, U: CustomStringConvertible, U: Hashable> (inout property: [U: T]?, inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}

public func <--> <T, U where T: Deserializable, T: Serializable, U: Convertible, U: CustomStringConvertible, U: Hashable> (inout property: [U: T], inout convertor: Convertor) {
    Conversion.convert(&property, convertor: &convertor)
}


