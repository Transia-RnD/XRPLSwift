//
//  File.swift
//  
//
//  Created by Denis Angell on 7/27/22.
//

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
    
    public var ledgerEntryType: LedgerEntryType
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
    func get() -> Any? {
        switch self {
        case .modified(let modified):
            return modified
        case .created(let created):
            return created
        case .deleted(let deleted):
            return deleted
        }
    }
    
    func value() -> String? {
        switch self {
        case .modified:
            return "modified"
        case .created:
            return "created"
        case .deleted:
            return "deleted"
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
