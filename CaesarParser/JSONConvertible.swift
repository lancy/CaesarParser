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
    public static func convert(data: JSONObject) -> Int? {
        if let int = data as? Int {
            return int
        } else if let str = data as? String, int = Int(str) {
            return int
        }
        return nil
    }
}

extension String: JSONConvertible {
    public static func convert(data: JSONObject) -> String? {
        return data as? String
    }
}

extension Double: JSONConvertible {
    public static func convert(data: JSONObject) -> Double? {
        return data as? Double
    }
}

extension Bool: JSONConvertible {
    public static func convert(data: JSONObject) -> Bool? {
        return data as? Bool
    }
}

extension Float: JSONConvertible {
    public static func convert(data: JSONObject) -> Float? {
        return data as? Float
    }
}


// MARK: - URL

extension NSURL: JSONConvertible {
    public static func convert(data: JSONObject) -> Self? {
        if let str = data as? String, url = self.init(string: str) {
            return url
        }
        return nil
    }
}

// MARK: - Date

extension NSDate: JSONConvertible {
    public static func convert(data: JSONObject) -> Self? {
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

public func DateFormatConverter(dateFormat: String) -> (JSONObject) -> NSDate? {
    return { data in
        if let dateString = data as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = dateFormat
            if let date = dateFormatter.dateFromString(dateString) {
                return date
            }
        }
        return nil
    }
}
