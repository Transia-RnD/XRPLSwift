//
//  AccountSet.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/10/20.
//  Updated by Denis Angell on 6/4/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/accountSet.ts

// swiftlint:disable:next identifier_name
let _MAX_TRANSFER_RATE: Int = 2000000000
// swiftlint:disable:next identifier_name
let _MIN_TRANSFER_RATE: Int = 1000000000
// swiftlint:disable:next identifier_name
let _SPECIAL_CASE_TRANFER_RATE: Int = 0
// swiftlint:disable:next identifier_name
let _MIN_TICK_SIZE: Int = 3
// swiftlint:disable:next identifier_name
let _MAX_TICK_SIZE: Int = 15
// swiftlint:disable:next identifier_name
let _DISABLE_TICK_SIZE: Int = 0
// swiftlint:disable:next identifier_name
let _MAX_DOMAIN_LENGTH: Int = 256

/**
 There are several options which can be either enabled or disabled for an account.
 Account options are represented by different types of flags depending on the
 situation. The AccountSet transaction type has several "AccountSet Flags" (prefixed
 `asf`) that can enable an option when passed as the SetFlag parameter, or disable
 an option when passed as the ClearFlag parameter. This enum represents those
 options.
 [See AccountSet Flags](https://xrpl.org/accountset.html#accountset-flags)
 */
public enum AccountSetAsfFlags: Int, Codable, CaseIterable {
    /**
     Track the ID of this account"s most recent transaction. Required for
     [AccountTxnID](https://xrpl.org/transaction-common-fields.html#accounttxnid)
     */
    case asfAccountTxId = 5

    /**
     Enable  [rippling](https://xrpl.org/rippling.html) on this account"s trust lines by default.
     */
    case asfDefaultRipple = 8

    /**
     Enable [Deposit Authorization](https://xrpl.org/depositauth.html) on this account.
     */
    case asfDepositAuth = 9

    /**
     Disallow use of the master key pair. Can only be enabled if the account has
     configured another way to sign transactions, such as a [Regular Key](https://xrpl.org/cryptographic-keys.html) or a [Signer List](https://xrpl.org/multi-signing.html).
     */
    case asfDisableMaster = 4

    /// XRP should not be sent to this account. (Enforced by client applications)
    case asfDisallowXrp = 3
    /**
     [Freeze](https://xrpl.org/freezes.html) all assets issued by this account.
     */
    case asfGlobalFreeze = 7

    /**
     Permanently give up the ability to freeze individual trust lines or disable [Global Freeze](https://xrpl.org/freezes.html)
     This flag can never be disabled
     after being enabled.
     */
    case asfNoFreeze = 6
    /**
     Require authorization for users to hold balances issued by this address. Can
     only be enabled if the address has no trust lines connected to it.
     */
    case asfRequirAuth = 2
    /// Require a destination tag to send transactions to this account.
    case asfRequireDest = 1
    /// Allow another account to mint and burn tokens on behalf of this account.
    case asfAuthorizedMinter = 10
}

enum AccountSetTfFlags: Int, Codable, CaseIterable {
    /// The same as SetFlag: asfRequireDest.
    case tfRequireDestTag = 0x00010000
    /// The same as ClearFlag: asfRequireDest.
    case tfOptionalDestTag = 0x00020000
    /// The same as SetFlag: asfRequireAuth.
    case tfRequireAuth = 0x00040000
    /// The same as ClearFlag: asfRequireAuth.
    case tfOptionalAuth = 0x00080000
    /// The same as SetFlag: asfDisallowXRP.
    case tfDisallowXRP = 0x00100000
    /// The same as ClearFlag: asfDisallowXRP.
    case tfAllowXRP = 0x00200000
}

extension Array where Element == AccountSetTfFlags {
    var interface: [AccountSetTfFlags: Bool] {
        var flags: [AccountSetTfFlags: Bool] = [:]
        for flag in self {
            if flag == .tfRequireDestTag {
                flags[flag] = true
            }
            if flag == .tfOptionalDestTag {
                flags[flag] = true
            }
            if flag == .tfRequireAuth {
                flags[flag] = true
            }
            if flag == .tfOptionalAuth {
                flags[flag] = true
            }
            if flag == .tfDisallowXRP {
                flags[flag] = true
            }
            if flag == .tfAllowXRP {
                flags[flag] = true
            }
        }
        return flags
    }
}

/**
 Represents an [AccountSet](https://xrpl.org/accountset.html) transaction,
 which modifies the properties of an account in the XRP Ledger.
 */
public class AccountSet: BaseTransaction {
    /**
     Disable a specific [AccountSet Flag](https://xrpl.org/accountset.html#accountset-flags)
     */
    public var clearFlag: AccountSetAsfFlags?

    /**
     Enable a specific [AccountSet Flag](https://xrpl.org/accountset.html#accountset-flags)
     */
    public var setFlag: AccountSetAsfFlags?

    /**
     Set the DNS domain of the account owner. Must be hex-encoded. You can
     use `strToHex` to convert a UTF-8 string to hex.
     */
    public var domain: String?

    /**
     Set the MD5 Hash to be used for generating an avatar image for this
     account.
     */
    public var emailHash: String?

