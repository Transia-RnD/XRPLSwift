//
//  TicketCreate.swift
//  AnyCodable
//
//  Created by Denis Angell on 7/31/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/ticketCreate.ts


/**
 * A TicketCreate transaction sets aside one or more sequence numbers as
 * Tickets.
 *
 */
public class TicketCreate: BaseTransaction {
    /**
     * How many Tickets to create. This must be a positive number and cannot
     * cause the account to own more than 250 Tickets after executing this
     * transaction.
     */
    public var ticketCount: Int
    /*
     This field is required.
     :meta hide-value:
     */
    
    enum CodingKeys: String, CodingKey {
        case ticketCount = "TicketCount"
    }
    
    public init(ticketCount: Int) {
        self.ticketCount = ticketCount
        super.init(account: "", transactionType: "TrustSet")
    }
    
    public override init(json: [String: AnyObject]) throws {
        let decoder: JSONDecoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let r = try decoder.decode(TicketCreate.self, from: data)
        self.ticketCount = r.ticketCount
        try super.init(json: json)
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ticketCount = try values.decode(Int.self, forKey: .ticketCount)
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(ticketCount, forKey: .ticketCount)
    }
}


let MAX_TICKETS: Int = 250

/**
 * Verify the form and type of a TicketCreate at runtime.
 *
 * @param tx - A TicketCreate Transaction.
 * @throws When the TicketCreate is malformed.
 */
public func validateTicketCreate(tx: [String: AnyObject]) throws -> Void {
    try validateBaseTransaction(common: tx)
    
    let ticketCount: Int? = tx["TicketCount"] as? Int
    if tx["TicketCount"] == nil {
        throw ValidationError.decoding("TicketCreate: missing field TicketCount")
    }
    
    if !(tx["TicketCount"] is Int) {
        throw ValidationError.decoding("TicketCreate: TicketCount must be a number")
    }
    
    if (
        ticketCount == nil ||
        ticketCount! < 1 ||
        ticketCount! > MAX_TICKETS
    ) {
        throw ValidationError.decoding("TicketCreate: TicketCount must be an integer from 1 to 250")
    }
}
