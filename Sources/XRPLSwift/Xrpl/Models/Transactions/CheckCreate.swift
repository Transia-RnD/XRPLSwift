//
//  CheckCreate.swift
//
//
//  Created by Denis Angell on 7/31/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/checkCreate.ts

import Foundation


/**
 Represents a `CheckCreate <https://xrpl.org/checkcreate.html>`_ transaction,
 which creates a Check object. A Check object is a deferred payment
 that can be cashed by its intended destination. The sender of this
 transaction is the sender of the Check.
 */
public class CheckCreate: BaseTransaction {
    
    /**
     The address of the `account
     <https://xrpl.org/accounts.html>`_ that can cash the Check. This field is
     required.
     */
    public let destination: String
    
    /**
     Maximum amount of source token the Check is allowed to debit the
     sender, including transfer fees on non-XRP tokens. The Check can only
     credit the destination with the same token (from the same issuer, for
     non-XRP tokens). This field is required.
     :meta hide-value:
     */
    public let sendMax: rAmount
    
    /**
     An arbitrary `destination tag
     <https://xrpl.org/source-and-destination-tags.html>`_ that
     identifies the reason for the Check, or a hosted recipient to pay.
     */
    public let destinationTag: Int?
    
    /**
     Time after which the Check is no longer valid, in seconds since the
     Ripple Epoch.
     */
    public let expiration: Int?
    
    /**
     Arbitrary 256-bit hash representing a specific reason or identifier for
     this Check.
     */
    public let invoiceId: String?
    
    enum CodingKeys: String, CodingKey {
        case destination = "Destination"
        case sendMax = "SendMax"
        case destinationTag = "DestinationTag"
        case expiration = "Expiration"
        case invoiceId = "InvoiceId"
    }
    
    public init(
        destination: String,
        sendMax: rAmount,
        destinationTag: Int? = nil,
        expiration: Int? = nil,
        invoiceId: String? = nil
    ) {
        self.destination = destination
        self.sendMax = sendMax
        self.destinationTag = destinationTag
        self.expiration = expiration
        self.invoiceId = invoiceId
        super.init(account: "", transactionType: "CheckCreate")
    }
    
    public override init(json: [String: AnyObject]) throws {
        let decoder: JSONDecoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let r = try decoder.decode(CheckCreate.self, from: data)
        self.destination = r.destination
        self.sendMax = r.sendMax
        self.destinationTag = r.destinationTag
        self.expiration = r.expiration
        self.invoiceId = r.invoiceId
        try super.init(json: json)
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        destination = try values.decode(String.self, forKey: .destination)
        sendMax = try values.decode(rAmount.self, forKey: .sendMax)
        destinationTag = try? values.decode(Int.self, forKey: .destinationTag)
        expiration = try? values.decode(Int.self, forKey: .expiration)
        invoiceId = try? values.decode(String.self, forKey: .invoiceId)
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(destination, forKey: .destination)
        try values.encode(sendMax, forKey: .sendMax)
        if let destinationTag = destinationTag { try values.encode(destinationTag, forKey: .destinationTag) }
        if let expiration = expiration { try values.encode(expiration, forKey: .expiration) }
        if let invoiceId = invoiceId { try values.encode(invoiceId, forKey: .invoiceId) }
    }
}

/**
 * Verify the form and type of an CheckCreate at runtime.
 *
 * @param tx - An CheckCreate Transaction.
 * @throws When the CheckCreate is Malformed.
 */
public func validateCheckCreate(tx: [String: AnyObject]) throws -> Void {
    try validateBaseTransaction(common: tx)
    
    if tx["SendMax"] == nil {
        throw ValidationError.decoding("CheckCreate: missing field SendMax")
    }
    
    if tx["Destination"] == nil {
        throw ValidationError.decoding("CheckCreate: missing field Destination")
    }
    
    if !(tx["SendMax"] is String) && !isIssuedCurrency(input: tx["SendMax"] as? [String: AnyObject]) {
        throw ValidationError.decoding("CheckCreate: invalid SendMax")
    }
    
    if !(tx["Destination"] is String) {
        throw ValidationError.decoding("CheckCreate: invalid Destination")
    }
    
    if tx["DestinationTag"] != nil && !(tx["DestinationTag"] is Int) {
        throw ValidationError.decoding("CheckCash: invalid DestinationTag")
    }
    
    if tx["Expiration"] != nil && !(tx["Expiration"] is Int) {
        throw ValidationError.decoding("CheckCash: invalid Expiration")
    }
    
    if tx["InvoiceID"] != nil && !(tx["InvoiceID"] is Int) {
        throw ValidationError.decoding("CheckCash: invalid InvoiceID")
    }
}
