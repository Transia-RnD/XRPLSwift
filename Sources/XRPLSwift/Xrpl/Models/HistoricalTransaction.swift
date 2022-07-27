//
//  HistoricalTransaction.swift
//  BigInt
//
//  Created by Mitch Lang on 2/3/20.
//

import Foundation

public struct HistoricalTransaction {
    public var type: String
    public var address: String
    public var amount: aAmount
    public var date: Date
    public var raw: NSDictionary
}
