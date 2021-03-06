//
//  AccountSet.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/10/20.
//  Updated by Denis Angell on 6/4/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/account_set.py

let _MAX_TRANSFER_RATE: Int = 2000000000
let _MIN_TRANSFER_RATE: Int = 1000000000
let _SPECIAL_CASE_TRANFER_RATE: Int = 0

let _MIN_TICK_SIZE: Int = 3
let _MAX_TICK_SIZE: Int = 15
let _DISABLE_TICK_SIZE: Int = 0

let _MAX_DOMAIN_LENGTH: Int = 256

public enum AccountSetFlag: UInt32 {
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
    Track the ID of this account's most recent transaction. Required for
    `AccountTxnID <https://xrpl.org/transaction-common-fields.html#accounttxnid>`_
    */
    case asfDefaultRipple = 8
    /*
    Enable `rippling
    <https://xrpl.org/rippling.html>`_ on this account's trust lines by default.
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
}

public class AccountSet: Transaction {
    /*
    Represents an `AccountSet transaction <https://xrpl.org/accountset.html>`_,
    which modifies the properties of an account in the XRP Ledger.
    */
    
    public var clearFlag: AccountSetFlag?
    /*
    Disable a specific `AccountSet Flag
    <https://xrpl.org/accountset.html#accountset-flags>`_
    */
    
    public var setFlag: AccountSetFlag?
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
    account's behalf using NFTokenMint's `Issuer` field. If set, you must
    also set the AccountSetFlag.ASF_AUTHORIZED_NFTOKEN_MINTER flag.
    */

    public init(
        wallet: Wallet,
        clearFlag: AccountSetFlag?,
        setFlag: AccountSetFlag?,
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
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        var _fields: [String:Any] = [
            "TransactionType" : "AccountSet"
        ]
        if let clearFlag = clearFlag {
            _fields["ClearFlag"] = clearFlag.rawValue
        }
        if let setFlag = setFlag {
            _fields["SetFlag"] = setFlag.rawValue
        }
        
        // TODO: Hex
        if let domain = domain {
            _fields["Domain"] = domain
        }
        
        // TODO: Hex
        if let emailHash = emailHash {
            _fields["EmailHash"] = emailHash
        }
        
        if let transferRate = transferRate {
            _fields["TransferRate"] = transferRate
        }
        
        if let tickSize = tickSize {
            _fields["TickSize"] = tickSize
        }
        
        if let nfTokenMinter = nfTokenMinter {
            _fields["Minter"] = nfTokenMinter
        }
        
        super.init(wallet: wallet, fields: _fields)
    }
    
    // TODO:
    func _get_errors() -> [String: String?] {
        return [
            "tick_size": self._get_tick_size_error(),
            "transfer_rate": self._get_transfer_rate_error(),
            "domain": self._get_domain_error(),
            "clear_flag": self._get_clear_flag_error(),
            "nftoken_minter": self._get_nftoken_minter_error(),
        ]
    }

    func _get_tick_size_error() -> String? {
        if self.tickSize == nil {
            return nil
        }
        if self.tickSize! > _MAX_TICK_SIZE {
            return "`tickSize` is above \(_MAX_TICK_SIZE)."
        }
        if self.tickSize! < _MIN_TICK_SIZE && self.tickSize! != _DISABLE_TICK_SIZE {
            return "`tickSize` is below \(_MIN_TICK_SIZE)."
        }
        return nil
    }

    func _get_transfer_rate_error() -> String? {
        if self.transferRate == nil {
            return nil
        }
        if self.transferRate! > _MAX_TRANSFER_RATE {
                return "`transfer_rate` is above \(_MAX_TRANSFER_RATE)."
        }
        if self.transferRate! < _MIN_TRANSFER_RATE && self.transferRate != _SPECIAL_CASE_TRANFER_RATE {
            return "`transfer_rate` is below \(_MIN_TRANSFER_RATE)."
        }
        return nil
    }

    func _get_domain_error() -> String? {
        if self.domain != nil && self.domain?.lowercased() != self.domain {
            return "Domain \(self.domain ?? "") is not lowercase"
        }
        if self.domain != nil && self.domain!.count > _MAX_DOMAIN_LENGTH {
            return "Must not be longer than \(_MAX_DOMAIN_LENGTH) characters"
        }
        return nil
    }

    func _get_clear_flag_error() -> String? {
        if self.clearFlag != nil && self.clearFlag == self.setFlag {
            return "Must not be equal to the setFlag"
        }
        return nil
    }

    func _get_nftoken_minter_error() -> String? {
        if self.setFlag != AccountSetFlag.asfAuthorizedMinter && self.nfTokenMinter != nil {
            return "Will not set the minter unless AccountSetFlag.ASF_AUTHORIZED_NFTOKEN_MINTER is set"
        }
        if self.setFlag == AccountSetFlag.asfAuthorizedMinter && self.nfTokenMinter == nil {
            return "Must be present if AccountSetFlag.ASF_AUTHORIZED_NFTOKEN_MINTER is set"
        }
        if self.clearFlag == AccountSetFlag.asfAuthorizedMinter && self.nfTokenMinter != nil {
            return "Must not be present if AccountSetFlag.ASF_AUTHORIZED_NFTOKEN_MINTER is unset using clearFlag"
        }
        return nil
    }
}
