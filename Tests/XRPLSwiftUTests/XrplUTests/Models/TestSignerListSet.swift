//
//  TestSignerListSet.swift
//  
//
//  Created by Denis Angell on 8/13/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/signerListSet.ts

import XCTest
@testable import XRPLSwift

final class TestUSignerListSet: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "Flags": 0,
            "TransactionType": "SignerListSet",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Fee": "12",
            "SignerQuorum": 3,
            "SignerEntries": [
                [
                    "SignerEntry": [
                        "Account": "rsA2LpzuawewSBQXkiju3YQTMzW13pAAdW",
                        "SignerWeight": 2
                    ]
                ],
                [
                    "SignerEntry": [
                        "Account": "rUpy3eEg8rqjqfUoLeBnZkscbKbFsKXC3v",
                        "SignerWeight": 1
                    ]
                ],
                [
                    "SignerEntry": [
                        "Account": "raKEEVSGnKSD9Zyvxu4z6Pqpm4ABH8FS6n",
                        "SignerWeight": 1
                    ]
                ]
            ]
        ] as! [String: AnyObject]
    }

    func testA() {
        TestUSignerListSet.setUp()
        let tx = try! SignerListSet(json: TestUSignerListSet.baseTx)
        do {
            try validateSetRegularKey(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidSignerEntriesNil() {
        TestUSignerListSet.setUp()
        TestUSignerListSet.baseTx["SignerEntries"] = nil
        XCTAssertThrowsError(try SignerListSet(json: TestUSignerListSet.baseTx))
    }

    func testInvalidSignerEntriesEmpty() {
        TestUSignerListSet.setUp()
        TestUSignerListSet.baseTx["SignerEntries"] = [] as AnyObject
        XCTAssertThrowsError(try SignerListSet(json: TestUSignerListSet.baseTx))
    }

    func testInvalidSignerEntriesType() {
        TestUSignerListSet.setUp()
        TestUSignerListSet.baseTx["SignerEntries"] = "khgfgyhujk" as AnyObject
        XCTAssertThrowsError(try SignerListSet(json: TestUSignerListSet.baseTx))
    }
}
