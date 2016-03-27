//
//  CaesarParserTests.swift
//  CaesarParserTests
//
//  Created by lancy on 5/17/15.
//  Copyright (c) 2015 Chenyu Lan. All rights reserved.
//

import Foundation
import XCTest
import CaesarParser

class JSONDeserializationTests: XCTestCase {

    func JSONStringToJSONObject(jsonString: String) -> JSONObject? {
        let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
        return try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
    }

    let dummyResponse = [
        "string": "a",
        "int": 1,
        "int_string": "1",
        "bool": true,
        "date": "2014-09-19",
        "url": "http://github.com/",
        "stringArray": ["a", "b", "c"],
        "intArray": [1, 2, 3, 4, 5],
        "boolArray": [true, false],
        "instance": [
            "name": "b"
        ],
        "instanceArray": [
            [
                "name": "c"
            ], [
                "name": "d"
            ]
        ],
        "instanceMap": [
            "ePerson": [
                "name": "e"
            ],
            "fPerson": [
                "name": "f"
            ]
        ]
    ]

    struct Person: JSONDeserializable {
        var name = ""

        init(json: JSONDictionary) {
            name <-- json["name"]
        }

        init() {}
    }

    enum EnumTest: Int {
        case Zero = 0
        case One = 1
    }

    func testOptionalString() {
        var property: String?
        property <-- dummyResponse["string"]
        XCTAssertEqual(property!, "a", "String? property should equal 'a'")
        property <-- dummyResponse["invalidKey"]
        XCTAssertNil(property, "String? property should equal nil after invalid assignment")
    }

    func testString() {
        var property = "b"
        property <-- dummyResponse["invalidKey"]
        XCTAssertEqual(property, "b", "String property should have the default value 'b'")
        property <-- dummyResponse["string"]
        XCTAssertEqual(property, "a", "String property should equal 'a'")
    }

    func testOptionalInt() {
        var property: Int?
        property <-- dummyResponse["int"]
        XCTAssertEqual(property!, 1, "Int? property should equal 1")
        property <-- dummyResponse["invalidKey"]
        XCTAssertNil(property, "Int? property should equal nil after invalid assignment")
    }

    func testInt() {
        var property = 2
        property <-- dummyResponse["invalidKey"]
        XCTAssertEqual(property, 2, "Int property should have the default value 2")
        property <-- dummyResponse["int"]
        XCTAssertEqual(property, 1, "Int property should equal 1")
    }

    func testStringToOptionalInt() {
        var number: Int?
        number <-- dummyResponse["int_string"]
        XCTAssertEqual(number!, 1, "Strings containing numbers should successfully deserialize into optional Ints.")
    }

    func testStringToInt() {
        var number = 0
        number <-- dummyResponse["int_string"]
        XCTAssertEqual(number, 1, "Strings containing numbers should successfully deserialize into Ints.")
    }

    func testOptionalBool() {
        var property: Bool?
        property <-- dummyResponse["bool"]
        XCTAssertEqual(property!, true, "Bool? property should equal true")
        property <-- dummyResponse["invalidKey"]
        XCTAssertNil(property, "Bool? property should equal nil after invalid assignment")
    }

    func testBool() {
        var property = true
        property <-- dummyResponse["invalidKey"]
        XCTAssertEqual(property, true, "Bool property should have the default value true")
        property <-- dummyResponse["bool"]
        XCTAssertEqual(property, true, "Bool property should equal true")
    }

    func testOptionalNSDate() {
        var property: NSDate?
        property <-- (dummyResponse["date"], DateFormatConverter("yyyy-MM-dd"))
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let testDate = dateFormatter.dateFromString("2014-09-19")
        XCTAssertEqual(property!.compare(testDate!), NSComparisonResult.OrderedSame, "NSDate? property should equal 2014-09-19")
        property <-- dummyResponse["invalidKey"]
        XCTAssertNil(property, "NSDate? property should equal nil after invalid assignment")
    }

