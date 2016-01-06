//
//  JSONBuiltInConverter.swift
//  JSONHelper
//
//  Created by Chenyu Lan on 5/15/15.
//  Copyright (c) 2015 Chenyu Lan. All rights reserved.
//

import Foundation

// MARK: - Primitive Type

extension Int: Convertible {
    public static func convert(data: JSONObject) -> Int? {
        if let int = data as? Int {
            return int
        } else if let str = data as? String, int = Int(str) {
            return int
        }
        return nil
    }
}

extension String: Convertible {
    public static func convert(data: JSONObject) -> String? {
        return data as? String ?? nil
    }
}

extension Double: Convertible {
    public static func convert(data: JSONObject) -> Double? {
        return data as? Double ?? nil
    }
}

extension Bool: Convertible {
    public static func convert(data: JSONObject) -> Bool? {
        return data as? Bool ?? nil
    }
}

extension Float: Convertible {
    public static func convert(data: JSONObject) -> Float? {
        return data as? Float ?? nil
    }
}


// MARK: - URL

extension NSURL: Convertible {
    public static func convert(data: JSONObject) -> Self? {
        if let str = data as? String, url = self.init(string: str) {
            return url
        }
        return nil
    }
}

// MARK: - Date

extension NSDate: Convertible {
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
