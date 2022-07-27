//
//  File.swift
//  
//
//  Created by Denis Angell on 7/26/22.
//

import Foundation

public enum rLedgerIndex: Codable {
    case string(String) // ('validated' | 'closed' | 'current')
    case number(Int)
    func get() -> Any? {
        switch self {
        case .string(let string):
            return string
        case .number(let number):
            return number
        }
    }
    
    func value() -> String? {
        switch self {
        case .string:
            return "string"
        case .number:
            return "number"
        }
    }
}

struct XRP: Codable {
    var currency: String = "XRP"
}

protocol IssuedCurrency: Codable {
    var currency: String { get set }
    var issuer: String { get set }
}

enum xCurrency {
    case xrp (XRP)
    case issuedCurrency (IssuedCurrency)
}

public struct xIssuedCurrencyAmount: IssuedCurrency, Codable {
    var currency: String
    var issuer: String
    var value: String
}

enum AmountType {
    case string
    case ic
}

public enum rAmount: Codable {
    case string(String)
    case ic(xIssuedCurrencyAmount)
    func get() -> Any? {
        switch self {
        case .string(let string):
            return string
        case .ic(let ic):
            return ic
        }
    }
    
    func value() -> String? {
        switch self {
        case .string:
            return "string"
        case .ic:
            return "ic"
        }
    }
}
//
//public struct rAmount: Codable {
//    var bytes: [UInt8] = []
//    var type: AmountType
//
//    init?(rawValue: Any) {
//        if let rv = rawValue as? String {
//            self.bytes = rv.bytes
//        }
//        if let rv = rawValue as? xIssuedCurrencyAmount {
//            self.bytes = rv.value.bytes
//        }
//        return nil
//    }
//
//    func rawValue() -> Any {
//        switch self.type {
//        case .string: return self.bytes.toHexString()
//        case .ic: return Amount(bytes: self.bytes)
//        }
//    }
//}

