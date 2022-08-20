//
//  TrustSet.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/4/20.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/trustSet.ts

public enum TrustSetFlag: UInt32 {
    /*
     Transactions of the TrustSet type support additional values in the Flags field.
     This enum represents those options.
     */

    case tfSetAuth = 0x00010000
    /*
     Authorize the other party to hold
     `currency issued by this account <https:xrpl.org/tokens.html>`_.
     (No effect unless using the `asfRequireAuth AccountSet flag
     <https://xrpl.org/accountset.html#accountset-flags>`_.) Cannot be unset.
     */

    case tfSetNoRipple = 0x00020000
    /*
     Enable the No Ripple flag, which blocks
     `rippling <https://xrpl.org/rippling.html>`_ between two trust
     lines of the same currency if this flag is enabled on both.
     */

    case tfClearNoRipple = 0x00040000
    // Disable the No Ripple flag, allowing rippling on this trust line.

    case tfSetFreeze = 0x00100000
    // Freeze the trust line.

    case tfClearFreeze = 0x00200000
    // Unfreeze the trust line.
}

// public struct TrustSetFlagsInterface: GlobalFlags {
public struct TrustSetFlagsInterface {
    /**
     * Authorize the other party to hold currency issued by this account. (No
     * effect unless using the asfRequireAuth AccountSet flag.) Cannot be unset.
     */
    public let tfSetfAuth: Bool?
    /**
     * Enable the No Ripple flag, which blocks rippling between two trust lines
     * of the same currency if this flag is enabled on both.
     */
    public let tfSetNoRipple: Bool?
    /** Disable the No Ripple flag, allowing rippling on this trust line. */
    public let tfClearNoRipple: Bool?
    /** Freeze the trust line. */
    public let tfSetFreeze: Bool?
    /** Unfreeze the trust line. */
    public let tfClearFreeze: Bool?
}

public class TrustSet: BaseTransaction {
    /*
     Represents a TrustSet transaction on the XRP Ledger.
     Creates or modifies a trust line linking two accounts.
     `See TrustSet <https://xrpl.org/trustset.html>`_
     */

    public var limitAmount: IssuedCurrencyAmount
    /*
     This field is required.
     :meta hide-value:
     */

    public var qualityIn: Int?

    public var qualityOut: Int?

    enum CodingKeys: String, CodingKey {
        case limitAmount = "LimitAmount"
        case qualityIn = "QualityIn"
        case qualityOut = "QualityOut"
    }

    public init(
        limitAmount: IssuedCurrencyAmount,
        qualityIn: Int? = nil,
        qualityOut: Int? = nil,
        flags: TrustSetFlagsInterface
    ) {
        self.limitAmount = limitAmount
        self.qualityIn = qualityIn
        self.qualityOut = qualityOut
        super.init(account: "", transactionType: "TrustSet")
    }

    public override init(json: [String: AnyObject]) throws {
        let decoder: JSONDecoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(TrustSet.self, from: data)
        self.limitAmount = decoded.limitAmount
        self.qualityIn = decoded.qualityIn
        self.qualityOut = decoded.qualityOut
        try super.init(json: json)
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        limitAmount = try values.decode(IssuedCurrencyAmount.self, forKey: .limitAmount)
        qualityIn = try values.decodeIfPresent(Int.self, forKey: .qualityIn)
        qualityOut = try values.decodeIfPresent(Int.self, forKey: .qualityOut)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(limitAmount, forKey: .limitAmount)
        if let qualityIn = qualityIn { try values.encode(qualityIn, forKey: .qualityIn) }
        if let qualityOut = qualityOut { try values.encode(qualityOut, forKey: .qualityOut) }
    }
}

/**
 * Verify the form and type of a TrustSet at runtime.
 *
 * @param tx - A TrustSet Transaction.
 * @throws When the TrustSet is malformed.
 */
public func validateTrustSet(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["LimitAmount"] == nil {
        throw ValidationError.decoding("TrustSet: missing field LimitAmount")
    }

    if !isAmount(amount: tx["LimitAmount"] as Any) {
        throw ValidationError.decoding("TrustSet: invalid LimitAmount")
    }

    if tx["QualityIn"] != nil && !(tx["QualityIn"] is Int) {
        throw ValidationError.decoding("TrustSet: QualityIn must be a number")
    }

    if tx["QualityOut"] != nil && !(tx["QualityOut"] is Int) {
        throw ValidationError.decoding("TrustSet: QualityOut must be a number")
    }
}
