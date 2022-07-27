//
//  TestSTObject.swift
//  
//
//  Created by Denis Angell on 7/23/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/types/test_serialized_dict.py

import Foundation

import XCTest
@testable import XRPLSwift

final class TestSTObject: XCTestCase {
    
    public static let maxDiff: Int = 1000
    
    private let EXPECTED_JSON: [String: AnyObject] = [
        "Account": "raD5qJMAShLeHZXf9wjUmo6vRK4arj9cF3",
        "Fee": "10",
        "Flags": 0,
        "Sequence": 103929,
        "SigningPubKey": "028472865AF4CB32AA285834B57576B7290AA8C31B459047DB27E16F418D6A7166",
        "TakerGets": [
            "value": "1694.768",
            "currency": "ILS",
            "issuer": "rNPRNzBB92BVpAhhZr4iXDTveCgV5Pofm9",
        ],
        "TakerPays": "98957503520",
        "TransactionType": "OfferCreate",
        "TxnSignature": "304502202ABE08D5E78D1E74A4C18F2714F64E87B8BD57444AFA5733109EB3C077077520022100DB335EE97386E4C0591CAC024D50E9230D8F171EEB901B5E5E4BD6D1E0AEF98C",
    ] as [String: AnyObject]

    private let BUFFER: String = "120007220000000024000195F964400000170A53AC2065D5460561EC9DE000000000000000000000000000494C53000000000092D705968936C419CE614BF264B5EEB1CEA47FF468400000000000000A7321028472865AF4CB32AA285834B57576B7290AA8C31B459047DB27E16F418D6A71667447304502202ABE08D5E78D1E74A4C18F2714F64E87B8BD57444AFA5733109EB3C077077520022100DB335EE97386E4C0591CAC024D50E9230D8F171EEB901B5E5E4BD6D1E0AEF98C811439408A69F0895E62149CFCC006FB89FA7D1E6E5D"
    
    func testFromValue() {
        let transaction: STObject = try! STObject.from(value: self.EXPECTED_JSON)
        print("TRANSACTION: \(transaction.toJson())")
        XCTAssertEqual(self.BUFFER, transaction.str())
    }

    func testFromValueToJson() {
        let transaction: STObject = try! STObject.from(value: self.EXPECTED_JSON)
        let result: [String: Any] = transaction.toJson()
//        XCTAssertEqual(result, self.EXPECTED_JSON)
    }

    func testFromParserToJson() {
        let parser: BinaryParser = BinaryParser(hex: self.BUFFER)
        let transaction: SerializedType = try! STObject().fromParser(parser: parser, hint: nil)
        let result: [String: Any] = transaction.toJson()
        print(result)
//        XCTAssertEqual(result, self.EXPECTED_JSON)
    }
    
}
