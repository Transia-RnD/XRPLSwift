//
//  CheckCash.swift
//
//
//  Created by Denis Angell on 7/31/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/checkCash.ts

import Foundation

public class CheckCash: BaseTransaction {
    /**
     Represents a `CheckCash transaction <https://xrpl.org/checkcash.html>`_,
     which redeems a Check object to receive up to the amount authorized by the
     corresponding CheckCreate transaction. Only the Destination address of a
     Check can cash it.
     */

    public let checkId: String
    /**
     The ID of the `Check ledger object
     <https://xrpl.org/check.html>`_ to cash, as a 64-character
     hexadecimal string. This field is required.
     :meta hide-value:
     */

    public let amount: Amount?
    /**
     Redeem the Check for exactly this amount, if possible. The currency must
     match that of the SendMax of the corresponding CheckCreate transaction.
     You must provide either this field or ``DeliverMin``.
     */

    public let deliverMin: Amount?
    /**
     Redeem the Check for at least this amount and for as much as possible.
     The currency must match that of the ``SendMax`` of the corresponding
     CheckCreate transaction. You must provide either this field or ``Amount``.
     */

    enum CodingKeys: String, CodingKey {
        case checkId = "CheckID"
        case amount = "Amount"
        case deliverMin = "DeliverMin"
    }

    public init(checkId: String, amount: Amount, deliverMin: Amount) {
        self.checkId = checkId
        self.amount = amount
        self.deliverMin = deliverMin
        super.init(account: "", transactionType: "CheckCash")
    }

    public override init(json: [String: AnyObject]) throws {
        let decoder: JSONDecoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(CheckCash.self, from: data)
        self.checkId = decoded.checkId
        self.amount = decoded.amount
        self.deliverMin = decoded.deliverMin
        try super.init(json: json)
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        checkId = try values.decode(String.self, forKey: .checkId)
        amount = try values.decodeIfPresent(Amount.self, forKey: .amount)
        deliverMin = try values.decodeIfPresent(Amount.self, forKey: .deliverMin)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(checkId, forKey: .checkId)
        if let amount = amount { try values.encode(amount, forKey: .amount) }
        if let deliverMin = deliverMin { try values.encode(deliverMin, forKey: .deliverMin) }
    }
}

/**
 Verify the form and type of an CheckCash at runtime.
 - parameters:
    - tx: An CheckCash Transaction.
 - throws:
 When the CheckCash is Malformed.
 */
public func validateCheckCash(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["Amount"] == nil && tx["DeliverMin"] == nil {
        throw ValidationError("CheckCash: must have either Amount or DeliverMin")
    }

    if tx["Amount"] != nil && tx["DeliverMin"] != nil {
        throw ValidationError("CheckCash: cannot have both Amount and DeliverMin")
    }

    if tx["Amount"] != nil && !isAmount(amount: tx["Amount"] as! String) {
        throw ValidationError("CheckCash: invalid Amount")
    }

    if tx["DeliverMin"] != nil && !isAmount(amount: tx["DeliverMin"] as! String) {
        throw ValidationError("CheckCash: invalid DeliverMin")
    }

    if tx["CheckID"] != nil && !(tx["CheckID"] is String) {
        throw ValidationError("CheckCash: invalid CheckID")
    }
}
