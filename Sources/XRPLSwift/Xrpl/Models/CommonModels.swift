//
//  File.swift
//  
//
//  Created by Denis Angell on 7/26/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/common/index.ts

import Foundation

public enum AccountObjectType: String, Codable {
    case check
    case depositPreauth
    case escrow
    case offer
    case paymentChannel
    case signerList
    case ticket
    case state
    
    enum CodingKeys: String, CodingKey {
        case check = "check"
        case depositPreauth = "deposit_preauth"
        case escrow = "escrow"
        case offer = "offer"
        case paymentChannel = "paymentChannel"
        case signerList = "signerList"
        case ticket = "ticket"
        case state = "state"
    }
}

public enum rLedgerIndex: Codable {
    case string(String) // ('validated' | 'closed' | 'current')
    case number(Int)
}

extension rLedgerIndex {
    
    enum LedgerIndexCodingError: Error {
        case decoding(String)
    }
    
    public init(from decoder: Decoder) throws {
        if let value = try? String.init(from: decoder) {
            self = .string(value)
            return
        }
        if let value = try? Int.init(from: decoder) {
            self = .number(value)
            return
        }
        throw LedgerIndexCodingError.decoding("OOPS")
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .string(let string):
            try string.encode(to: encoder)
        case .number(let number):
            try number.encode(to: encoder)
        }
    }
}

struct XRP: Codable {
    var currency: String = "XRP"
}

protocol IssuedCurrency: Codable {
    var currency: String { get set }
    var issuer: String { get set }
}

enum rCurrency {
    case xrp (XRP)
    case issuedCurrency (IssuedCurrency)
}

public struct rIssuedCurrencyAmount: IssuedCurrency, Codable {
    public var currency: String
    public var issuer: String
    public var value: String
    
    enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case issuer = "issuer"
        case value = "value"
    }
}

enum AmountType {
    case string
    case ic
}

public enum rAmount: Codable {
    case string(String)
    case ic(rIssuedCurrencyAmount)
}

extension rAmount {
    
    enum rAmountCodingError: Error {
        case decoding(String)
    }
    
    public init(from decoder: Decoder) throws {
        print(decoder.self)
        if let value = try? String.init(from: decoder) {
            self = .string(value)
            return
        }
        if let value = try? rIssuedCurrencyAmount.init(from: decoder) {
            self = .ic(value)
            return
        }
        throw rAmountCodingError.decoding("OOPS")
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .string(let string):
            try string.encode(to: encoder)
        case .ic(let ic):
            try ic.encode(to: encoder)
        }
    }
}

public class BaseSigner: Codable {
    public let account: String
    public let txnSignature: String
    public let signingPubKey: String
    
    enum CodingKeys: String, CodingKey {
        case account = "Account"
        case txnSignature = "TxnSignature"
        case signingPubKey = "SigningPubKey"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        txnSignature = try values.decode(String.self, forKey: .txnSignature)
        signingPubKey = try values.decode(String.self, forKey: .signingPubKey)
    }
}

public class Signer: Codable {
    public let Signer: BaseSigner
}

public class BaseMemo: Codable {
    public let memoData: String
    public let memoType: String
    public let memoFormat: String
    
    enum CodingKeys: String, CodingKey {
        case memoData = "MemoData"
        case memoType = "MemoType"
        case memoFormat = "MemoFormat"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        memoData = try values.decode(String.self, forKey: .memoData)
        memoType = try values.decode(String.self, forKey: .memoType)
        memoFormat = try values.decode(String.self, forKey: .memoFormat)
    }
}

public class Memo: Codable {
    public let Memo: BaseMemo
}

//export type StreamType =
//  | 'consensus'
//  | 'ledger'
//  | 'manifests'
//  | 'peer_status'
//  | 'transactions'
//  | 'transactions_proposed'
//  | 'server'
//  | 'validations'
//
public struct PathStep: Codable {
    public var account: String?
    public var currency: String?
    public var issuer: String
}

public typealias Path = [PathStep]

//export interface SignerEntry {
//  SignerEntry: {
//    Account: string
//    SignerWeight: number
//  }
//}
//
///**
// * This information is added to Transactions in request responses, but is not part
// * of the canonical Transaction information on ledger. These fields are denoted with
// * lowercase letters to indicate this in the rippled responses.
// */
//export interface ResponseOnlyTxInfo {
//  /**
//   * The date/time when this transaction was included in a validated ledger.
//   */
//  date?: number
//  /**
//   * An identifying hash value unique to this transaction, as a hex string.
//   */
//  hash?: string
//  /**
//   * The sequence number of the ledger that included this transaction.
//   */
//  ledger_index?: number
//}
//
///**
// * One offer that might be returned from either an {@link NFTBuyOffersRequest}
// * or an {@link NFTSellOffersRequest}.
// *
// * @category Responses
// */
//export interface NFTOffer {
//  amount: Amount
//  flags: number
//  nft_offer_index: string
//  owner: string
//  destination?: string
//  expiration?: number
//}



import AnyCodable


public struct XRPLWebSocketResponse: Codable {
    public let id: String
    public let status: String
    public let type: String
    private let _result: AnyCodable
    public var result: [String:AnyObject] {
        return _result.value as! [String:AnyObject]
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case type
        case _result = "result"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        status = try values.decode(String.self, forKey: .status)
        type = try values.decode(String.self, forKey: .type)
        _result = try values.decode(AnyCodable.self, forKey: ._result)
    }
}

public struct JsonRpcResponse<T> {
    public var result: T
}
