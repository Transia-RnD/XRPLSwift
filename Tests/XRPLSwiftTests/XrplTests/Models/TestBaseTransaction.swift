//
//  TestBaseTransaction.swift
//  
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/baseTransaction.ts

import XCTest
@testable import XRPLSwift

final class TestUBaseTransaction: XCTestCase {

    func testA() {
        do {
            let baseTx = [
                "Account": "r97KeayHuEsDwyU1yPBVtMLLoQr79QcRFe",
                "TransactionType": "Payment",
                "Fee": "12",
                "Sequence": 100,
                "AccountTxnID": "DEADBEEF",
                "Flags": 15,
                "LastLedgerSequence": 1383,
                "Memos": [
                    [
                        "Memo": [
                            "MemoType":
                                "687474703a2f2f6578616d706c652e636f6d2f6d656d6f2f67656e65726963",
                            "MemoData": "72656e74"
                        ]
                    ],
                    [
                        "Memo": [
                            "MemoFormat":
                                "687474703a2f2f6578616d706c652e636f6d2f6d656d6f2f67656e65726963",
                            "MemoData": "72656e74"
                        ]
                    ],
                    [
                        "Memo": [
                            "MemoType": "72656e74"
                        ]
                    ]
                ],
                "Signers": [
                    [
                        "Signer": [
                            "Account": "r....",
                            "TxnSignature": "DEADBEEF",
                            "SigningPubKey": "hex-string"
                        ]
                    ]
                ],
                "SourceTag": 31,
                "SigningPublicKey":
                    "03680DD274EE55594F7244F489CD38CF3A5A1A4657122FB8143E185B2BA043DF36",
                "TicketSequence": 10,
                "TxnSignature":
                    "3045022100C6708538AE5A697895937C758E99A595B57A16393F370F11B8D4C032E80B532002207776A8E85BB9FAF460A92113B9C60F170CD964196B1F084E0DAB65BAEC368B66"
            ] as! [String: AnyObject]
            print(baseTx)
            try validateBaseTransaction(common: baseTx)
        } catch {
            XCTAssertNil(error)
        }
    }

    func testOnlyRequired() {
        let txJson = [
            "Account": "r97KeayHuEsDwyU1yPBVtMLLoQr79QcRFe",
            "TransactionType": "Payment"
        ] as! [String: AnyObject]
        try! validateBaseTransaction(common: txJson)
    }

    func testInvalidFee() {
        let txJson = [
            "Account": "r97KeayHuEsDwyU1yPBVtMLLoQr79QcRFe",
            "TransactionType": "Payment",
            "Fee": 1000
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try validateBaseTransaction(common: txJson))
    }

    func testInvalidSequence() {
        let txJson = [
            "Account": "r97KeayHuEsDwyU1yPBVtMLLoQr79QcRFe",
            "TransactionType": "Payment",
            "Sequence": "145"
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try validateBaseTransaction(common: txJson))
    }

    func testInvalidAccountTxnID() {
        let txJson = [
            "Account": "r97KeayHuEsDwyU1yPBVtMLLoQr79QcRFe",
            "TransactionType": "Payment",
            "AccountTxnID": ["WRONG"]
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try validateBaseTransaction(common: txJson))
    }

    func testInvalidLastLedgerSequence() {
        let txJson = [
            "Account": "r97KeayHuEsDwyU1yPBVtMLLoQr79QcRFe",
            "TransactionType": "Payment",
            "LastLedgerSequence": "1000"
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try validateBaseTransaction(common: txJson))
    }

    func testInvalidSourceTag() {
        let txJson = [
            "Account": "r97KeayHuEsDwyU1yPBVtMLLoQr79QcRFe",
            "TransactionType": "Payment",
            "SourceTag": ["ARRAY"]
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try validateBaseTransaction(common: txJson))
    }

    func testInvalidSigningPubKey() {
        let txJson = [
            "Account": "r97KeayHuEsDwyU1yPBVtMLLoQr79QcRFe",
            "TransactionType": "Payment",
            "SigningPubKey": 1000
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try validateBaseTransaction(common: txJson))
    }

    func testInvalidTicketSequence() {
        let txJson = [
            "Account": "r97KeayHuEsDwyU1yPBVtMLLoQr79QcRFe",
            "TransactionType": "Payment",
            "TicketSequence": "1000"
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try validateBaseTransaction(common: txJson))
    }

    func testInvalidTxnSignature() {
        let txJson = [
            "Account": "r97KeayHuEsDwyU1yPBVtMLLoQr79QcRFe",
            "TransactionType": "Payment",
            "TxnSignature": 1000
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try validateBaseTransaction(common: txJson))
    }

    func testInvalidSigners() {
        let txJson = [
            "Account": "r97KeayHuEsDwyU1yPBVtMLLoQr79QcRFe",
            "TransactionType": "Payment",
            "Signers": []
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try validateBaseTransaction(common: txJson))

        let txJson2 = [
            "Account": "r97KeayHuEsDwyU1yPBVtMLLoQr79QcRFe",
            "TransactionType": "Payment",
            "Signers": [
                [
                    "Signer": [
                        "Account": "r...."
                    ]
                ]
            ]
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try validateBaseTransaction(common: txJson2))
    }

    func testInvalidMemos() {
        let txJson = [
            "Account": "r97KeayHuEsDwyU1yPBVtMLLoQr79QcRFe",
            "TransactionType": "Payment",
            "Memos": [
                [
                    "Memo": [
                        "MemoData": "HI",
                        "Address": "WRONG"
                    ]
                ]
            ]
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try validateBaseTransaction(common: txJson))
    }
}
