//
//  Common.swift
//  
//
//  Created by Denis Angell on 8/1/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/common.ts

import Foundation

let MEMO_SIZE: Int = 3

//func isMemo(obj: [ String: AnyObject? ]) -> Bool {
//    if (obj["Memo"] == nil) {
//        return false
//    }
//    // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Only used by JS
//    let memo = obj["Memo"] as? [String: AnyObject]
//    let size = memo.length
//    let validData = memo.MemoData == nil || memo.MemoData is String
//    let validFormat = memo.MemoFormat == nil || memo.MemoData is String
//    let validType = memo.MemoType == nil || memo.MemoData is String
//
//    return (
//        size >= 1 &&
//        size <= MEMO_SIZE &&
//        validData &&
//        validFormat &&
//        validType &&
//        onlyHasFields(memo, ["MemoFormat", "MemoData", "MemoType"])
//    )
//}

let SIGNER_SIZE: Int = 3

//func isSigner(obj: AnyObject) -> Bool {
//    // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Only used by JS
//    let signerWrapper = obj as? [String, AnyObject]
//
//    if (signerWrapper.Signer == nil) {
//        return false
//    }
//    // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Only used by JS and Signer is previously unknown
//    let signer = signerWrapper.Signer as Record<string, unknown>
//    return (
//        signer.length === SIGNER_SIZE &&
//        signer.Account is String &&
//        signer.TxnSignature is String &&
//        signer.SigningPubKey is String
//    )
//}

let ISSUED_CURRENCY_SIZE: Int = 3

func isRecord(value: Any) -> Bool {
    guard value is [String: AnyObject] else {
        return false
    }
    return true
}

/**
 * Verify the form and type of an IssuedCurrencyAmount at runtime.
 *
 * @param input - The input to check the form and type of.
 * @returns Whether the IssuedCurrencyAmount is malformed.
 */
public func isIssuedCurrency(input: Any) -> Bool {
    guard let input = input as? [String: AnyObject] else {
        return false
    }
    guard input.count == ISSUED_CURRENCY_SIZE else {
        return false
    }
    guard input["value"] is String else {
        return false
    }
    guard input["issuer"] is String else {
        return false
    }
    guard input["currency"] is String else {
        return false
    }
    return true
}

/**
 * Verify the form and type of an Amount at runtime.
 *
 * @param amount - The object to check the form and type of.
 * @returns Whether the Amount is malformed.
 */
public func isAmount(amount: Any) -> Bool {
    if amount is String {
        return true
    }
    return isIssuedCurrency(input: amount)
}

//// eslint-disable-next-line @typescript-eslint/no-empty-interface -- no global flags right now, so this is fine
//export interface GlobalFlags {}

/**
 * Every transaction has the same set of common fields.
 */
public class BaseTransaction: Codable {
    /** The unique address of the account that initiated the transaction. */
    public var account: String
    /**
     * The type of transaction. Valid types include: `Payment`, `OfferCreate`,
     * `SignerListSet`, `EscrowCreate`, `EscrowFinish`, `EscrowCancel`,
     * `PaymentChannelCreate`, `PaymentChannelFund`, `PaymentChannelClaim`, and
     * `DepositPreauth`.
     */
    public var transactionType: String
    /**
     * Integer amount of XRP, in drops, to be destroyed as a cost for
     * distributing this transaction to the network. Some transaction types have
     * different minimum requirements.
     */
    public var fee: String?
    /**
     * The sequence number of the account sending the transaction. A transaction
     * is only valid if the Sequence number is exactly 1 greater than the previous
     * transaction from the same account. The special case 0 means the transaction
     * is using a Ticket instead.
     */
    public var sequence: Int?
    /**
     * Hash value identifying another transaction. If provided, this transaction
     * is only valid if the sending account's previously-sent transaction matches
     * the provided hash.
     */
    public var accountTxnId: String?
    /** Set of bit-flags for this transaction. */
    //    public let Flags: Int? | GlobalFlags
    public var flags: Int?
    /**
     * Highest ledger index this transaction can appear in. Specifying this field
     * places a strict upper limit on how long the transaction can wait to be
     * validated or rejected.
     */
    public var lastLedgerSequence: Int?
    /**
     * Additional arbitrary information used to identify this transaction.
     */
    public var memos: [Memo]?
    /**
     * Array of objects that represent a multi-signature which authorizes this
     * transaction.
     */
    public var signers: [Signer]?
    /**
     * Arbitrary integer used to identify the reason for this payment, or a sender
     * on whose behalf this transaction is made. Conventionally, a refund should
     * specify the initial payment's SourceTag as the refund payment's
     * DestinationTag.
     */
    public var sourceTag: Int?
    /**
     * Hex representation of the public key that corresponds to the private key
     * used to sign this transaction. If an empty string, indicates a
     * multi-signature is present in the Signers field instead.
     */
    public var signingPubKey: String?
    /**
     * The sequence number of the ticket to use in place of a Sequence number. If
     * this is provided, Sequence must be 0. Cannot be used with AccountTxnID.
     */
    public var ticketSequence: Int?
    /**
     * The signature that verifies this transaction as originating from the
     * account it says it is from.
     */
    public var txnSignature: String?
    
