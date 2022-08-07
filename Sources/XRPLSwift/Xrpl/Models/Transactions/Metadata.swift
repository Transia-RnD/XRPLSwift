//
//  Metadata.swift
//
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/metadata.ts

import Foundation


//import { Amount } from '../common'

public struct rDirectoryNodeField: Codable {
    public var owner: String
    public var rootIndex: String
}

public struct rPayChannelNodeField: Codable {
    public var account: String
    public var amount: String
    public var destination: String
    public var publicKey: String
    public var settleDelay: Int
}

public enum rLedgerEntryType: Codable {
    case directory
    case paychannel
    case unknown
}

public enum NewField: Codable {
    case directory(rDirectoryNodeField)
    case paychannel(rPayChannelNodeField)
    case unknown
}

public struct rCreatedNode: Codable {
    
    public var ledgerEntryType: rLedgerEntryType
    public var ledgerIndex: String
    public var newFields: [NewField]?
    
}

public enum rFinalField: Codable {
    case directory(rDirectoryNodeField)
    case paychannel(rPayChannelNodeField)
    case unknown
}

public struct rModifiedNode: Codable {
    public var ledgerEntryType: String
    public var ledgerIndex: String
    public var finalFields: [rFinalField]?
    public var previousFields: [rFinalField]?
    public var previoudTxnId: String?
    public var previoudTxnLgrSeq: Int?
}

public struct rDeletedNode: Codable {
    public var ledgerEntryType: rLedgerEntryType
    public var ledgerIndex: String
    public var finalFields: [rFinalField]?
    
}

public enum rNode: Codable {
    case modified(rModifiedNode)
    case created(rCreatedNode)
    case deleted(rDeletedNode)
}

extension rNode {
    
    enum NodeCodingError: Error {
        case decoding(String)
    }
    
    public init(from decoder: Decoder) throws {
        if let value = try? rModifiedNode.init(from: decoder) {
            self = .modified(value)
            return
        }
        if let value = try? rCreatedNode.init(from: decoder) {
            self = .created(value)
            return
        }
        if let value = try? rDeletedNode.init(from: decoder) {
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

public class rTransactionMetadata: Codable {
    public var affectedNodes: [rNode]?
    public var deliveredAmount: rAmount?
    public var transactionResult: String
    public var transactionIndex: Int
    
    init(
        affectedNodes: [rNode]? = nil,
        transactionResult: String,
        transactionIndex: Int
    ) {
        self.affectedNodes = affectedNodes
        self.transactionResult = transactionResult
        self.transactionIndex = transactionIndex
    }
}
