//
//  JSONSerializationTests.swift
//  Caesar
//
//  Created by lancy on 5/17/15.
//  Copyright (c) 2015 Chenyu Lan. All rights reserved.
//

import Foundation
import XCTest
import CaesarParser


class JSONSerializationTests: XCTestCase {
    enum Gender: Int {
        case unknown = 0
        case male = 1
        case female = 2
    }

    class Person: JSONSerializable {
        var name = ""
        var age = 0
        var birthday: Double = 0.0
        var weight: Float = 0.0
        var adult = false
        var gender = Gender.unknown
        var girlFriend: Person?
        var friends = [Person]()
        var luckyNumbers = [Int]()
        var favouredSingers = [String: Person]()
        var vips = [Int: Person]()
        var preferNumbers = [Int: Int]()
        var orientation = [Gender]()

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

        init() {}

        init(name: String) {
            self.name = name
        }
    }

    func testPrimitiveType() {
        let person = Person(name: "lancy")
        person.age = 23
        person.birthday = 14
        person.weight = 60
        person.adult = true

        if let dict = person.toJSONObject() as? JSONDictionary {
            XCTAssertEqual((dict["name"] as! String), "lancy", "my name is lancy")
            XCTAssertEqual((dict["age"] as! Int), 23, "I'm 23")
            XCTAssertEqual((dict["birthday"] as! Double), 14, "my birthday is 14")
            XCTAssertEqual((dict["weight"] as! Float), 60, "weight 60!")
            XCTAssertEqual((dict["adult"] as! Bool), true, "i'm an adult")
        } else {
            XCTFail("JSON Object should be a dictionary")
        }
        
    }

    func testEnumType() {
        let person = Person(name: "God")
        person.gender = .female
        if let dict = person.toJSONObject() as? JSONDictionary {
            XCTAssertEqual((dict["gender"] as! Int), Gender.female.rawValue, "God is a girl")
        } else {
            XCTFail("JSON Object of Person should be a dictionary")
        }
    }

    func testEnumTypeArray() {
        let person = Person(name: "siri")
        person.orientation = [.male, .female, .unknown]
        if let dict = person.toJSONObject() as? JSONDictionary {
            XCTAssertEqual((dict["name"] as! String), "siri", "my name is siri")
            if let orientation = dict["orientation"] as? [Int] {
                XCTAssertEqual(orientation[0], Gender.male.rawValue, "siri likes male!")
                XCTAssertEqual(orientation[1], Gender.female.rawValue, "siri also likes female!")
                XCTAssertEqual(orientation[2], Gender.unknown.rawValue, "and siri likes all others!")
            } else {
                XCTFail("JSON Object of orientation should be a [Int]")
            }
        } else {
            XCTFail("JSON Object of Person should be a dictionary")
        }
    }

    func testNestedType() {
        let person = Person(name: "lancy")
        let girl = Person(name: "grace")
        person.girlFriend = girl

        if let dict = person.toJSONObject() as? JSONDictionary {
            XCTAssertEqual((dict["name"] as! String), "lancy", "my name is lancy")
            if let girlDict = dict["girlFriend"] as? JSONDictionary {
                XCTAssertEqual((girlDict["name"] as! String), "grace", "my girl is grace")
            } else {
                XCTFail("JSON Object of girl friend should be a dictionary")
            }
        } else {
            XCTFail("JSON Object of Person should be a dictionary")
        }
    }

    func testObjectArray() {
        let person = Person(name: "lancy")
        let friend1 = Person(name: "grace")
        let friend2 = Person(name: "cambi")
        person.friends = [friend1, friend2]

        if let dict = person.toJSONObject() as? JSONDictionary {
            XCTAssertEqual((dict["name"] as! String), "lancy", "my name is lancy")
            if let friends = dict["friends"] as? [JSONDictionary] {
                XCTAssertEqual((friends[0]["name"] as! String), "grace", "grace is my friend")
                XCTAssertEqual((friends[1]["name"] as! String), "cambi", "cambi is my friend")
            } else {
                XCTFail("JSON Object of friends friend should be a [JSONDictionary]")
            }
        } else {
            XCTFail("JSON Object of Person should be a dictionary")
        }
    }