    public init(
        // Required
        account: String,
        transactionType: String,
        // Optional
        fee: String? = nil,
        sequence: Int? = nil,
        accountTxnId: String? = nil,
        flags: Int? = nil,
        lastLedgerSequence: Int? = nil,
        memos: [Memo]? = nil,
        signers: [Signer]? = nil,
        sourceTag: Int? = nil,
        signingPubKey: String? = nil,
        ticketSequence: Int? = nil,
        txnSignature: String? = nil
    ) {
        // Required
        self.account = account
        self.transactionType = transactionType
        // Optional
        self.fee = fee
        self.sequence = sequence
        self.accountTxnId = accountTxnId
        self.flags = flags
        self.lastLedgerSequence = lastLedgerSequence
        self.memos = memos
        self.signers = signers
        self.sourceTag = sourceTag
        self.signingPubKey = signingPubKey
        self.ticketSequence = ticketSequence
        self.txnSignature = txnSignature
    }
    
    enum CodingKeys: String, CodingKey {
        case account = "Account"
        case transactionType = "TransactionType"
        case fee = "Fee"
        case sequence = "Sequence"
        case accountTxnId = "AccountTxnID"
        case flags = "Flags"
        case lastLedgerSequence = "LastLedgerSequence"
        case memos = "Memos"
        case signers = "Signers"
        case sourceTag = "SourceTag"
        case signingPubKey = "SigningPubKey"
        case ticketSequence = "TicketSequence"
        case txnSignature = "TxnSignature"
    }
    
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        transactionType = try values.decode(String.self, forKey: .transactionType)
        fee = try? values.decode(String.self, forKey: .fee)
        sequence = try? values.decode(Int.self, forKey: .sequence)
        accountTxnId = try? values.decode(String.self, forKey: .accountTxnId)
        flags = try? values.decode(Int.self, forKey: .flags)
        lastLedgerSequence = try? values.decode(Int.self, forKey: .lastLedgerSequence)
        memos = try? values.decode([Memo].self, forKey: .memos)
        signers = try? values.decode([Signer].self, forKey: .signers)
        sourceTag = try? values.decode(Int.self, forKey: .sourceTag)
        signingPubKey = try? values.decode(String.self, forKey: .signingPubKey)
        ticketSequence = try? values.decode(Int.self, forKey: .ticketSequence)
        txnSignature = try? values.decode(String.self, forKey: .txnSignature)
    }
    
    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(account, forKey: .account)
        try values.encode(transactionType, forKey: .transactionType)
        if let fee = fee { try values.encode(fee, forKey: .fee) }
        if let sequence = sequence { try values.encode(sequence, forKey: .sequence) }
        if let accountTxnId = accountTxnId { try values.encode(accountTxnId, forKey: .accountTxnId) }
        if let flags = flags { try values.encode(flags, forKey: .flags) }
        if let lastLedgerSequence = lastLedgerSequence { try values.encode(lastLedgerSequence, forKey: .lastLedgerSequence) }
        if let memos = memos { try values.encode(memos, forKey: .memos) }
        if let signers = signers { try values.encode(signers, forKey: .signers) }
        if let sourceTag = sourceTag { try values.encode(sourceTag, forKey: .sourceTag) }
        if let signingPubKey = signingPubKey { try values.encode(signingPubKey, forKey: .signingPubKey) }
        if let ticketSequence = ticketSequence { try values.encode(ticketSequence, forKey: .ticketSequence) }
        if let txnSignature = txnSignature { try values.encode(txnSignature, forKey: .txnSignature) }
    }
}

