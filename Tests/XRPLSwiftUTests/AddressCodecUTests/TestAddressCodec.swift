//
//  TestAddressCodec.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/addresscodec/test_main.py

import XCTest
@testable import XRPLSwift

final class TestAddressCodec: XCTestCase {

    static let testCases = AddressCodecFixtures.addressCodecFixtures

    func testClassicAddressToXaddress() {
        for testCase in TestAddressCodec.testCases {
            let classicAddress: String = testCase[0] as! String
            let tag: Int? = testCase[1] as? Int ?? nil
            let expectedMainXaddress: String = testCase[2] as! String
            let expectedTestXaddress: String = testCase[3] as! String

            do {
                // test
                let xAddressTest: String = try AddressCodec.classicAddressToXAddress(
                    classicAddress: classicAddress,
                    tag: (tag != nil) ? Int(tag!) : nil,
                    isTest: true
                )
                XCTAssert(xAddressTest == expectedTestXaddress)

                // main
                let xAddressMain: String = try AddressCodec.classicAddressToXAddress(
                    classicAddress: classicAddress,
                    tag: (tag != nil) ? Int(tag!) : nil,
                    isTest: false
                )
                XCTAssert(xAddressMain == expectedMainXaddress)
            } catch {
                XCTFail("Could not convert classic address to x address")
            }
        }
    }

    func testXAddressToClassicAddress() {
        for testCase in TestAddressCodec.testCases {
            let classicAddress: String = testCase[0] as! String
            //            let tag: UInt32? = testCase[1] as? UInt32 ?? nil
            let expectedMainXaddress: String = testCase[2] as! String
            let expectedTestXaddress: String = testCase[3] as! String

            do {
                // test
                let testResult = try AddressCodec.xAddressToClassicAddress(
                    xAddress: expectedTestXaddress
                )
                let classicAddressTest = testResult.classicAddress
                XCTAssert(classicAddressTest == classicAddress)

                // main
                let mainResult = try AddressCodec.xAddressToClassicAddress(
                    xAddress: expectedMainXaddress
                )
                let classicAddressMain = mainResult.classicAddress
                XCTAssert(classicAddressMain == classicAddress)
            } catch {
                XCTFail("Could not convert classic address to x address")
            }
        }
    }

    //     Notes: Tag is a UInt32. Swift will reject the UInt32 if "out of bounds"
    //    func testClassicAddressToXaddressInvalidTag() {
    //        let classicAddress = "rGWrZyQqhTp9Xu7G5Pkayo7bXjH4k4QYpf"
    //        let tag = MAX_32_BIT_UNSIGNED_INT + 1
    //        do {
    //            _ = try AddressCodec.classicAddressToXAddress(
    //                classicAddress: classicAddress,
    //                tag: UInt32(tag),
    //                isTest: true
    //            )
    //        } catch {
    //            XCTAssertTrue(error is AddressCodecError, "Unexpected error type: \(type(of: error))")
    //        }
    //        do {
    //            _ = try AddressCodec.classicAddressToXAddress(
    //                classicAddress: classicAddress,
    //                tag: UInt32(tag),
    //                isTest: false
    //            )
    //        } catch {
    //            XCTAssertTrue(error is AddressCodecError, "Unexpected error type: \(type(of: error))")
    //        }
    //    }

    //    func testClassicAddressToXaddressBadClassicAddress() {
    //        let classicAddress = "r"
    //        do {
    //            _ = try AddressCodec.classicAddressToXAddress(
    //                classicAddress: classicAddress,
    //                isTest: true
    //            )
    //        } catch {
    //            XCTAssertTrue(error is AddressCodecError, "Unexpected error type: \(type(of: error))")
    //        }
    //        do {
    //            _ = try AddressCodec.classicAddressToXAddress(
    //                classicAddress: classicAddress,
    //                isTest: false
    //            )
    //        } catch {
    //            XCTAssertTrue(error is AddressCodecError, "Unexpected error type: \(type(of: error))")
    //        }
    //    }

    func testConvertIsTest() {
        let classicAddress = "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59"
        let tag: Int? = nil
        let xaddress = "X7AcgcsBL6XDcUb289X4mJ8djcdyKaB5hJDWMArnXr61cqZ"
        let result = try! AddressCodec.classicAddressToXAddress(classicAddress: classicAddress, tag: tag, isTest: false)
        XCTAssertEqual(result, xaddress)
    }

    func testIsValidClassicAddressSecp256k1() {
        let classicAddress = "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw1"
        let result = XrplCodec.isValidClassicAddress(classicAddress: classicAddress)
        XCTAssertTrue(result)
    }

    func testIsValidClassicAddressEd25519() {
        let classicAddress = "rLUEXYuLiQptky37CqLcm9USQpPiz5rkpD"
        let result = XrplCodec.isValidClassicAddress(classicAddress: classicAddress)
        XCTAssertTrue(result)
    }

    func testIsValidClassicAddressInvalid() {
        let classicAddress = "rU6K7V3Po4snVhBBaU29sesqs2qTQJWDw2"
        let result = XrplCodec.isValidClassicAddress(classicAddress: classicAddress)
        XCTAssertFalse(result)
    }

    func testIsValidXAddress() {
        let xAddress = "X7AcgcsBL6XDcUb289X4mJ8djcdyKaB5hJDWMArnXr61cqZ"
        let result = AddressCodec.isValidXAddress(xAddress: xAddress)
        XCTAssertTrue(result)
    }

    func testIsValidXAddressInvalid() {
        let xAddress = "XVLhHMPHU98es4dbozjVtdWzVrDjtV18pX8zeUygYrCgrPh"
        let result = AddressCodec.isValidXAddress(xAddress: xAddress)
        XCTAssertFalse(result)
    }

    func testIsValidXAddressEmpty() {
        let xAddress = ""
        let result = AddressCodec.isValidXAddress(xAddress: xAddress)
        XCTAssertFalse(result)
    }
}
