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
        let fieldTypeName: String = Definitions().getFieldTypeName(fieldName: TestDefinitions.testFieldName)
        XCTAssertEqual(expectedFieldTypeName, fieldTypeName)
    }

    func testGetFieldTypeCode() {
        let expectedFieldTypeCode: Int = 2
        let fieldTypeCode: Int = try! Definitions().getFieldTypeCode(fieldName: TestDefinitions.testFieldName)
        XCTAssertEqual(expectedFieldTypeCode, fieldTypeCode)
    }

    func testGetFieldCode() {
        let expectedFieldCode: Int = 4
        let fieldCode: Int = Definitions().getFieldCode(fieldName: TestDefinitions.testFieldName)
        XCTAssertEqual(expectedFieldCode, fieldCode)
    }

    func testGetFieldHeaderFromName() {
        let expectedFieldHeader: FieldHeader = FieldHeader(typeCode: 2, fieldCode: 4)
        let fieldHeader: FieldHeader = Definitions().getFieldHeaderFromName(fieldName: TestDefinitions.testFieldName)
        XCTAssertEqual(expectedFieldHeader, fieldHeader)
    }

    func testGetFieldNameFromHeader() {
        let expectedFieldName: String = TestDefinitions.testFieldName
        let fieldHeader: FieldHeader = FieldHeader(typeCode: 2, fieldCode: 4)
        let fieldName = Definitions().getFieldNameFromHeader(fieldHeader: fieldHeader)
        XCTAssertEqual(expectedFieldName, fieldName)
    }
}
