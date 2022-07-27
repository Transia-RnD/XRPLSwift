//
//  BaseMethod.swift
//  
//
//  Created by Denis Angell on 7/27/22.
//

import Foundation
import AnyCodable

public protocol BaseRequest: Codable {
    var id: Int? { get set }
    var command: String? { get set }
    var apiVersion: Int? { get set }
}

public struct Warning: Codable {
    var id: Int!
    var message: String!
    var details: [String: [String: String]]?
}

public class BaseResponse: Codable {
    var id: Int
    var status: String?
    var type: String
    var _result: AnyCodable
    var warning: String = "load"
    var warnings: [Warning]?
    var forwarded: Bool?
    var apiVersion: Int?
    
    init(
        id: Int,
        status: String? = nil,
        type: String,
        _result: AnyCodable,
        warning: String,
        warnings: [Warning]? = nil,
        forwarded: Bool? = nil,
        apiVersion: Int? = nil
    ) {
        self.id = id
        self.status = status
        self.type = type
        self._result = _result
        self.warning = warning
        self.warnings = warnings
        self.forwarded = forwarded
        self.apiVersion = apiVersion
    }
}

public struct ErrorResponse: Codable {
    var id: Int
    var status: String = "error"
    var type: String
    var error: String
    var errorCode: String?
    var errorMessage: String?
    var request: XRPLRequest?
    var apiVersion: Int?
}
