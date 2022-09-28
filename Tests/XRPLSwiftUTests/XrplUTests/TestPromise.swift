////
////  TestPromise.swift
////
////
////  Created by Denis Angell on 8/18/22.
////
//
// import XCTest
// @testable import XRPLSwift
//
// public class PromiseTestCase: XCTestCase {
//
//    public func setupIClient() async throws -> Promise<Any?> {
//    //        self.client = try XrplClient(server: ServerUrl.serverUrl)
//    //        self.wallet = Wallet.generate(algorithm: .secp256k1)
//    //        _ = try! await self.client.connect()
//    //        return await fundAccount(client: self.client, wallet: self.wallet)
//        return Promise<Any>() {
//            print("1")
//        }
//        let promise = Promise<Any?>()
//        print("2")
//        promise.resolve(with: 10)
//        return promise
//    }
//
//    public class PromiseTest: XCTestCase {
//        public func test() async throws {
//            try await setupIClient().observe(using: { result in
//                print(try! result.get())
//            })
//            print("3")
//        }
//    }
// }
