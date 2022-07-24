//
//  Currency.swift
//  BigInt
//
//  Created by Mitch Lang on 2/3/20.
//

import Foundation

public struct aCurrency: Codable {
    public var address: String
    public var balance: String
    public var currency: String
    public var limit: String
    public var noRipple: Bool?
    public var noRipplePeer: Bool?
    public var qualityIn: String?
    public var qualityOut: String?
    
    public init(address: String, balance: String, currency: String, limit: String) {
        self.address = address
        self.balance = balance
        self.currency = currency
        self.limit = limit
    }
}
