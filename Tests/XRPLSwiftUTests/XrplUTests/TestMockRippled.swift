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
//        self.mockRippled.suppressedOutput = true
        do {
            let request = ServerInfoRequest()
            _ = try await self.client.request(req: request)
            XCTFail()
        } catch let error as XrplError {
            XCTAssertEqual(error.message, "Not Connected")
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
