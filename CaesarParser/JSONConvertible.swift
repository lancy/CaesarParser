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

// MARK: - Date

extension Date: JSONConvertible {
    public static func convert(_ data: JSONObject) -> Date? {
        if let timestamp = data as? Int {
            return self.init(timeIntervalSince1970: Double(timestamp))
        } else if let timestamp = data as? Double {
            return self.init(timeIntervalSince1970: timestamp)
        } else if let timestamp = data as? NSNumber {
            return self.init(timeIntervalSince1970: timestamp.doubleValue)
        }
        return nil
    }
}

public func DateFormatConverter(_ dateFormat: String) -> (JSONObject) -> Date? {
    return { data in
        if let dateString = data as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }
}
