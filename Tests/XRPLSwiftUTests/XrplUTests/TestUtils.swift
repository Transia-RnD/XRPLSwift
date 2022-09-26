//
//  Testtils.swift
//
//
//  Created by Denis Angell on 7/28/22.
//

import XCTest
@testable import XRPLSwift

final class Testtils: XCTestCase {

    public static let ADDRESSES: [String: String] = [
        "ACCOUNT": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
        "ACCOUNT_X": "X7AcgcsBL6XDcUb289X4mJ8djcdyKaB5hJDWMArnXr61cqZ",
        "ACCOUNT_T": "T719a5UwUCnEs54UsxG9CJYYDhwmFCqkr7wxCcNcfZ6p5GZ",
        "OTHER_ACCOUNT": "rpZc4mVfWUif9CRoHRKKcmhu1nx2xktxBo",
        "THIRD_ACCOUNT": "rwBYyfufTzk77zUSKEu4MvixfarC35av1J",
        "FOURTH_ACCOUNT": "rJnZ4YHCUsHvQu7R6mZohevKJDHFzVD6Zr",
        "ISSUER": "rMH4UxPrbuMa1spCBR98hLLyNJp4d8p4tM",
        "NOTFOUND": "rajTAg3hon5Lcu1RxQQPxTgHvqfhc1EaUS",
        "SECRET": "shsWGZcmZz6YsWWmcnpfr6fLTdtFV",
        "SOURCE_LOW_FUNDS": "rhVgDEfS1r1fLyRUZCpab4TdowZcAJwHy2"
    ]

    public static let addressTests: [[String: String]] = [
        [
            "type": "Classic Address",
            "address": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59"
        ],
        [
            "type": "X-Address",
            "address": "X7AcgcsBL6XDcUb289X4mJ8djcdyKaB5hJDWMArnXr61cqZ"
        ]
    ]
}

/**
 * Check the response against the expected result. Optionally validate
 * that response against a given schema as well.
 *
 * @param response - Response received from the method.
 * @param expected - Expected response from the method.
 * @param _schemaName - Name of the schema used to validate the shape of the response.
 */
public func assertResultMatch<T: Codable>(
    response: T?,
    expected: [String: AnyObject],
    _schemaName: String? = nil
) {
//    guard let type = T.Type else {
//        XCTFail("TESTING: Invalid Type")
//    }

    let jsonData = try! JSONSerialization.data(
        withJSONObject: expected,
        options: .prettyPrinted
    )
    let encoder = JSONEncoder()
    let e = CodableHelper.decode(T.self, from: jsonData).decodableObj
    let edata: Data = try! encoder.encode(e)
    let rdata: Data = try! encoder.encode(response)
//    XCTAssertEqual(edata.bytes, rdata.bytes)
}
