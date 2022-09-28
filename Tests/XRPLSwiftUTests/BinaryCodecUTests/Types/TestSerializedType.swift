//
//  TestSerializedType.swift
//
//
//  Created by Denis Angell on 9/14/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/types/test_serialized_type.py

import XCTest
@testable import XRPLSwift

let valueTests: [ValueTest] = DataDrivenFixtures().getValueTests()

func dataDrivenFixturesForType(typeString: String) -> [ValueTest] {
    // Return a list of ValueTest objects for the specified type.
    var testArray: [ValueTest] = []
    for vt in valueTests {
        if vt.type == typeString {
            testArray.append(vt)
        }
    }
    return testArray
}

final class TestSerializedType: XCTestCase {
    static func fixtureTest(fixture: ValueTest) {
        // Run the appropriate test for given fixture case.
        var jsonValue: Any = ""
        if !fixture.testJson.isEmpty {
            jsonValue = fixture.testJson
        } else {
            jsonValue = fixture.testString
        }
        switch fixture.type {
        case "AccountID":
            XCTAssertEqual(try AccountID.from(value: jsonValue as! String).bytes.toHex, fixture.expectedHex)
        case "Amount":
            if jsonValue is [String: AnyObject] {
                if !fixture.error.isEmpty {
                    XCTAssertThrowsError(try xAmount.from(value: jsonValue as! [String: String]))
                    return
                }
                XCTAssertEqual(try xAmount.from(value: jsonValue as! [String: String]).bytes.toHex, fixture.expectedHex)
            }
            if jsonValue is String {
                if !fixture.error.isEmpty {
                    XCTAssertThrowsError(try xAmount.from(value: jsonValue as! String))
                    return
                }
                XCTAssertEqual(try xAmount.from(value: jsonValue as! String).bytes.toHex, fixture.expectedHex)
            }
        case "Blob":
            XCTAssertEqual(try Blob.from(value: jsonValue as! String).bytes.toHex, fixture.expectedHex)
        case "Currency":
            XCTAssertEqual(try xCurrency.from(value: jsonValue as! String).bytes.toHex, fixture.expectedHex)
        default:
            XCTFail()
        }
    }
}