    func testNSDate() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let defaultTestDate = dateFormatter.dateFromString("2015-09-19")
        var property = defaultTestDate!
        property <-- (dummyResponse["invalidKey"], DateFormatConverter("yyyy-MM-dd"))
        XCTAssertEqual(property.compare(defaultTestDate!), NSComparisonResult.OrderedSame, "NSDate should have the default value 2015-09-19")
        property <-- (dummyResponse["date"], DateFormatConverter("yyyy-MM-dd"))
        let testDate = dateFormatter.dateFromString("2014-09-19")
        XCTAssertEqual(property.compare(testDate!), NSComparisonResult.OrderedSame, "NSDate should have the value 2015-09-19")
    }

    func testOptionalNSURL() {
        var property: NSURL?
        property <-- dummyResponse["url"]
        XCTAssertEqual(property!.host!, "github.com", "NSURL? property should equal github.com")
        property <-- dummyResponse["invalidKey"]
        XCTAssertNil(property, "NSURL? property should equal nil after invalid assignment")
    }

    func testNSURL() {
        var property = NSURL(string: "http://google.com")!
        property <-- dummyResponse["invalidKey"]
        XCTAssertEqual(property.host!, "google.com", "NSURL should have the default value google.com")
        property <-- dummyResponse["url"]
        XCTAssertEqual(property.host!, "github.com", "NSURL should have the value github.com")
    }

    func testStringArray() {
        var property = [String]()
        property <-- dummyResponse["stringArray"]
        XCTAssertEqual(property.count, 3, "[String] property should have 3 members")
    }

    func testIntArray() {
        var property = [Int]()
        property <-- dummyResponse["intArray"]
        XCTAssertEqual(property.count, 5, "[Int] property should have 5 members")
    }

    func testBoolArray() {
        var property = [Bool]()
        property <-- dummyResponse["boolArray"]
        XCTAssertEqual(property.count, 2, "[Bool] property should have 2 members")
    }

    func testInstance() {
        var instance = Person()
        instance <-- dummyResponse["instance"]
        XCTAssertEqual(instance.name, "b", "Person instance's name property should equal 'b'")
    }

    func testInstanceArray() {
        var property = [Person]()
        property <-- dummyResponse["instanceArray"]
        XCTAssertEqual(property.count, 2, "[Person] property should have 2 members")
    }

    func testInstanceMap() {
        var property = [String:Person]()
        property <-- dummyResponse["instanceMap"]
        XCTAssertEqual(property["ePerson"]!.name, "e", "member \"ePerson\" of [String:Person] property should have \"e\" for name")
    }

    func testRawValueEnum() {
        var property = EnumTest.Zero
        property <-- dummyResponse["int"]
        XCTAssertEqual(property, EnumTest.One, "EnumTest should be equal to .One")
    }

    func testRawValueEnumArray() {
        var property: [EnumTest]?
        property <-- dummyResponse["intArray"]
        XCTAssertEqual(property?.count ?? 0, 1, "[EnumTest] property should have 1 member")
    }

    func testJSONStringArrayParsing() {
        let jsonString = "[{\"name\": \"I am \"},{\"name\": \"Groot!\"}]"
        let jsonObject: JSONObject? = JSONStringToJSONObject(jsonString)
        var people = [Person]()
        var areYouGroot = ""

        people <-- jsonObject

        for person in people {
            areYouGroot += person.name
        }

        XCTAssertEqual(areYouGroot, "I am Groot!", "Groot should be Groot")
    }

    func testJSONStringMapParsing() {
        let jsonString = "{\"person one\": {\"name\": \"I am \"}, \"person two\": {\"name\": \"Groot!\"}}"
        let jsonObject: JSONObject? = JSONStringToJSONObject(jsonString)
        var people = [String:Person]()
        var areYouGroot = ""
        var keys = ""

        people <-- jsonObject

        for (personKey, person) in people {
            areYouGroot += person.name
            keys += personKey
        }

        XCTAssertEqual(keys, "person oneperson two", "keys should be correctly picked up")
        XCTAssertEqual(areYouGroot, "I am Groot!", "Groot should be Groot")
    }
    
    func testJSONIntObjectMap() {
        let jsonString = "{\"1\": {\"name\": \"Grace\"}, \"2\": {\"name\": \"Lancy\"}}"
        let jsonObject: JSONObject? = JSONStringToJSONObject(jsonString)
        var people = [Int: Person]()
        
        people <-- jsonObject
        
        XCTAssertEqual(people[1]!.name, "Grace", "people[1] should be Grace")
        XCTAssertEqual(people[2]!.name, "Lancy", "people[2] should be Lancy")
    }
    
    func testJSONIntIntMap() {
        let jsonString = "{\"1\": 1, \"2\": 2}"
        let jsonObject: JSONObject? = JSONStringToJSONObject(jsonString)
        var dict = [Int: Int]()
        
        dict <-- jsonObject
        
        XCTAssertEqual(dict[1]!, 1, "dict[1] should be 1")
        XCTAssertEqual(dict[2]!, 2, "dict[2] should be 2")
    }
    
}