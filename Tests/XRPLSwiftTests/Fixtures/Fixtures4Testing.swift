//
//  TestFixtures.swift
//  
//
//  Created by Denis Angell on 7/28/22.
//

import XCTest
@testable import XRPLSwift

final class Fixtures4Testing: XCTestCase {
    
    public static let ACCOUNT_OBJECTS: [String: AnyObject] = [:]
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
    
    public static let addressTests: [
        [
            "type": "Classic Address",
            "address": [ADDRESSES]["ACCOUNT"],
        ],
        [
            "type": "X-Address",
            "address": [ADDRESSES]["ACCOUNT_X"],
        ],
    ]
    
    override class func setUp() {
        do {
            let data: Data = accountObjectFixture.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String:AnyObject] {
                Fixtures4Testing.ACCOUNT_OBJECTS = jsonResult
            }
            /**
             * Setup to run tests on both classic addresses and X-addresses.
             */
            export const addressTests = [
              { type: 'Classic Address', address: addresses.ACCOUNT },
              { type: 'X-Address', address: addresses.ACCOUNT_X },
            ]
        } catch {
            print(error.localizedDescription)
        }
    }
}
