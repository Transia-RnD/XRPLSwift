//
//  TestRequest.swift
//
//
//  Created by Denis Angell on 7/28/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/client/request.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestRequest: XCTestCase {
    
    private var client: XrplClient!
    
    override func setUp() async throws {
        do {
            client = try XrplClient(server: ReusableValues.server)
            _ = try! await client.connect()
            print(client.url())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func testClientConstructor() async {
        let exp = expectation(description: "WSS CALL")
        let builtRequest = AccountObjectsRequest(account: MockRippled.account_objects.normal)
        let request = await self.client.request(req: builtRequest)
        request?.whenFailure({ error in
            print(error)
            XCTFail()
            exp.fulfill()
        })
        request?.whenSuccess({ result in
            guard let response = result as? BaseResponse<AccountObjectsResponse> else {
                XCTFail()
                return
            }
            XCTAssert(response.result != nil)
            assertResultMatch(response: response.result, expected: Fixtures4Testing().ACCOUNT_OBJECTS)
            exp.fulfill()
        })
        await waitForExpectations(timeout: 1)
    }
}
