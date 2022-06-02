//
//  RippleResponse.swift
//  XRPLSwift
//
//  Created by Denis Angell on 5/25/22.
//

import Foundation


//export interface BaseRequest {
//  [x: string]: unknown
//  /**
//   * A unique value to identify this request. The response to this request uses
//   * the same id field. This way, even if responses arrive out of order, you
//   * know which request prompted which response.
//   */
//  id?: number | string
//  /** The name of the API method. */
//  command: string
//  /** The API version to use. If omitted, use version 1. */
//  api_version?: number
//}

public struct BaseRequest: Codable {
    public var id: String
    public var command: String
    public var api_version: String
    
    public init(
        id: String,
        command: String,
        api_version: String
    ) {
        self.id = id
        self.command = command
        self.api_version = api_version
    }
}

//interface Warning {
//  id: number
//  message: string
//  details?: { [key: string]: string }
//}

public struct Warning: Codable {
    public var id: Int
    public var message: String
//    public var details: [String: AnyObject]
    
    public init(
        id: Int,
        message: String
//        details: [String: AnyObject]
    ) {
        self.id = id
        self.message = message
//        self.details = details
    }
}

//export interface BaseResponse {
//  id: number | string
//  status?: 'success' | string
//  type: 'response' | string
//  result: unknown
//  warning?: 'load'
//  warnings?: Warning[]
//  forwarded?: boolean
//  api_version?: number
//}

public struct BaseResponse: Codable {
    public var id: String
    public var status: String?
    public var type: String
//    public var result: Any
    public var warning: String = "load"
    public var warnings: [Warning] = []
    public var forwarded: Bool?
    public var api_version: Float
    
    public init(
        id: String,
        status: String?,
        type: String,
//        result: Any,
        warning: String,
        warnings: [Warning] = [],
        forwarded: Bool?,
        api_version: Float
    ) {
        self.id = id
        self.status = status
        self.type = type
//        self.result = result
        self.warning = warning
        self.warnings = warnings
        self.forwarded = forwarded
        self.api_version = api_version
    }
}
