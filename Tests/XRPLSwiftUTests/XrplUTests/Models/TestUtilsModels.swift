//
//  TestUtilsModels.swift
//  
//
//  Created by Denis Angell on 9/17/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/utils.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestUtilsModels: XCTestCase {

    final var flags: Int = 0
    final let flag1: Int = 0x00010000
    final let flag2: Int = 0x00020000

    override func setUp() {
        flags = 0x00000000
    }

    func testIsEnabled() {
        setUp()
        flags |= flag1 | flag2
        XCTAssertTrue(isFlagEnabled(flags: flags, checkFlag: flag1))
    }

    func testIsNotEnabled() {
        setUp()
        flags |= flag2
        XCTAssertFalse(isFlagEnabled(flags: flags, checkFlag: flag1))
    }
}

final class TestUtilsFlags: XCTestCase {

    func testOfferFlags() {
        var tx = [
            "Account": "r3rhWeE31Jt5sWmi4QiGLMZnY3ENgqw96W",
            "Fee": "10",
            "Flags": [
                OfferCreateFlags.tfPassive,
//                OfferCreateFlags.tfImmediateOrCancel,
                OfferCreateFlags.tfFillOrKill
//                OfferCreateFlags.tfSell,
            ],
            "LastLedgerSequence": 65453019,
            "Sequence": 40949322,
            "SigningPubKey":
                "03C48299E57F5AE7C2BE1391B581D313F1967EA2301628C07AC412092FDC15BA22",
            "Expiration": 10,
            "OfferSequence": 12,
            "TakerGets": [
                "currency": "DSH",
                "issuer": "rcXY84C4g14iFp6taFXjjQGVeHqSCh9RX",
                "value": "43.11584856965009"
            ],
            "TakerPays": "12928290425",
            "TransactionType": "OfferCreate",
            "TxnSignature":
                "3045022100D874CDDD6BB24ED66E83B1D3574D3ECAC753A78F26DB7EBA89EAB8E7D72B95F802207C8CCD6CEA64E4AE2014E59EE9654E02CA8F03FE7FCE0539E958EAE182234D91"
        ] as! [String: AnyObject]

        let expected: Int = OfferCreateFlags.tfPassive.rawValue | OfferCreateFlags.tfFillOrKill.rawValue
        try! setTransactionFlagsToNumber(tx: &tx)
        XCTAssertEqual(tx["Flags"] as! Int, expected)
    }

    func testPaymentChannelFlags() {
        var tx = [
            "Account": "r...",
            "TransactionType": "PaymentChannelClaim",
            "Channel": "C1AE6DDDEEC05CF2978C0BAD6FE302948E9533691DC749DCDD3B9E5992CA6198",
            "Flags": [
                PaymentChannelClaimFlag.tfRenew
            ]
        ] as! [String: AnyObject]

        let expected: Int = PaymentChannelClaimFlag.tfRenew.rawValue
        try! setTransactionFlagsToNumber(tx: &tx)
        XCTAssertEqual(tx["Flags"] as! Int, expected)
    }

    func testPaymentFlags() {
        var tx = [
            "TransactionType": "Payment",
            "Account": "rUn84CUYbNjRoTQ6mSW7BVJPSVJNLb1QLo",
            "Amount": "1234",
            "Destination": "rfkE1aSy9G8Upk4JssnwBxhEv5p4mn2KTy",
            "Flags": [
                PaymentFlags.tfPartialPayment,
                PaymentFlags.tfLimitQuality
            ]
        ] as! [String: AnyObject]

        let expected: Int = PaymentFlags.tfPartialPayment.rawValue | PaymentFlags.tfLimitQuality.rawValue
        try! setTransactionFlagsToNumber(tx: &tx)
        XCTAssertEqual(tx["Flags"] as! Int, expected)
    }

    func testTrustSetFlags() {
        var tx = [
            "TransactionType": "TrustSet",
            "Account": "rUn84CUYbNjRoTQ6mSW7BVJPSVJNLb1QLo",
            "LimitAmount": [
              "currency": "XRP",
              "issuer": "rcXY84C4g14iFp6taFXjjQGVeHqSCh9RX",
              "value": "4329.23"
            ],
            "QualityIn": 1234,
            "QualityOut": 4321,
            "Destination": "rfkE1aSy9G8Upk4JssnwBxhEv5p4mn2KTy",
            "Flags": [
                TrustSetFlag.tfSetfAuth,
                TrustSetFlag.tfClearNoRipple,
                TrustSetFlag.tfClearFreeze
            ]
        ] as! [String: AnyObject]
        let expected: Int = TrustSetFlag.tfSetfAuth.rawValue | TrustSetFlag.tfClearNoRipple.rawValue | TrustSetFlag.tfClearFreeze.rawValue
        try! setTransactionFlagsToNumber(tx: &tx)
        XCTAssertEqual(tx["Flags"] as! Int, expected)
    }

    func testOtherTxFlags() {
        var tx = [
            "TransactionType": "DepositPreauth",
            "Account": "rUn84CUYbNjRoTQ6mSW7BVJPSVJNLb1QLo",
            "Flags": []
        ] as! [String: AnyObject]
        try! setTransactionFlagsToNumber(tx: &tx)
        XCTAssertEqual(tx["Flags"] as! Int, 0)
    }

//    func testAccountFlagsAllEnabled() {
//        let accountRootFlags: Int = AccountRootFlags.lsfDefaultRipple | AccountRootFlags.lsfDepositAuth | AccountRootFlags.lsfDisableMaster | AccountRootFlags.lsfDisallowXRP | AccountRootFlags.lsfGlobalFreeze | AccountRootFlags.lsfNoFreeze | AccountRootFlags.lsfPasswordSpent | AccountRootFlags.lsfRequireAuth | AccountRootFlags.lsfRequireDestTag
////        let parsed = parseAccountRootFlags(accountRootFlags)
////        XCTAssertTrue(parsed["lsfDefaultRipple"])
//    }

    func testAccountFlagsAllDisabled() {
        let parsed = parseAccountRootFlags(flags: 0)
        XCTAssertNil(parsed[.lsfDefaultRipple])
        XCTAssertNil(parsed[.lsfDepositAuth])
        XCTAssertNil(parsed[.lsfDisableMaster])
        XCTAssertNil(parsed[.lsfDisallowXRP])
        XCTAssertNil(parsed[.lsfGlobalFreeze])
        XCTAssertNil(parsed[.lsfNoFreeze])
        XCTAssertNil(parsed[.lsfPasswordSpent])
        XCTAssertNil(parsed[.lsfRequireAuth])
        XCTAssertNil(parsed[.lsfRequireDestTag])
    }
}
