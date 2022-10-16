//
//  SetupIClient.swift
//
//
//  Created by Denis Angell on 8/18/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/setup.ts

import XCTest
@testable import XRPLSwift

public class RippledITestCase: XCTestCase {
    public var client: XrplClient!

    public var wallet: Wallet!

    public override func setUp() async throws {
        let exp = expectation(description: "base")
        self.wallet = Wallet.generate(.secp256k1)
        self.client = try XrplClient(server: ServerUrl.serverUrl)
        _ = try await self.client.connect().wait()
        await fundAccount(client: self.client, wallet: self.wallet)
        exp.fulfill()
        await waitForExpectations(timeout: 5)
    }

    public override func tearDown() async throws {
        //        self.client.removeAllListeners()
        _ = await self.client.disconnect()
    }
}
