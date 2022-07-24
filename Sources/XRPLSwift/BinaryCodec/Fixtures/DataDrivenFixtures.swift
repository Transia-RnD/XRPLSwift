//
//  File.swift
//  
//
//  Created by Denis Angell on 7/24/22.
//

import Foundation

//_FILENAME = "./data/data-driven-tests.json"
//dirname = os.path.dirname(__file__)
//absolute_path = os.path.join(dirname, _FILENAME)
//with open(absolute_path) as data_driven_tests:
//    _FIXTURES_JSON = json.load(data_driven_tests)


// top level keys: ['types', 'fields_tests', 'whole_objects', 'values_tests']
//let FIXTURES_JSON = json.load(data_driven_tests)

internal class DataDrivenFixtures {
    
    var FIXTURES_JSON: [String: AnyObject] = [:]
    
    init() {
        do {
            let data: Data = dataDrivenTestsJson.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String:AnyObject] {
                self.FIXTURES_JSON = jsonResult
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /*
     Constructs and returns a list of FieldTest objects after parsing JSON data
     describing field test fixtures.
     */
    func getFieldTests() -> [FieldTest] {
        var testList: [FieldTest] = []
        let tests = self.FIXTURES_JSON["fields_tests"] as! [[String : AnyObject]]
        for result in tests {
            let fieldTestDict = result
            testList.append(constructFieldTest(fieldTestDict: fieldTestDict))
        }
        return testList
    }
    
    /*
     Constructs and returns a list of ValueTest objects after parsing JSON data
     describing value test fixtures.
     */
    func getValueTests() -> [ValueTest] {
        var testList: [ValueTest] = []
        let tests = self.FIXTURES_JSON["values_tests"] as! [[String : AnyObject]]
        for result in tests {
            let valueTestDict = result
            testList.append(constructValueTest(valueTestDict: valueTestDict))
        }
        return testList
    }
    
    
    /*
     Constructs and returns a list of WholeObjectTest objects after parsing JSON data
     describing whole object test fixtures.
     */
    func getWholeObjectTests() -> [WholeObjectTest] {
        var testList: [WholeObjectTest] = []
        let tests = self.FIXTURES_JSON["whole_objects"] as! [[String : AnyObject]]
        for result in tests {
            let wholeObjectTestDict = result
            testList.append(constructWholeObjectTest(wholeObjectTestDict: wholeObjectTestDict))
        }
        return testList
    }
    
    
    func constructFieldTest(fieldTestDict: [String: AnyObject]) -> FieldTest {
        return FieldTest(
            typeName: fieldTestDict["type_name"] as! String,
            name: fieldTestDict["name"] as! String,
            nthOfType: fieldTestDict["nth_of_type"] as! Int,
            type: fieldTestDict["type"] as! Int,
            expectedHex: fieldTestDict["expected_hex"] as! String
        )
    }
    
    
    func constructValueTest(valueTestDict: [String: AnyObject]) -> ValueTest {
        let typeId = valueTestDict["type_id"] as? String
        let isNative = valueTestDict["is_native"] as? Bool
        let expectedHex = valueTestDict["expected_hex"] as? String
        let isNegative = valueTestDict["is_negative"] as? Bool
        let typeSpecialisationField = valueTestDict["type_specialisation_field"] as? String
        let _error = valueTestDict["error"] as? String
        
        return ValueTest(
            testJson: valueTestDict["test_json"] as! [String : AnyObject],
            typeId: typeId!,
            typeString: valueTestDict["type"] as! String,
            isNative: isNative!,
            expectedHex: expectedHex!,
            isNegative: isNegative!,
            typeSpecializationField: typeSpecialisationField!,
            error: _error!
        )
    }
    
    
    func constructWholeObjectTest(wholeObjectTestDict: [String: AnyObject]) -> WholeObjectTest {
        return WholeObjectTest(
            txJson: wholeObjectTestDict["tx_json"] as! [String : AnyObject],
            expectedHex: wholeObjectTestDict["blob_with_no_signing"] as! String
        )
    }
}

class FieldTest {
    
    internal var typeName: String = ""
    internal var name: String = ""
    internal var nthOfType: Int = 0
    internal var type: Int = 0
    internal var expectedHex: String = ""
    
    init(
        typeName: String,
        name: String,
        nthOfType: Int,
        type: Int,
        expectedHex: String
    ) {
        self.typeName = typeName
        self.name = name
        self.nthOfType = nthOfType
        self.type = type
        self.expectedHex = expectedHex
    }
}


class ValueTest {
    
    internal var testJson: [String: AnyObject] = [:]
    internal var typeId: String = ""
    internal var type: String = ""
    internal var isNative: Bool = false
    internal var expectedHex: String = ""
    internal var isNegative: Bool = false
    internal var typeSpecializationField: String = ""
    internal var error: String = ""
    
    init(
        testJson: [String: AnyObject],
        typeId: String,
        typeString: String,
        isNative: Bool,
        expectedHex: String,
        isNegative: Bool,
        typeSpecializationField: String,
        error: String
    ) {
        self.testJson = testJson
        self.typeId = typeId
        self.type = typeString
        self.isNative = isNative
        self.expectedHex = expectedHex
        self.isNegative = isNegative
        self.typeSpecializationField = typeSpecializationField
        self.error = error
    }
}


class WholeObjectTest {
    
    internal var txJson: [String: AnyObject] = [:]
    internal var expectedHex: String = ""
    
    init(
        txJson: [String: AnyObject],
        expectedHex: String
    ) {
        self.txJson = txJson
        self.expectedHex = expectedHex
    }
}
