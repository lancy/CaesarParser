//
//  JSONType.swift
//  JSONHelper
//
//  Created by Chenyu Lan on 5/15/15.
//  Copyright (c) 2015 Chenyu Lan. All rights reserved.
//

import Foundation

/// A type of dictionary that only uses strings for keys and can contain any
/// type of object as a value.
public typealias JSONDictionary = [String: JSONObject]

/// A type of any object
public typealias JSONObject = AnyObject

// MARK: - Deprecated

@available(*, unavailable, renamed="JSONDeserializable")
typealias Deserializable = JSONDeserializable

@available(*, unavailable, renamed="JSONConvertible")
typealias Convertible = JSONConvertible

@available(*, unavailable, renamed="JSONSerializable")
typealias Serializable = JSONSerializable
