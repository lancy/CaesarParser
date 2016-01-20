# CaesarParser

[![Build
Status](https://travis-ci.org/lancy/CaesarParser.svg?branch=master)](https://travis-ci.org/lancy/CaesarParser)

CaesarParser is a framework written in Swift for you to parse Model from JSON or to JSON.

## Features

* JSON deserialization, parse JSON to Model
* JSON serialization, parse Model to JSON
* Support nested class, stand along, in arrays or in dictionaries
* Custom converter during parsing
* Support struct, primitive type, raw representable enum

## Requirements

Cocoa Touch Framework requires iOS 8 or later.

Manual add CaesarParser to your project requires iOS 7 or later.

## Installation

###[Carthage](https://github.com/Carthage/Carthage#installing-carthage)

Add the following line to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

```
github "lancy/CaesarParser"
```

Then do `carthage update`. After that, add the framework to your project.

###[Cocoapods](https://github.com/CocoaPods/CocoaPods)

Add the following line in your `Podfile`.

```
pod "CaesarParser", :git => 'https://github.com/lancy/CaesarParser.git'
```

## Basic Usages

Any type that confirm `Deserializable` or `Convertible` protocol can be parse. Besides you can use custom value converter during parsing.

```swift
/// Use for Class, Nested Type
public protocol Deserializable {
    init(json: JSONDictionary)
}

/// Use for Primitive Type
public protocol Convertible {
    static func convert(json: JSONObject) -> Self?
}
```

Any type that confirm `Serializable` can be parse to JSON.

```swift
/// convert to JSON object
public protocol Serializable {
    func toJSONObject() -> JSONObject
}
```

**Build-in Support**

* Int
* String
* Double
* Float
* Bool
* NSURL
* NSDate (unix_timestamp to NSDate, can be custom by build-in DateFormatConverter)
* NSURL (string to URL)
* Raw representable enums which raw value confirm to `Convertible`
* Array\<Convertible or Deserializable\>
* Dictionary\<Convertible and Hashable, Convertible or Deserializable\>

**Demo Code**

```swift
enum Gender: Int {
	case Unknown = 0
	case Male = 1
	case Female = 2
}

class Person: Deserializable, Serializable {
    var name: String?
    var age: Int?
    var birthday: Double?
    var weight: Float?
    var adult: Bool = false
    var gender: Gender = .Unknown
    var girlFriend: Person?
    var friends = [Person]()
    var luckyNumbers = [Int]()
    var favouredSingers = [String: Person]()
    var vips = [Int: Person]()
    var preferNumbers = [Int: Int]()
    var orientation = [Gender]()

    init(json: JSONDictionary) {
        name <-- json["name"]
        age <-- json["age"]
        birthday <-- json["birthday"]
        weight <-- json["weight"]
        adult <-- json["adult"]
        gender <-- json["gender"]
        girlFriend <-- json["girlFriend"]
        friends <-- json["friends"]
        luckyNumbers <-- json["luckyNumbers"]
        favouredSingers <-- json["favouredSingers"]
        vips <-- json["vips"]
        preferNumbers <-- json["preferNumbers"]
        orientation <-- json["orientation"]
    }

    func toJSONObject() -> JSONObject {
        var json = JSONDictionary()

        name --> json["name"]
        age --> json["age"]
        birthday --> json["birthday"]
        weight --> json["weight"]
        adult --> json["adult"]
        gender --> json["gender"]
        girlFriend --> json["girlFriend"]
        friends --> json["friends"]
        luckyNumbers --> json["luckyNumbers"]
        favouredSingers --> json["favouredSingers"]
        vips --> json["vips"]
        preferNumbers --> json["preferNumbers"]
        orientation --> json["orientation"]

        return json
    }
}

```

## Acknowledgements
* [JSONHelper](https://github.com/isair/JSONHelper) CaesarParser is inspired by JSONHelper a lot, thanks for their great work.

## License
CaesarParser is available under the MIT license.
