//
//  AccountSet.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/10/20.
//  Updated by Denis Angell on 6/4/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/accountSet.ts

let _MAX_TRANSFER_RATE: Int = 2000000000
let _MIN_TRANSFER_RATE: Int = 1000000000
let _SPECIAL_CASE_TRANFER_RATE: Int = 0

let _MIN_TICK_SIZE: Int = 3
let _MAX_TICK_SIZE: Int = 15
let _DISABLE_TICK_SIZE: Int = 0

let _MAX_DOMAIN_LENGTH: Int = 256

public enum AccountSetAsfFlags: Int, Codable {
    /*
    There are several options which can be either enabled or disabled for an account.
    Account options are represented by different types of flags depending on the
    situation. The AccountSet transaction type has several "AccountSet Flags" (prefixed
    `asf`) that can enable an option when passed as the SetFlag parameter, or disable
    an option when passed as the ClearFlag parameter. This enum represents those
    options.
    `See AccountSet Flags <https://xrpl.org/accountset.html#accountset-flags>`_
    */
    case asfAccountTxId = 5
    /*
    Track the ID of this account"s most recent transaction. Required for
    `AccountTxnID <https://xrpl.org/transaction-common-fields.html#accounttxnid>`_
    */
    case asfDefaultRipple = 8
    /*
    Enable `rippling
    <https://xrpl.org/rippling.html>`_ on this account"s trust lines by default.
    */
    case asfDepositAuth = 9
    /*
    Enable `Deposit Authorization
    <https://xrpl.org/depositauth.html>`_ on this account.
    */
    case asfDisableMaster = 4
    /*
    Disallow use of the master key pair. Can only be enabled if the account has
    configured another way to sign transactions, such as a `Regular Key
    <https://xrpl.org/cryptographic-keys.html>`_ or a `Signer List
    <https://xrpl.org/multi-signing.html>`_.
    */
    case asfDisallowXrp = 3
    /* XRP should not be sent to this account. (Enforced by client applications)*/
    case asfGlobalFreeze = 7
    /*
    `Freeze
    <https://xrpl.org/freezes.html>`_ all assets issued by this account.
    */
    case asfNoFreeze = 6
    /*
    Permanently give up the ability to `freeze individual trust lines or disable
    Global Freeze <https://xrpl.org/freezes.html>`_. This flag can never be disabled
    after being enabled.
    */
    case asfRequirAuth = 2
    /*
    Require authorization for users to hold balances issued by this address. Can
    only be enabled if the address has no trust lines connected to it.
    */
    case asfRequireDest = 1
    /*Require a destination tag to send transactions to this account.*/
    case asfAuthorizedMinter = 10
    /*Allow another account to mint and burn tokens on behalf of this account.*/
    
    static func all() -> [Int] {
        return [
            AccountSetAsfFlags.asfAccountTxId.rawValue
        ]
    }
}

public class AccountSet: BaseTransaction {
    /*
    Represents an `AccountSet transaction <https://xrpl.org/accountset.html>`_,
    which modifies the properties of an account in the XRP Ledger.
    */

    public var clearFlag: AccountSetAsfFlags?
    /*
    Disable a specific `AccountSet Flag
    <https://xrpl.org/accountset.html#accountset-flags>`_
    */

    public var setFlag: AccountSetAsfFlags?
    /*
    Enable a specific `AccountSet Flag
    <https://xrpl.org/accountset.html#accountset-flags>`_
    */

    public var domain: String?
    /*
    Set the DNS domain of the account owner. Must be hex-encoded. You can
    use `xrpl.utils.str_to_hex` to convert a UTF-8 string to hex.
    */

    public var emailHash: String?
    /*
    Set the MD5 Hash to be used for generating an avatar image for this
    account.
    */

    public var messageKey: Int?
    // Set a public key for sending encrypted messages to this account.

    public var transferRate: Int?
    /*
    Set the transfer fee to use for tokens issued by this account. See
    `TransferRate <https://xrpl.org/accountset.html#transferrate>`_ for
    details.
    */

    public var tickSize: Int?
    /*
    Set the tick size to use when trading tokens issued by this account in
    the decentralized exchange. See `Tick Size
    <https://xrpl.org/ticksize.html>`_ for details.
    */

    public var nfTokenMinter: String?
    /*
    Sets an alternate account that is allowed to mint NFTokens on this
    account"s behalf using NFTokenMint"s `Issuer` field. If set, you must
    also set the AccountSetFlag.ASF_AUTHORIZED_NFTOKEN_MINTER flag.
    */
    
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
        wallet: Wallet,
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
    
    public override init(json: [String: AnyObject]) throws {
        let decoder: JSONDecoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let r = try decoder.decode(AccountSet.self, from: data)
        self.clearFlag = r.clearFlag
        self.setFlag = r.setFlag
        self.domain = r.domain
        self.emailHash = r.emailHash
        self.messageKey = r.messageKey
        self.transferRate = r.transferRate
        self.tickSize = r.tickSize
        self.nfTokenMinter = r.nfTokenMinter
        try super.init(json: json)
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        clearFlag = try? values.decode(AccountSetAsfFlags.self, forKey: .clearFlag)
        setFlag = try? values.decode(AccountSetAsfFlags.self, forKey: .setFlag)
        domain = try? values.decode(String.self, forKey: .domain)
        emailHash = try? values.decode(String.self, forKey: .emailHash)
        transferRate = try? values.decode(Int.self, forKey: .transferRate)
        tickSize = try? values.decode(Int.self, forKey: .tickSize)
        nfTokenMinter = try? values.decode(String.self, forKey: .nfTokenMinter)
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
 * Verify the form and type of an AccountDelete at runtime.
 *
 * @param tx - An AccountDelete Transaction.
 * @throws When the AccountDelete is Malformed.
 */
public func validateAccountSet(tx: [String: AnyObject]) throws -> Void {
    try validateBaseTransaction(common: tx)
    
    if tx["ClearFlag"] != nil {
        print("NOT NIL")
        guard let _ = tx["ClearFlag"] as? Int else {
            throw XrplError.validation("AccountSet: invalid ClearFlag")
        }
        // TODO:
    }
    
    if tx["SetFlag"] != nil {
        guard let _ = tx["SetFlag"] as? Int else {
            throw XrplError.validation("AccountSet: invalid SetFlag")
        }
        // TODO:
    }
    
    if tx["Domain"] != nil, !(tx["Domain"] is String) {
        throw XrplError.validation("AccountSet: invalid Domain")
    }
    
    if tx["EmailHash"] != nil, !(tx["EmailHash"] is String) {
        throw XrplError.validation("AccountSet: invalid EmailHash")
    }
    
    if tx["MessageKey"] != nil, !(tx["MessageKey"] is String) {
        throw XrplError.validation("AccountSet: invalid MessageKey")
    }
    
    if tx["TransferRate"] != nil, !(tx["TransferRate"] is Int) {
        throw XrplError.validation("AccountSet: invalid TransferRate")
    }
    
    if tx["TickSize"] != nil {
        guard let tickSize = tx["TickSize"] as? Int, tickSize != 0, tickSize < _MIN_TICK_SIZE || tickSize > _MAX_TICK_SIZE else {
            throw XrplError.validation("AccountSet: invalid TickSize")
        }
        throw XrplError.validation("AccountSet: invalid Tick_MAX_TICK_SIZESize")
    }
}
