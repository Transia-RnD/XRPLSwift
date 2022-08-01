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

    public let amount: rAmount?
     /**
        Redeem the Check for exactly this amount, if possible. The currency must
        match that of the SendMax of the corresponding CheckCreate transaction.
        You must provide either this field or ``DeliverMin``.
      */

    public let deliverMin: rAmount?
      /**
        Redeem the Check for at least this amount and for as much as possible.
        The currency must match that of the ``SendMax`` of the corresponding
        CheckCreate transaction. You must provide either this field or ``Amount``.
       */

    
    public init(checkId: String, amount: rAmount, deliverMin: rAmount) {
        self.checkId = checkId
        self.amount = amount
        self.deliverMin = deliverMin
        super.init(account: "", transactionType: "CheckCash")
    }
    
    enum CodingKeys: String, CodingKey {
        case checkId = "CheckID"
        case amount = "Amount"
        case deliverMin = "DeliverMin"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        checkId = try values.decode(String.self, forKey: .checkId)
        amount = try? values.decode(rAmount.self, forKey: .amount)
        deliverMin = try values.decode(rAmount.self, forKey: .deliverMin)
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(checkId, forKey: .checkId)
        if let amount = amount { try values.encode(amount, forKey: .amount) }
        if let deliverMin = deliverMin { try values.encode(deliverMin, forKey: .deliverMin) }
    }
    
//    func _getErrors() -> [String, String] {
//       errors = super()._getErrors()
//        if !(self.amount is nil) ^ (self.deliverMin is nil) {
//           errors["CheckCash"] = "either amount or deliver_min must be set but not both"
//        }
//       return errors
//    }
}
