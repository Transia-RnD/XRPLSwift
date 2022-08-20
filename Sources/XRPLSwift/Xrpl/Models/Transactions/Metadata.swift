//
//  Metadata.swift
//
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/metadata.ts

import Foundation

// import { Amount } from '../common'

public struct DirectoryNodeField: Codable {
    public var owner: String
    public var rootIndex: String
}

public struct PayChannelNodeField: Codable {
    public var account: String
    public var amount: String
    public var destination: String
    public var publicKey: String
    public var settleDelay: Int
}

public enum LedgerEntryType: Codable {
    case directory
    case paychannel
    case unknown
}

public enum NewField: Codable {
    case directory(DirectoryNodeField)
    case paychannel(PayChannelNodeField)
    case unknown
}

public struct CreatedNode: Codable {

    public var ledgerEntryType: LedgerEntryType
    public var ledgerIndex: String
    public var newFields: [NewField]?

}

public enum FinalField: Codable {
    case directory(DirectoryNodeField)
    case paychannel(PayChannelNodeField)
    case unknown
}

public struct ModifiedNode: Codable {
    public var ledgerEntryType: String
    public var ledgerIndex: String
    public var finalFields: [FinalField]?
    public var previousFields: [FinalField]?
    public var previoudTxnId: String?
    public var previoudTxnLgrSeq: Int?
}

public struct DeletedNode: Codable {
    public var ledgerEntryType: LedgerEntryType
    public var ledgerIndex: String
    public var finalFields: [FinalField]?

}

public enum Node: Codable {
    case modified(ModifiedNode)
    case created(CreatedNode)
    case deleted(DeletedNode)
}

extension Node {

    enum NodeCodingError: Error {
        case decoding(String)
    }

    public init(from decoder: Decoder) throws {
        if let value = try? ModifiedNode.init(from: decoder) {
            self = .modified(value)
            return
        }
        if let value = try? CreatedNode.init(from: decoder) {
            self = .created(value)
            return
        }
        if let value = try? DeletedNode.init(from: decoder) {
            self = .deleted(value)
            return
        }
        throw NodeCodingError.decoding("DENIS!!!")
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .modified(let value):
            try value.encode(to: encoder)
        case .created(let value):
            try value.encode(to: encoder)
        case .deleted(let value):
            try value.encode(to: encoder)
        }
    }
}

public class TransactionMetadata: Codable {
    public var affectedNodes: [Node]?
    public var deliveredAmount: Amount?
    public var transactionResult: String
    public var transactionIndex: Int

    init(
        affectedNodes: [Node]? = nil,
        transactionResult: String,
        transactionIndex: Int
    ) {
        self.affectedNodes = affectedNodes
        self.transactionResult = transactionResult
        self.transactionIndex = transactionIndex
    }
}