    func testIntArray() {
        let person = Person(name: "lancy")
        person.luckyNumbers = [8, 14, 55]

        if let dict = person.toJSONObject() as? JSONDictionary {
            XCTAssertEqual((dict["name"] as! String), "lancy", "my name is lancy")
            if let friends = dict["luckyNumbers"] as? [Int] {
                XCTAssertEqual(friends[0], 8, "lucky 8!")
                XCTAssertEqual(friends[1], 14, "lucky 14!")
                XCTAssertEqual(friends[2], 55, "lucky 55! Give me!")
            } else {
                XCTFail("JSON Object of friends friend should be a [Int]")
            }
        } else {
            XCTFail("JSON Object of Person should be a dictionary")
        }
    }

    func testStringObjectMap() {
        let person = Person(name: "lancy")
        person.favouredSingers = [
            "first": Person(name: "sia"),
            "second": Person(name: "lana")
        ]

        if let dict = person.toJSONObject() as? JSONDictionary {
            XCTAssertEqual((dict["name"] as! String), "lancy", "my name is lancy")
            if let singers = dict["favouredSingers"] as? JSONDictionary {
                XCTAssertEqual(((singers["first"] as! JSONDictionary)["name"] as! String), "sia", "sia the best!")
                XCTAssertEqual(((singers["second"] as! JSONDictionary)["name"] as! String), "lana", "lana go lana!")
            } else {
                XCTFail("JSON Object of friends friend should be a JSON dictionary")
            }
        } else {
            XCTFail("JSON Object of Person should be a dictionary")
        }
    }

    func testIntObjectMap() {
        let person = Person(name: "lancy")
        person.vips = [
            0: Person(name: "lover and family"),
            1: Person(name: "best friends"),
            2: Person(name: "maybe boss")
        ]

        if let dict = person.toJSONObject() as? JSONDictionary {
            XCTAssertEqual((dict["name"] as! String), "lancy", "my name is lancy")
            if let persons = dict["vips"] as? JSONDictionary {
                XCTAssertEqual(((persons["0"] as! JSONDictionary)["name"] as! String), "lover and family", "My love My Life! Very Importance!")
                XCTAssertEqual(((persons["1"] as! JSONDictionary)["name"] as! String), "best friends", "BFF!")
                XCTAssertEqual(((persons["2"] as! JSONDictionary)["name"] as! String), "maybe boss", "Please raise the pay...")

            } else {
                XCTFail("JSON Object of friends friend should be a JSON dictionary")
            }
        } else {
            XCTFail("JSON Object of Person should be a dictionary")
        }
    }

    func testIntIntMap() {
        let person = Person(name: "lancy")
        person.preferNumbers = [
            0: 1,
            1: 2,
            2: 4,
            3: 8,
            4: 16,
            5: 32,
            6: 64
        ]

        if let dict = person.toJSONObject() as? JSONDictionary {
            XCTAssertEqual((dict["name"] as! String), "lancy", "my name is lancy")
            if let singers = dict["preferNumbers"] as? JSONDictionary {
                XCTAssertEqual((singers["0"] as! Int), 1, "1")
                XCTAssertEqual((singers["1"] as! Int), 2, "2")
                XCTAssertEqual((singers["2"] as! Int), 4, "4")
                XCTAssertEqual((singers["3"] as! Int), 8, "8")
                XCTAssertEqual((singers["4"] as! Int), 16, "16")
                XCTAssertEqual((singers["5"] as! Int), 32, "32")
                XCTAssertEqual((singers["6"] as! Int), 64, "64")
            } else {
                XCTFail("JSON Object of friends friend should be a [JSONDictionary]")
            }
        } else {
            XCTFail("JSON Object of Person should be a dictionary")
        }

    }

}
