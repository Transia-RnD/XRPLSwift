//
//  SetupClient.swift
//
//
//  Created by Denis Angell on 8/18/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/setupClient.ts

import XCTest
@testable import XRPLSwift

public class RippledMockTester: XCTestCase {
    internal var mockRippled: MockRippledSocket!
    public var _mockedServerPort: Int = 0
    public var client: XrplClient!

    public var wallet: Wallet!

    public override func setUp() async throws {
        let exp = expectation(description: "base")
        self.mockRippled = MockRippledSocket(port: 9999)
        try! self.mockRippled.start()
        self._mockedServerPort = 9999
        self.client = try! XrplClient(server: "ws://localhost:\(9999)")
        _ = try await self.client.connect().wait()
        exp.fulfill()
        await waitForExpectations(timeout: 5)
    }
}

struct MockAO {
    public var normal: String = "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn"
}

final class MockRippled1: XCTestCase {
    public static let account_objects: MockAO = MockAO()

}
