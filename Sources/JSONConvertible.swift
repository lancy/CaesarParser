//
//  JSONBuiltInConverter.swift
//  JSONHelper
//
//  Created by Chenyu Lan on 5/15/15.
//  Copyright (c) 2015 Chenyu Lan. All rights reserved.
//

import Foundation

// MARK: - Primitive Type

extension Int: JSONConvertible {
    public static func convert(_ data: JSONObject) -> Int? {
        if let int = data as? Int {
            return int
        } else if let str = data as? String, let int = Int(str) {
            return int
        }
        return nil
    }
}

extension String: JSONConvertible {
    public static func convert(_ data: JSONObject) -> String? {
        return data as? String
    }
}

extension Double: JSONConvertible {
    public static func convert(_ data: JSONObject) -> Double? {
        return data as? Double
    }
}

extension Bool: JSONConvertible {
    public static func convert(_ data: JSONObject) -> Bool? {
        return data as? Bool
    }
}

extension Float: JSONConvertible {
    public static func convert(_ data: JSONObject) -> Float? {
        return data as? Float
    }
}


// MARK: - URL

extension URL: JSONConvertible {
    public static func convert(_ data: JSONObject) -> URL? {
        if let str = data as? String, let url = self.init(string: str) {
            return url
        }
        return nil
    }
}


