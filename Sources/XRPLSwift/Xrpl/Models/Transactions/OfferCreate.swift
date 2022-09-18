//
//  OfferCreate.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/offerCreate.ts

/**
Transactions of the OfferCreate type support additional values in the Flags field.
This enum represents those options.
`See OfferCreate Flags <https://xrpl.org/offercreate.html#offercreate-flags>`_
 */
public enum OfferCreateFlags: Int, Codable {
    case tfPassive = 0x00010000
    /**
    If enabled, the offer does not consume offers that exactly match it, and instead
    becomes an Offer object in the ledger. It still consumes offers that cross it.
     */

    case tfImmediateOrCancel = 0x00020000
    /**
    Treat the offer as an `Immediate or Cancel order
    <https://en.wikipedia.org/wiki/Immediate_or_cancel>`_. If enabled, the offer
    never becomes a ledger object: it only tries to match existing offers in the
    ledger. If the offer cannot match any offers immediately, it executes
    "successfully" without trading any currency. In this case, the transaction has
    the result code `tesSUCCESS`, but creates no Offer objects in the ledger.
     */

    case tfFillOrKill = 0x00040000
    /**
    Treat the offer as a `Fill or Kill order
    <https://en.wikipedia.org/wiki/Fill_or_kill>`_. Only try to match existing
    offers in the ledger, and only do so if the entire `TakerPays` quantity can be
    obtained. If the `fix1578 amendment
    <https://xrpl.org/known-amendments.html#fix1578>`_ is enabled and the offer
    cannot be executed when placed, the transaction has the result code `tecKILLED`;
    otherwise, the transaction uses the result code `tesSUCCESS` even when it was
    killed without trading any currency.
     */

    case tfSell = 0x00080000
    /**
    Exchange the entire `TakerGets` amount, even if it means obtaining more than the
    `TakerPays amount` in exchange.
    */
}

extension [OfferCreateFlags] {
    var interface: [OfferCreateFlags: Bool] {
        var flags: [OfferCreateFlags: Bool] = [:]
        for flag in self {
            if flag == .tfPassive {
                flags[flag] = true
            }
            if flag == .tfImmediateOrCancel {
                flags[flag] = true
            }
            if flag == .tfFillOrKill {
                flags[flag] = true
            }
            if flag == .tfSell {
                flags[flag] = true
            }
        }
        return flags
    }
}

/**
Represents an `OfferCreate <https://xrpl.org/offercreate.html>`_ transaction,
which executes a limit order in the `decentralized exchange
<https://xrpl.org/decentralized-exchange.html>`_. If the specified exchange
cannot be completely fulfilled, it creates an Offer object for the remainder.
Offers can be partially fulfilled.
 */
public class OfferCreate: BaseTransaction {

    public let takerGets: Amount
     /*
    The amount and type of currency being provided by the sender of this
    transaction. This field is required.
    :meta hide-value:
      */

    public let takerPays: Amount
      /*
    The amount and type of currency the sender of this transaction wants in
    exchange for the full ``taker_gets`` amount. This field is required.
    :meta hide-value:
       */

    public let expiration: Int?
       /*
    Time after which the offer is no longer active, in seconds since the
    Ripple Epoch.
        */

    public let offerSequence: Int?
        /*
    The Sequence number (or Ticket number) of a previous OfferCreate to cancel
    when placing this Offer.
    */

    enum CodingKeys: String, CodingKey {
        case takerGets = "TakerGets"
        case takerPays = "TakerPays"
        case expiration = "Expiration"
        case offerSequence = "OfferSequence"
    }

    public init(
        takerGets: Amount,
        takerPays: Amount,
        expiration: Int? = nil,
        offerSequence: Int? = nil
    ) {

        self.takerGets = takerGets
        self.takerPays = takerPays
        self.expiration = expiration
        self.offerSequence = offerSequence
        super.init(account: "", transactionType: "OfferCreate")
    }

    public override init(json: [String: AnyObject]) throws {
        let decoder: JSONDecoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(OfferCreate.self, from: data)
        self.takerGets = decoded.takerGets
        self.takerPays = decoded.takerPays
        self.expiration = decoded.expiration
        self.offerSequence = decoded.offerSequence
        try super.init(json: json)
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        takerGets = try values.decode(Amount.self, forKey: .takerGets)
        takerPays = try values.decode(Amount.self, forKey: .takerPays)
        expiration = try values.decodeIfPresent(Int.self, forKey: .expiration)
        offerSequence = try values.decodeIfPresent(Int.self, forKey: .offerSequence)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(takerGets, forKey: .takerGets)
        try values.encode(takerPays, forKey: .takerPays)
        if let expiration = expiration { try values.encode(expiration, forKey: .expiration) }
        if let offerSequence = offerSequence { try values.encode(offerSequence, forKey: .offerSequence) }
    }
}

/**
 * Verify the form and type of an OfferCreate at runtime.
 *
 * @param tx - An OfferCreate Transaction.
 * @throws When the OfferCreate is Malformed.
 */
public func validateOfferCreate(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["TakerGets"] == nil {
        throw ValidationError.decoding("OfferCreate: missing field TakerGets")
    }

    if tx["TakerPays"] == nil {
        throw ValidationError.decoding("OfferCreate: missing field TakerPays")
    }

    if !(tx["TakerGets"] is String) && !isAmount(amount: tx["TakerGets"] as Any) {
        throw ValidationError.decoding("OfferCreate: invalid TakerGets")
    }

    if !(tx["TakerPays"] is String) && !isAmount(amount: tx["TakerPays"] as Any) {
        throw ValidationError.decoding("OfferCreate: invalid TakerPays")
    }

    if tx["Expiration"] != nil && !(tx["Expiration"] is Int) {
        throw ValidationError.decoding("OfferCreate: Expiration must be a Int")
    }

    if tx["OfferSequence"] != nil && !(tx["OfferSequence"] is Int) {
        throw ValidationError.decoding("OfferCreate: OfferSequence must be a Int")
    }
}
