//
//  TestFixtures.swift
//  
//
//  Created by Denis Angell on 7/28/22.
//

import XCTest
@testable import XRPLSwift

final class Fixtures4Testing {
    
    public var ACCOUNT_OBJECTS: [String: AnyObject] = [:]
    
    init() {
        do {
            let data: Data = accountObjectFixture.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String:AnyObject] {
                self.ACCOUNT_OBJECTS = jsonResult
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
