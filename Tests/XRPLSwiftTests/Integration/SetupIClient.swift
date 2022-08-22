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
        self.client = try XrplClient(server: ServerUrl.serverUrl)
        self.wallet = Wallet.generate(algorithm: .secp256k1)
        _ = try await self.client.connect()
        await fundAccount(client: self.client, wallet: self.wallet)
    }
}
