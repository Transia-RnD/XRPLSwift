//
//  TestAccountID.swift
//  
//
//  Created by Denis Angell on 7/4/22.
//

import XCTest
@testable import XRPLSwift

final class TestAccountID: XCTestCase {
    
    static let HEX_ENCODING: String = "5E7B112523F68D2F5E879DB4EAC51C6698A69304"
    static let BASE58_ENCODING: String = "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59"
    
    func testFromValueHex() {
        let accountId = try! AccountID.from(value: TestAccountID.HEX_ENCODING)
        XCTAssertEqual(accountId.toJson(), TestAccountID.BASE58_ENCODING)
    }
    
    func testFromValueBase58() {
        let accountId = try! AccountID.from(value: TestAccountID.BASE58_ENCODING)
        // Note that I converted the hex to uppercase here...
        // We may want to decide if we want the implemention of `to_hex` in
        // SerializedType to return uppercase hex by default.
        XCTAssertEqual(accountId.toHex(), TestAccountID.HEX_ENCODING)
    }
//
//    func testRaisesInvalidCalueType() {
//        let invalidValue: Int = 30
//        //        self.assertRaises(XRPLBinaryCodecException, AccountID.from_value, invalid_value)
//    }
}

