//
//  TestDeriveUtils.swift
//
//
//  Created by Denis Angell on 9/18/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/utils/deriveXAddress.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestDeriveUtils: XCTestCase {

    func testAddressForKey() {
        XCTAssertEqual(
            deriveXAddress(
                "035332FBA71D705BD5D97014A833BE2BBB25BEFCD3506198E14AFEA241B98C2D06",
                nil,
                false
            ),
            "XVZVpQj8YSVpNyiwXYSqvQoQqgBttTxAZwMcuJd4xteQHyt"
        )
        XCTAssertEqual(
            deriveXAddress(
                "035332FBA71D705BD5D97014A833BE2BBB25BEFCD3506198E14AFEA241B98C2D06",
                nil,
                true
            ),
            "TVVrSWtmQQssgVcmoMBcFQZKKf56QscyWLKnUyiuZW8ALU4"
        )
    }

    func testNoTagNil() {
        XCTAssertEqual(
            deriveXAddress(
                "ED02C98225BD1C79E9A4F95C6978026D300AFB7CA2A34358920BCFBCEBE6AFCD6A",
                nil,
                false
            ),
            "X7FbrqVEqdTNoX5qq94rTdarGjeVYmkxi8A1TKAJUnyLL9g"
        )
    }
}
