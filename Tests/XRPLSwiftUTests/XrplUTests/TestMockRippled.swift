//
//  TestMockRippled.swift
//  
//
//  Created by Denis Angell on 9/18/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/mockRippledTest.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestMockRippled: RippledMockTester {

    override func setUp() async throws {
        try await super.setUp()
    }

    func testMockNotProvided() async {
        do {
            let request = ServerInfoRequest()
            self.mockRippled.suppressOutput = true
            _ = try await self.client.request(req: request)?.wait()
            XCTFail()
        } catch let error as XrplError {
            XCTAssert(error is XrplError)
        } catch {
            XCTFail()
        }
    }

    func testMockBadResponse() async {
        do {
            try self.mockRippled.addResponse(command: "account_info", response: [ "data": [:] ] as [String: AnyObject])
            XCTFail()
        } catch {
            print(error.localizedDescription)
        }
    }
}
