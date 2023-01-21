//
//  TestIsValidAddress.swift
//  
//
//  Created by Denis Angell on 10/15/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/utils/isValidAddress.test.ts

import XCTest
@testable import XRPLSwift

final class XRPLKitTests: XCTestCase {
    func testIsValidAddress() {
        XCTAssertTrue(XrplCodec.isValidClassicAddress("r3rhWeE31Jt5sWmi4QiGLMZnY3ENgqw96W"))
        XCTAssertFalse(XrplCodec.isValidClassicAddress("r3rhWeE31Jt5sWmi4QiGLMZnY3ENhqw96W"))
        XCTAssertTrue(AddressCodec.isValidXAddress("XV5sbjUmgPpvXv4ixFWZ5ptAYZ6PD28Sq49uo34VyjnmK5H"))
        XCTAssertFalse(AddressCodec.isValidXAddress("XV5sbjUmgPpvXv4ixFWZ5pfAYZ6PD28Sq49uo34VyjnmK5H"))
    }
}
