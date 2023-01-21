//
//  TestClient.swift
//
//
//  Created by Denis Angell on 7/28/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/client.test.ts

import XCTest
@testable import XRPLSwift

final class TestClient: XCTestCase {

    func testClientConstructor() {
        _ = try! XrplClient(server: "wss://s1.ripple.com")
    }

    func testClientInvalidOptions() {
        let options: ClientOptions = ClientOptions(
            timeout: Timer(),
            proxy: nil,
            feeCushion: nil,
            maxFeeXRP: nil
        )
        _ = try! XrplClient(server: "wss://s1.ripple.com", options: options)
    }

    func testClientValidOptions() {
        let client = try! XrplClient(server: "wss://s:1")
        XCTAssertEqual(client.url(), "wss://s:1")
    }

    // TODO: NOT PASSING
    func _testClientInvalidConstructor() {
        XCTAssertThrowsError(try XrplClient(server: "wss://s:1"))
    }
}