    /// Set a public key for sending encrypted messages to this account.
    public var messageKey: Int?

    /**
     Set the transfer fee to use for tokens issued by this account. See
     [TransferRate](https://xrpl.org/accountset.html#transferrate) for
     details.
     */
    public var transferRate: Int?

    /**
     Set the tick size to use when trading tokens issued by this account in
     the decentralized exchange. See [Tick Size](https://xrpl.org/ticksize.html) for details.
     */
    public var tickSize: Int?

    /**
     Sets an alternate account that is allowed to mint NFTokens on this
     account"s behalf using NFTokenMint"s `Issuer` field. If set, you must
     also set the AccountSetFlag.ASF_AUTHORIZED_NFTOKEN_MINTER flag.
     */
    public var nfTokenMinter: String?

    enum CodingKeys: String, CodingKey {
        case clearFlag = "ClearFlag"
        case setFlag = "SetFlag"
        case domain = "Domain"
        case emailHash = "EmailHash"
        case transferRate = "TransferRate"
        case tickSize = "TickSize"
        case nfTokenMinter = "NFTokenMinter"
    }

    public init(
        clearFlag: AccountSetAsfFlags?,
        setFlag: AccountSetAsfFlags?,
        domain: String?,
        emailHash: String?,
        messageKey: Int?,
        transferRate: Int?,
        tickSize: Int?,
        nfTokenMinter: String?
    ) {
        self.clearFlag = clearFlag
        self.setFlag = setFlag
        self.domain = domain
        self.emailHash = emailHash
        self.messageKey = messageKey
        self.transferRate = transferRate
        self.tickSize = tickSize
        self.nfTokenMinter = nfTokenMinter
        super.init(account: "", transactionType: "AccountSet")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(AccountSet.self, from: data)
        self.clearFlag = decoded.clearFlag
        self.setFlag = decoded.setFlag
        self.domain = decoded.domain
        self.emailHash = decoded.emailHash
        self.messageKey = decoded.messageKey
        self.transferRate = decoded.transferRate
        self.tickSize = decoded.tickSize
        self.nfTokenMinter = decoded.nfTokenMinter
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        clearFlag = try values.decodeIfPresent(AccountSetAsfFlags.self, forKey: .clearFlag)
        setFlag = try values.decodeIfPresent(AccountSetAsfFlags.self, forKey: .setFlag)
        domain = try values.decodeIfPresent(String.self, forKey: .domain)
        emailHash = try values.decodeIfPresent(String.self, forKey: .emailHash)
        transferRate = try values.decodeIfPresent(Int.self, forKey: .transferRate)
        tickSize = try values.decodeIfPresent(Int.self, forKey: .tickSize)
        nfTokenMinter = try values.decodeIfPresent(String.self, forKey: .nfTokenMinter)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        if let clearFlag = clearFlag { try values.encode(clearFlag.rawValue, forKey: .clearFlag) }
        if let setFlag = setFlag { try values.encode(setFlag.rawValue, forKey: .setFlag) }
        if let domain = domain { try values.encode(domain, forKey: .domain) }
        if let emailHash = emailHash { try values.encode(emailHash, forKey: .emailHash) }
        if let transferRate = transferRate { try values.encode(transferRate, forKey: .transferRate) }
        if let tickSize = tickSize { try values.encode(tickSize, forKey: .tickSize) }
        if let nfTokenMinter = nfTokenMinter { try values.encode(nfTokenMinter, forKey: .nfTokenMinter) }
    }
}

/**
 Verify the form and type of an AccountSet at runtime.
 - parameters:
 - tx: An AccountSet Transaction.
 - throws:
 When the AccountSet is Malformed.
 */
public func validateAccountSet(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["ClearFlag"] != nil {
        guard let _ = tx["ClearFlag"] as? Int else {
            throw ValidationError("AccountSet: invalid ClearFlag")
        }
        // TODO: review this
    }

    if tx["SetFlag"] != nil {
        guard let _ = tx["SetFlag"] as? Int else {
            throw ValidationError("AccountSet: invalid SetFlag")
        }
        // TODO: review this
    }

    if tx["Domain"] != nil, !(tx["Domain"] is String) {
        throw ValidationError("AccountSet: invalid Domain")
    }

    if tx["EmailHash"] != nil, !(tx["EmailHash"] is String) {
        throw ValidationError("AccountSet: invalid EmailHash")
    }

    if tx["MessageKey"] != nil, !(tx["MessageKey"] is String) {
        throw ValidationError("AccountSet: invalid MessageKey")
    }

    if tx["TransferRate"] != nil, !(tx["TransferRate"] is Int) {
        throw ValidationError("AccountSet: invalid TransferRate")
    }

    if tx["TickSize"] != nil {
        guard let tickSize = tx["TickSize"] as? Int, tickSize != 0, tickSize < _MIN_TICK_SIZE || tickSize > _MAX_TICK_SIZE else {
            throw ValidationError("AccountSet: invalid TickSize")
        }
        throw ValidationError("AccountSet: invalid Tick_MAX_TICK_SIZESize")
    }
}
