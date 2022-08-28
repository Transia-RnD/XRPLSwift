//
//  AccountDelete.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/4/20.
//  Updated by Denis Angell on 6/4/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/accountDelete.ts

public class AccountDelete: BaseTransaction {

    /*
     Represents an `AccountDelete transaction
     <https://xrpl.org/accountdelete.html>`_, which deletes an account and any
     objects it owns in the XRP Ledger, if possible, sending the account's remaining
     XRP to a specified destination account.
     See `Deletion of Accounts
     <https://xrpl.org/accounts.html#deletion-of-accounts>`_ for the requirements to
     delete an account.
     */

    public var destination: String
    /*
     The address of the account to which to send any remaining XRP.
     This field is required.
     :meta hide-value:
     */
    public var destinationTag: Int?
    /*
     The `destination tag
     <https://xrpl.org/source-and-destination-tags.html>`_ at the
     ``destination`` account where funds should be sent.
     */

    enum CodingKeys: String, CodingKey {
        case destination = "Destination"
        case destinationTag = "DestinationTag"
    }

    public init(
        destination: String,
        destinationTag: Int? = nil
    ) {
        // Required
        self.destination = destination
        // Optional
        self.destinationTag = destinationTag
        super.init(account: "", transactionType: "AccountSet")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(AccountDelete.self, from: data)
        self.destination = decoded.destination
        self.destinationTag = decoded.destinationTag
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        destination = try values.decode(String.self, forKey: .destination)
        destinationTag = try values.decodeIfPresent(Int.self, forKey: .destinationTag)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(destination, forKey: .destination)
        if let destinationTag = destinationTag { try values.encode(destinationTag, forKey: .destinationTag) }
    }
}

/**
 * Verify the form and type of an AccountDelete at runtime.
 *
 * @param tx - An AccountDelete Transaction.
 * @throws When the AccountDelete is Malformed.
 */
public func validateAccountDelete(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    guard let destination = tx["Destination"] as? String, !destination.isEmpty else {
        throw XrplError.validation("AccountDelete: invalid Destination")
    }

    guard tx["DestinationTag"] is Int else {
        throw XrplError.validation("AccountDelete: invalid Destination")
    }
}
