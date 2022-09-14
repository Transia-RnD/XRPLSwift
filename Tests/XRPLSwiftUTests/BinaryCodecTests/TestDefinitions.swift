//
//  TestDefinitions.swift
//  
//
//  Created by Denis Angell on 7/4/22.
//

import XCTest
@testable import XRPLSwift

final class TestUDefinitions: XCTestCase {

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
        let fieldTypeName: String = Definitions().getFieldTypeName(fieldName: TestUDefinitions.testFieldName)
        XCTAssertEqual(expectedFieldTypeName, fieldTypeName)
    }

    func testGetFieldTypeCode() {
        let expectedFieldTypeCode: Int = 2
        let fieldTypeCode: Int = try! Definitions().getFieldTypeCode(fieldName: TestUDefinitions.testFieldName)
        XCTAssertEqual(expectedFieldTypeCode, fieldTypeCode)
    }

    func testGetFieldCode() {
        let expectedFieldCode: Int = 4
        let fieldCode: Int = Definitions().getFieldCode(fieldName: TestUDefinitions.testFieldName)
        XCTAssertEqual(expectedFieldCode, fieldCode)
    }

    func testGetFieldHeaderFromName() {
        let expectedFieldHeader: FieldHeader = FieldHeader(typeCode: 2, fieldCode: 4)
        let fieldHeader: FieldHeader = Definitions().getFieldHeaderFromName(fieldName: TestUDefinitions.testFieldName)
        XCTAssertEqual(expectedFieldHeader, fieldHeader)
    }

    func testGetFieldNameFromHeader() {
        let expectedFieldName: String = TestUDefinitions.testFieldName
        let fieldHeader: FieldHeader = FieldHeader(typeCode: 2, fieldCode: 4)
        let fieldName = Definitions().getFieldNameFromHeader(fieldHeader: fieldHeader)
        XCTAssertEqual(expectedFieldName, fieldName)
    }
}
