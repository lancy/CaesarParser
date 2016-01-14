//
//  JSONModelTests.swift
//  Caesar
//
//  Created by lancy on 6/15/15.
//  Copyright © 2015 Chenyu Lan. All rights reserved.
//

import XCTest
import CaesarParser

class JSONModelTests: XCTestCase {

    enum Sex: Int {
        case Unknown = 0
        case Male = 1
        case Female = 2
    }

    struct PurePerson: JSONModel {
        var name = ""

        mutating func convert(inout json: Convertor) {
            name <--> json["name"]
        }
    }

    class Person: JSONModel {
        var name = ""
        var nickname: String?
        var age = 0
        var birthday: Double = 0.0
        var weight: Float = 0.0
        var adult = false
        var sex = Sex.Unknown
        var girlFriend: Person?
        var friends = [Person]()
        var luckyNumbers = [Int]()
        var favouredSingers = [String: Person]()
        var vips = [Int: Person]()
        var preferNumbers = [Int: Int]()

        required init() {}

        required init(name: String) {
            self.name = name
        }

        // Get the complie error: method 'modelFromJSONDictionary' in non-final class 'JSONModelTests.Person' must return `Self` to conform to protocol 'Deserializable'
        // Seems like protocol default implementation transform Self to concrete type when apply implementation to class
        // Copy the default implementation to here or add final keyword to work arround.

//        static func modelFromJSONDictionary(json: JSONDictionary) -> Self {
//            var convertor = Convertor(type: .Deserialization, json: json)
//            let model = self.init()
//            model.convert(&convertor)
//            return model
//        }

        func convert(inout json: Convertor) {
            name <--> json["name"]
            nickname <--> json["nickname"]
            age <--> json["age"]
            birthday <--> json["birthday"]
            weight <--> json["weight"]
            adult <--> json["adult"]
            sex <--> json["sex"]
            girlFriend <--> json["girlFriend"]
            friends <--> json["friends"]
            luckyNumbers <--> json["luckyNumbers"]
            favouredSingers <--> json["favouredSingers"]
            vips <--> json["vips"]
            preferNumbers <--> json["preferNumbers"]

        }
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testJSONModelDefaultImplementation() {
        let origin = ["name": "Grace"]
        do {
            let person = PurePerson.modelFromJSONDictionary(origin)
            let result = try person.toJSONDictionary()
            let originName = origin["name"]
            let resultName = result["name"] as! String
            XCTAssert(originName == resultName, "origin JSON should equal new JSON ")
        } catch let error {
            XCTFail("Error Catch: \(error)" )
        }
    }

    func testString() {
        let json: JSONDictionary = ["name": "Lancy"]
        let person = Person.modelFromJSONDictionary(json)
        XCTAssert(person.name == "Lancy", "My name is Lancy, not \(person.name)")

        do {
            let newJson = try person.toJSONDictionary()
            let newName = newJson["name"] as! String
            XCTAssert(newName == "Lancy", "My name is Lancy, not \(newName)")
        } catch let error {
            XCTFail("Error Catch: \(error)")
        }
    }

    func testOptionalString() {
        let json: JSONDictionary = ["nickname": "sunshine"]
        let person = Person.modelFromJSONDictionary(json)
        XCTAssert(person.nickname! == "sunshine", "nickname is sunshine, not \(person.nickname!)")

        do {
            let newJson = try person.toJSONDictionary()
            let newName = newJson["nickname"] as! String
            XCTAssert(newName == "sunshine", "nickname is sunshine, not \(newName)")
        } catch let error {
            XCTFail("Error Catch: \(error)")
        }

        let emptyJson = JSONDictionary()
        let aPerson = Person.modelFromJSONDictionary(emptyJson)
        XCTAssert(aPerson.nickname == nil, "nickname should be empty")

        do {
            let newJson = try aPerson.toJSONDictionary()
            XCTAssert(newJson["nickname"] == nil, "nickname should be empty")
        } catch let error {
            XCTFail("Error Catch: \(error)")
        }

    }


    func testPrimitiveType() {
        let person = Person()
        person.name = "lancy"
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
        let person = Person()
        person.name = "God"
        person.sex = .Female
        if let dict = person.toJSONObject() as? JSONDictionary {
            XCTAssertEqual((dict["sex"] as! Int), Sex.Female.rawValue, "God is a girl")
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

    func testSerializationPerformance() {
        let lancy = Person(name: "lancy")
        lancy.age = 23
        lancy.birthday = 14
        lancy.weight = 60
        lancy.sex = .Male
        lancy.adult = true
        lancy.luckyNumbers = [8, 14, 55]
        lancy.preferNumbers = [
            0: 1,
            1: 2,
            2: 4,
            3: 8,
            4: 16,
            5: 32,
            6: 64
        ]

        let grace = Person(name: "grace")
        grace.age = 21
        grace.sex = .Female

        let cambi = Person(name: "cambi")
        lancy.girlFriend = grace
        lancy.friends = [grace, cambi]
        
        self.measureBlock() {
            let jsonObject = lancy.toJSONObject()
            print(jsonObject)
        }
    }
    
}
