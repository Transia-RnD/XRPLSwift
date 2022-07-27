//
//  File.swift
//  
//
//  Created by Denis Angell on 7/26/22.
//

import Foundation


struct XRPLRequest: Codable {
    var value: String = ""
}


public enum rResponse: Codable {
    case ledgerResponse(LedgerResponse)
    func get() -> Any? {
        switch self {
        case .ledgerResponse(let response):
            return response
        }
    }
    
    func value() -> String? {
        switch self {
        case .ledgerResponse:
            return "ledgerResponse"
        }
    }
}
