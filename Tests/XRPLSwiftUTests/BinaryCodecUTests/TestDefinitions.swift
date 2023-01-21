//
//  TestDefinitions.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/test_definition_service.py

import XCTest
@testable import XRPLSwift

final class TestDefinitions: XCTestCase {

    static let testFieldName: String = "Sequence"

    func testLoadDefinitions() {
        let expectedKeys: [String] = ["TYPES", "FIELDS", "TRANSACTION_RESULTS", "TRANSACTION_TYPES"]
        for key in expectedKeys {
            XCTAssertTrue(Definitions().all().contains(key))
        }
    }

    func testInverseTransactionTypeMap() {
        let typeCode: Int = 8
        let expectedTransactionType: String = "OfferCancel"
        let transactionType: String = Definitions().definitions.TRANSACTION_TYPES_REVERSE[typeCode]!
        XCTAssertEqual(expectedTransactionType, transactionType)
    }

    func testInverseTransactionResultMap() {
        let typeCode: Int = 0
        let expectedTransactionType: String = "tesSUCCESS"
        let transactionType: String = Definitions().definitions.TRANSACTION_RESULTS_REVERSE[typeCode]!
        XCTAssertEqual(expectedTransactionType, transactionType)
    }

    func testGetFieldTypeName() {
        let expectedFieldTypeName: String = "UInt32"
        let fieldTypeName: String = Definitions().getFieldTypeName(TestDefinitions.testFieldName)
        XCTAssertEqual(expectedFieldTypeName, fieldTypeName)
    }

    func testGetFieldTypeCode() throws {
        let expectedFieldTypeCode: Int = 2
        let fieldTypeCode: Int = try Definitions().getFieldTypeCode(TestDefinitions.testFieldName)
        XCTAssertEqual(expectedFieldTypeCode, fieldTypeCode)
    }

    func testGetFieldCode() {
        let expectedFieldCode: Int = 4
        let fieldCode: Int = Definitions().getFieldCode(TestDefinitions.testFieldName)
        XCTAssertEqual(expectedFieldCode, fieldCode)
    }

    func testGetFieldHeaderFromName() {
        let expectedFieldHeader: FieldHeader = FieldHeader(2, 4)
        let fieldHeader: FieldHeader = Definitions().getFieldHeaderFromName(TestDefinitions.testFieldName)
        XCTAssertEqual(expectedFieldHeader, fieldHeader)
    }

    func testGetFieldNameFromHeader() throws {
        let expectedFieldName: String = TestDefinitions.testFieldName
        let fieldHeader: FieldHeader = FieldHeader(2, 4)
        let fieldName = try Definitions().getFieldNameFromHeader(fieldHeader)
        XCTAssertEqual(expectedFieldName, fieldName)
    }
}
