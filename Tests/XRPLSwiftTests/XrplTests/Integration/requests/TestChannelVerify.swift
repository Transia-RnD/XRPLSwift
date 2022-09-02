//
//  TestChannelVerify.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/channelVerify.ts

import XCTest
@testable import XRPLSwift

final class TestIChannelVerify: RippledITestCase {
    
    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]
    
    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "type": "response",
            "result": [
                "signature_verified": true,
            ],
        ] as [String: AnyObject]
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
    }
    
    func testJson() async {
        // create the expectation
        let exp = expectation(description: "base")
        
        let json = [
            "command": "channel_verify",
            "channel_id": "5DB01B7FFED6B67E6B0414DED11E051D2EE2B7619CE0EAA6286D67A3A4D5BDB3",
            "signature": "304402204EF0AFB78AC23ED1C472E74F4299C0C21F1B21D07EFC0A3838A420F76D783A400220154FB11B6F54320666E4C36CA7F686C16A3A0456800BBC43746F34AF50290064",
            "public_key": "aB44YfzW24VDEJQ2UuLPV2PvqcPCSoLnL7y5M1EzhdW4LnK5xMS3",
            "amount": "1000000",
        ] as [String: AnyObject]
        let request: ChannelVerifyRequest = try! ChannelVerifyRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<ChannelVerifyResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        
        let responseJson: [String: AnyObject] = try! response.result!.toJson()
        var expectedJson: [String: AnyObject] = expected["result"] as! [String : AnyObject]
        expectedJson["signature_verified"] = responseJson["signature_verified"]
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
    
    func testModel() async {
        // create the expectation
        let exp = expectation(description: "base")
        let request: ChannelVerifyRequest = ChannelVerifyRequest(
            amount: "1000000",
            channelId: "5DB01B7FFED6B67E6B0414DED11E051D2EE2B7619CE0EAA6286D67A3A4D5BDB3",
            publicKey: "aB44YfzW24VDEJQ2UuLPV2PvqcPCSoLnL7y5M1EzhdW4LnK5xMS3",
            signature: "304402204EF0AFB78AC23ED1C472E74F4299C0C21F1B21D07EFC0A3838A420F76D783A400220154FB11B6F54320666E4C36CA7F686C16A3A0456800BBC43746F34AF50290064"
        )
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<ChannelVerifyResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        
        let responseJson: [String: AnyObject] = try! response.result!.toJson()
        var expectedJson: [String: AnyObject] = expected["result"] as! [String : AnyObject]
        expectedJson["ledger_current_index"] = responseJson["ledger_current_index"]
        expectedJson["offers"] = responseJson["offers"]
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