enum ValidationError: Error {
    case decoding(String)
}

/**
 * Verify the common fields of a transaction. The validate functionality will be
 * optional, and will check transaction form at runtime. This should be called
 * any time a transaction will be verified.
 *
 * @param common - An interface w/ common transaction fields.
 * @throws When the common param is malformed.
 */
public func validateBaseTransaction(common: [String: AnyObject]) throws -> Void {
    print("VALIDATE BASE TX")
    //  if (common.Account == nil) {
    //      throw ValidationError.decoding("BaseTransaction: missing field Account")
    //  }
    //
    //  if (typeof common.Account !== "string") {
    //    throw new ValidationError("BaseTransaction: Account not string")
    //  }
    //
    //  if (common.TransactionType === undefined) {
    //    throw new ValidationError("BaseTransaction: missing field TransactionType")
    //  }
    //
    //  if (typeof common.TransactionType !== "string") {
    //    throw new ValidationError("BaseTransaction: TransactionType not string")
    //  }
    //
    //  if (!TRANSACTION_TYPES.includes(common.TransactionType)) {
    //    throw new ValidationError("BaseTransaction: Unknown TransactionType")
    //  }
    //
    //  if (common.Fee !== undefined && typeof common.Fee !== "string") {
    //    throw new ValidationError("BaseTransaction: invalid Fee")
    //  }
    //
    //  if (common.Sequence !== undefined && typeof common.Sequence !== "number") {
    //    throw new ValidationError("BaseTransaction: invalid Sequence")
    //  }
    //
    //  if (
    //    common.AccountTxnID !== undefined &&
    //    typeof common.AccountTxnID !== "string"
    //  ) {
    //    throw new ValidationError("BaseTransaction: invalid AccountTxnID")
    //  }
    //
    //  if (
    //    common.LastLedgerSequence !== undefined &&
    //    typeof common.LastLedgerSequence !== "number"
    //  ) {
    //    throw new ValidationError("BaseTransaction: invalid LastLedgerSequence")
    //  }
    //
    //  // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Only used by JS
    //  const memos = common.Memos as Array<{ Memo?: unknown }> | undefined
    //  if (memos !== undefined && !memos.every(isMemo)) {
    //    throw new ValidationError("BaseTransaction: invalid Memos")
    //  }
    //
    //  // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Only used by JS
    //  const signers = common.Signers as Array<Record<string, unknown>> | undefined
    //
    //  if (
    //    signers !== undefined &&
    //    (signers.length === 0 || !signers.every(isSigner))
    //  ) {
    //    throw new ValidationError("BaseTransaction: invalid Signers")
    //  }
    //
    //  if (common.SourceTag !== undefined && typeof common.SourceTag !== "number") {
    //    throw new ValidationError("BaseTransaction: invalid SourceTag")
    //  }
    //
    //  if (
    //    common.SigningPubKey !== undefined &&
    //    typeof common.SigningPubKey !== "string"
    //  ) {
    //    throw new ValidationError("BaseTransaction: invalid SigningPubKey")
    //  }
    //
    //  if (
    //    common.TicketSequence !== undefined &&
    //    typeof common.TicketSequence !== "number"
    //  ) {
    //    throw new ValidationError("BaseTransaction: invalid TicketSequence")
    //  }
    //
    //  if (
    //    common.TxnSignature !== undefined &&
    //    typeof common.TxnSignature !== "string"
    //  ) {
    //    throw new ValidationError("BaseTransaction: invalid TxnSignature")
    //  }
}

/**
 * Parse the value of an amount, expressed either in XRP or as an Issued Currency, into a number.
 *
 * @param amount - An Amount to parse for its value.
 * @returns The parsed amount value, or NaN if the amount count not be parsed.
 */
public func parseAmountValue(amount: Any) -> Double? {
    if (!isAmount(amount: amount)) {
        return nil
    }
    if let amount = amount as? String {
        return Double(amount)
    }
    return amount as? Double
}
