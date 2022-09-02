//
//  SetupIClient.swift
//
//
//  Created by Denis Angell on 8/18/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/setup.ts

import XCTest
@testable import XRPLSwift

//public func setupIClient() async throws -> Promise<Any?> {
////        self.client = try XrplClient(server: ServerUrl.serverUrl)
////        self.wallet = Wallet.generate(algorithm: .secp256k1)
////        _ = try! await self.client.connect()
////        return await fundAccount(client: self.client, wallet: self.wallet)
//    let promise = Promise<Any?>()
//    print("HERE")
//    promise.resolve(with: 10)
//    return promise
//}

//public class PromiseTest: XCTestCase {
//    public func test() async throws {
//        try await setupIClient().observe(using: { result in
//            print(try! result.get())
//        })
//        print("FINISHED")
//    }
//}

public class RippledITestCase: XCTestCase {
    public var client: XrplClient!
    
    public var wallet: Wallet!
    
    public override func setUp() async throws {
        print("Setting Up I Client")
        self.wallet = Wallet.generate(algorithm: .secp256k1)
        self.client = try XrplClient(server: ServerUrl.serverUrl)
        _ = try await self.client.connect().wait()
        await fundAccount(client: self.client, wallet: self.wallet)
    }
    
    public override func tearDown() async throws {
//        self.client.removeAllListeners()
        _ = await self.client.disconnect()
    }
}
