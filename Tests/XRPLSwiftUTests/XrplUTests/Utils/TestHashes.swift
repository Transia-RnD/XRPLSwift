//
//  TestHashes.swift
//  
//
//  Created by Denis Angell on 10/15/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/utils/hashes.test.test.ts

import XCTest
@testable import XRPLSwift

final class TestHashes: XCTestCase {

    func testHashAccountRoot() throws {
        let account = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
        let expectedEntryHash = "2B6AC232AA4C4BE41BF49D2459FA4A0347E1B543A4C92FCEE0821C0201E2E9A8"
        let actualEntryHash = try hashAccountRoot(account)

        XCTAssertEqual(actualEntryHash, expectedEntryHash)
    }

    func testHashTrustline() throws {
        let account1 = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
        let account2 = "rB5TihdPbKgMrkFqrqUC3yLdE8hhv4BdeY"
        let currency = "USD"

        let expectedEntryHash = "C683B5BB928F025F1E860D9D69D6C554C2202DE0D45877ADB3077DA4CB9E125C"
        let actualEntryHash1 = try hashTrustline(account1, account2, currency)
        let actualEntryHash2 = try hashTrustline(account2, account1, currency)

        XCTAssertEqual(actualEntryHash1, expectedEntryHash)
        XCTAssertEqual(actualEntryHash2, expectedEntryHash)
    }

    func testHashTrustline2() throws {
        let account1 = "r3kmLJN5D28dHuH8vZNUZpMC43pEHpaocV"
        let account2 = "rUAMuQTfVhbfqUDuro7zzy4jj4Wq57MPTj"
        let currency = "UAM"

        let expectedEntryHash = "AE9ADDC584358E5847ADFC971834E471436FC3E9DE6EA1773DF49F419DC0F65E"
        let actualEntryHash1 = try hashTrustline(account1, account2, currency)
        let actualEntryHash2 = try hashTrustline(account2, account1, currency)

        XCTAssertEqual(actualEntryHash1, expectedEntryHash)
        XCTAssertEqual(actualEntryHash2, expectedEntryHash)
    }

    func testHashOfferId() throws {
        let account = "r32UufnaCGL82HubijgJGDmdE5hac7ZvLw"
        let sequence = 137
        let expectedEntryHash = "03F0AED09DEEE74CEF85CD57A0429D6113507CF759C597BABB4ADB752F734CE3"
        let actualEntryHash = try hashOfferId(account, sequence)

        XCTAssertEqual(actualEntryHash, expectedEntryHash)
    }

    func testHashSignerListId() throws {
        let account = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
        let expectedEntryHash = "778365D5180F5DF3016817D1F318527AD7410D83F8636CF48C43E8AF72AB49BF"
        let actualEntryHash = try hashSignerListId(account)
        XCTAssertEqual(actualEntryHash, expectedEntryHash)
    }

    func testHashEscrow() throws {
        let account = "rDx69ebzbowuqztksVDmZXjizTd12BVr4x"
        let sequence = 84
        let expectedEntryHash = "61E8E8ED53FA2CEBE192B23897071E9A75217BF5A410E9CB5B45AAB7AECA567A"
        let actualEntryHash = try hashEscrow(account, sequence)

        XCTAssertEqual(actualEntryHash, expectedEntryHash)
    }

    func testHashPaymentChannel() throws {
        let account = "rDx69ebzbowuqztksVDmZXjizTd12BVr4x"
        let dstAccount = "rLFtVprxUEfsH54eCWKsZrEQzMDsx1wqso"
        let sequence = 82
        let expectedEntryHash = "E35708503B3C3143FB522D749AAFCC296E8060F0FB371A9A56FAE0B1ED127366"
        let actualEntryHash = try hashPaymentChannel(account, dstAccount, sequence)

        XCTAssertEqual(actualEntryHash, expectedEntryHash)
    }

    func testHashSignedTx() throws {
        let expected_hash = "458101D51051230B1D56E9ACAFAA34451BF65FA000F95DF6F0FF5B3A62D83FC2"

        let tx = try Transaction.init(RippledTxFixtures.offerCreateSellTx())!
        XCTAssertEqual(try HashLedger.hashSignedTx(tx), expected_hash)
    }

    func testHashSignedTxBlob() throws {
        let expected_hash = "458101D51051230B1D56E9ACAFAA34451BF65FA000F95DF6F0FF5B3A62D83FC2"

        let encoded: String = try BinaryCodec.encode(RippledTxFixtures.offerCreateSellTx())
        XCTAssertEqual(try HashLedger.hashSignedTx(encoded), expected_hash)
    }

    func testHashSignedTxUnsigned() throws {
        var txJson: [String: AnyObject] = RippledTxFixtures.offerCreateSellTx()
        txJson["TxnSignature"] = nil
        let txNoSignature = try Transaction.init(txJson)!
        XCTAssertThrowsError(try HashLedger.hashSignedTx(txNoSignature))
    }

    func testHashSignedTxBlobUnsigned() throws {
        var txJson: [String: AnyObject] = RippledTxFixtures.offerCreateSellTx()
        txJson["TxnSignature"] = nil
        let encoded: String = try BinaryCodec.encode(txJson)
        XCTAssertThrowsError(try HashLedger.hashSignedTx(encoded))
    }

    func testAddressToHex() throws {
        let account = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
        let expectedEntryHex = "B5F762798A53D543A014CAF8B297CFF8F2F937E8"
        let actualEntryHex = try addressToHex(account)
        XCTAssertEqual(expectedEntryHex, actualEntryHex)
    }

    func testLedgerSpaceHex() throws {
        let entry = "rippleState"
        let expectedEntryHex = "0072"
        let actualEntryHex = try ledgerSpaceHex(entry)
        XCTAssertEqual(expectedEntryHex, actualEntryHex)
    }

    func testCurrencyToHex() throws {
        let expected = "0000000000000000000000005553440000000000"
        let currency = "USD"
        let actualCurrencyHex = try currencyToHex(currency)
        XCTAssertEqual(expected, actualCurrencyHex)
    }

    func testSequenceHash() throws {
        let expected = "00000052"
        let sequence = 82
        let actual = String(sequence, radix: HASH_HEX).padding(leftTo: BYTE_LENGTH * 2, withPad: "0")
        XCTAssertEqual(expected, actual)
    }
}
