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
// let MAX_ATTEMPTS: Int = 20
//
// public class PromiseTestCase: XCTestCase {
//
//    var timer: Timer? = nil
//    var attempts = MAX_ATTEMPTS
//
//    public func fundTest(
//        client: XrplClient,
//        address: String,
//        originalBalance: Double
//    ) async throws -> Promise<Double> {
//        let promise = Promise<Double>()
//        do {
//            var newBalance: Double = 0.0
//            do {
//                newBalance = Double(try await client.getXrpBalance(address: address))!
//            } catch {
//                /* newBalance remains undefined */
//            }
//
//            if (newBalance > originalBalance) {
//                print("CLEAR INTERVAL")
//                print("RESOLVE")
//                timer?.invalidate()
//                promise.resolve(with: newBalance)
//                return promise
//            }
//            return promise
//        } catch {
//            print("CLEAR INTERVAL")
//            print("REJECT")
//            promise.reject(with: ValidationError("Error"))
//            return promise
//            //                clearInterval(interval)
//            //                if (err instanceof Error) {
//            //                    reject(throw XRPLFaucetError("Unable to check if the address \(address) balance has increased. Error: \(err.message)"))
//            //                }
//            //                reject(err)
//        }
//    }
//
//    public func test() async throws {
//        let client = try XrplClient(server: "wss://s.altnet.rippletest.net/")
//        try await client.connect()
////        let result = await try fundTest(client: client, address: "rMPUKmzmDWEX1tQhzQ8oGFNfAEhnWNFwz", originalBalance: 0.0).observe(using: { result in
////            print(result)
////            print("HERE")
////        })
//    }
//
////    @objc func eventWith(timer: Timer!) {
////        if (attempts < 0) {
////            print("CLEAR INTERVAL")
////            timer.invalidate()
////
////            resolve(originalBalance)
////        } else {
////            attempts -= 1
////        }
////        let info = timer.userInfo as Any
////        print(info)
////    }
////
////    public func _testTimer() async throws {
////        let attempts = MAX_ATTEMPTS
////        try await setupIClient().observe(using: { result in
////            print(try! result.get())
////            print("RUNNING")
////            timer = Timer.scheduledTimer(
////                timeInterval: 5.0,
////                target: self,
////                selector: #selector(eventWith(timer:)),
////                userInfo: [ "foo" : "bar" ],
////                repeats: true
////            )
////            result.
////        })
////        print("FINISH")
////    }
// }
