//
//  TestHashes.swift
//  
//
//  Created by Denis Angell on 10/15/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/utils/hashes.ts

import XCTest
@testable import XRPLSwift

final class TestHashes: XCTestCase {

    func testLedgerSpaceHex() {
        let entry = "paychan"
        let expectedEntryHex = "0078"
        let actualEntryHex = ledgerSpaceHex(entry)
        XCTAssertEqual(expectedEntryHex, actualEntryHex)
    }

    func testAddressToHex() {
        let account = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
        let expectedEntryHex = "B5F762798A53D543A014CAF8B297CFF8F2F937E8"
        let actualEntryHex = addressToHex(account)
        XCTAssertEqual(expectedEntryHex, actualEntryHex)
    }

    func testPaymentChannelEntryHash() {
        let account = "rDx69ebzbowuqztksVDmZXjizTd12BVr4x"
        let dstAccount = "rLFtVprxUEfsH54eCWKsZrEQzMDsx1wqso"
        let sequence = 82
        let expectedEntryHex = "E35708503B3C3143FB522D749AAFCC296E8060F0FB371A9A56FAE0B1ED127366"
        let actualEntryHex = hashPaymentChannel(
            account,
            dstAccount,
            sequence
        )
        XCTAssertEqual(expectedEntryHex, actualEntryHex)
    }

    func testSequenceHash() {
        let expected = "00000052"
        let sequence = 82
        let actual = String(sequence, radix: HASH_HEX).padding(leftTo: BYTE_LENGTH * 2, withPad: "0")
        XCTAssertEqual(expected, actual)
    }
}
