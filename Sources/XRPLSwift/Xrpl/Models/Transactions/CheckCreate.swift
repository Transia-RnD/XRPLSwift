//
//  CheckCreate.swift
//
//
//  Created by Denis Angell on 7/31/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/checkCreate.ts

import Foundation

/**
 Represents a [CheckCreate](https://xrpl.org/checkcreate.html) transaction,
 which creates a Check object. A Check object is a deferred payment
 that can be cashed by its intended destination. The sender of this
 transaction is the sender of the Check.
 */
public class CheckCreate: BaseTransaction {
    /**
     The address of the [account](https://xrpl.org/accounts.html)  that can cash the Check. This field is
     required.
     */
    public var destination: String

    /**
     Maximum amount of source token the Check is allowed to debit the
     sender, including transfer fees on non-XRP tokens. The Check can only
     credit the destination with the same token (from the same issuer, for
     non-XRP tokens). This field is required.
     :meta hide-value:
     */
    public var sendMax: Amount

    /**
     An arbitrary [destination tag](https://xrpl.org/source-and-destination-tags.html) that
     identifies the reason for the Check, or a hosted recipient to pay.
     */
    public var destinationTag: Int?

    /**
     Time after which the Check is no longer valid, in seconds since the
     Ripple Epoch.
     */
    public var expiration: Int?

    /**
     Arbitrary 256-bit hash representing a specific reason or identifier for
     this Check.
     */
    public var invoiceId: String?

    enum CodingKeys: String, CodingKey {
        case destination = "Destination"
        case sendMax = "SendMax"
        case destinationTag = "DestinationTag"
        case expiration = "Expiration"
        case invoiceId = "InvoiceId"
    }

    public init(
        destination: String,
        sendMax: Amount,
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

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(CheckCreate.self, from: data)
        self.destination = decoded.destination
        self.sendMax = decoded.sendMax
        self.destinationTag = decoded.destinationTag
        self.expiration = decoded.expiration
        self.invoiceId = decoded.invoiceId
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        destination = try values.decode(String.self, forKey: .destination)
        sendMax = try values.decode(Amount.self, forKey: .sendMax)
        destinationTag = try values.decodeIfPresent(Int.self, forKey: .destinationTag)
        expiration = try values.decodeIfPresent(Int.self, forKey: .expiration)
        invoiceId = try values.decodeIfPresent(String.self, forKey: .invoiceId)
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
 Verify the form and type of an CheckCreate at runtime.
 - parameters:
 - tx: An CheckCreate Transaction.
 - throws:
 When the CheckCreate is Malformed.
 */
public func validateCheckCreate(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["SendMax"] == nil {
        throw ValidationError("CheckCreate: missing field SendMax")
    }

    if tx["Destination"] == nil {
        throw ValidationError("CheckCreate: missing field Destination")
    }

    if !(tx["SendMax"] is String) && !isIssuedCurrency(input: tx["SendMax"] as? [String: AnyObject]) {
        throw ValidationError("CheckCreate: invalid SendMax")
    }

    if !(tx["Destination"] is String) {
        throw ValidationError("CheckCreate: invalid Destination")
    }

    if tx["DestinationTag"] != nil && !(tx["DestinationTag"] is Int) {
        throw ValidationError("CheckCash: invalid DestinationTag")
    }

    if tx["Expiration"] != nil && !(tx["Expiration"] is Int) {
        throw ValidationError("CheckCash: invalid Expiration")
    }

    if tx["InvoiceID"] != nil && !(tx["InvoiceID"] is String) {
        throw ValidationError("CheckCash: invalid InvoiceID")
    }
}
