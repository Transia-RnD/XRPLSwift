//
//  BaseTransaction.swift
//  
//
//  Created by Denis Angell on 5/25/22.
//

import Foundation

public struct AccountChannel: Codable {
    public var account: String
    public var amount: Int
    public var balance: Int
    public var channelId: String
    public var destination: String
    public var publicKey: String
    public var publicKeyHex: String
    public var settleDelay: Int
    
    public init(
        account: String,
        amount: Int,
        balance: Int,
        channelId: String,
        destination: String,
        publicKey: String,
        publicKeyHex: String,
        settleDelay: Int
    ) {
        self.account = account
        self.amount = amount
        self.balance = balance
        self.channelId = channelId
        self.destination = destination
        self.publicKey = publicKey
        self.publicKeyHex = publicKeyHex
        self.settleDelay = settleDelay
    }
    
    static func fromDict(field: [String: AnyObject]) -> AccountChannel? {
        guard let account = field["Account"] as? String,
              let amount = field ["Amount"] as? Int,
              let balance = field ["Balance"] as? Int,
              let channelId = field ["channel_id"] as? String,
              let destination = field ["destination_account"] as? String,
              let publicKey = field ["public_key"] as? String,
              let publicKeyHex = field ["public_key_hex"] as? String,
              let settleDelay = field ["settle_delay"] as? Int else {
            return nil
        }
        return AccountChannel(
            account: account,
            amount: amount,
            balance: balance,
            channelId: channelId,
            destination: destination,
            publicKey: publicKey,
            publicKeyHex: publicKeyHex,
            settleDelay: settleDelay
        )
    }
}

public struct PreviousField: Codable {
    public var balance: Int
    public var ownerCount: Int
    public var sequence: Int
    
    public init(
        balance: Int,
        ownerCount: Int,
        sequence: Int
    ) {
        self.balance = balance
        self.ownerCount = ownerCount
        self.sequence = sequence
    }
    
    static func fromDict(field: [String: AnyObject]) -> PreviousField? {
        guard let balance = field ["Balance"] as? Int,
              let ownerCount = field ["OwnerCount"] as? Int,
              let sequence = field ["Sequence"] as? Int else {
            return nil
        }
        return PreviousField(
            balance: balance,
            ownerCount: ownerCount,
            sequence: sequence
        )
    }
}

public struct FinalField: Codable {
    public var account: String
    public var balance: Int
    public var flags: Int
    public var ownerCount: Int
    public var sequence: Int
    
    public init(
        account: String,
        balance: Int,
        flags: Int,
        ownerCount: Int,
        sequence: Int
    ) {
        self.account = account
        self.balance = balance
        self.flags = flags
        self.ownerCount = ownerCount
        self.sequence = sequence
    }
    
    static func fromDict(field: [String: AnyObject]) -> FinalField? {
        guard let account = field["Account"] as? String,
              let balance = field ["Balance"] as? Int,
              let flags = field ["Flags"] as? Int,
              let ownerCount = field ["OwnerCount"] as? Int,
              let sequence = field ["Sequence"] as? Int else {
            return nil
        }
        return FinalField(
            account: account,
            balance: balance,
            flags: flags,
            ownerCount: ownerCount,
            sequence: sequence
        )
    }
}

public struct ModifiedNode: Codable {
    public var ledgerEntryType: String
    public var ledgerIndex: String
    public var previoudTxnId: String?
    public var previoudTxnLgrSeq: Int?
    
    public init(
        ledgerEntryType: String,
        ledgerIndex: String,
        previoudTxnId: String?,
        previoudTxnLgrSeq: Int?
    ) {
        self.ledgerEntryType = ledgerEntryType
        self.ledgerIndex = ledgerIndex
        self.previoudTxnId = previoudTxnId
        self.previoudTxnLgrSeq = previoudTxnLgrSeq
    }
    
    static func fromDict(dict: [String: AnyObject]) -> ModifiedNode? {
        print("MODIFIED NODE")
        print(dict)
        guard let ledgerEntryType = dict["LedgerEntryType"] as? String,
              let ledgerIndex = dict ["LedgerIndex"] as? String else {
            return nil
        }
        return ModifiedNode(
            ledgerEntryType: ledgerEntryType,
            ledgerIndex: ledgerIndex,
            previoudTxnId: dict ["PreviousTxnID"] as? String,
            previoudTxnLgrSeq: dict ["PreviousTxnLgrSeq"] as? Int
        )
    }
}

public struct DirectoryNodeField: Codable {
    public var owner: String
    public var rootIndex: String
    
    public init(
        owner: String,
        rootIndex: String
    ) {
        self.owner = owner
        self.rootIndex = rootIndex
    }
    
    static func fromDict(field: [String: AnyObject]) -> DirectoryNodeField? {
        guard let owner = field["Owner"] as? String,
              let rootIndex = field ["RootIndex"] as? String else {
            return nil
        }
        return DirectoryNodeField(owner: owner, rootIndex: rootIndex)
    }
}

public struct PayChannelNodeField: Codable {
    public var account: String
    public var amount: String
    public var destination: String
    public var publicKey: String
    public var settleDelay: Int
    
    public init(
        account: String,
        amount: String,
        destination: String,
        publicKey: String,
        settleDelay: Int
    ) {
        self.account = account
        self.amount = amount
        self.destination = destination
        self.publicKey = publicKey
        self.settleDelay = settleDelay
    }
    
    static func fromDict(field: [String: AnyObject]) -> PayChannelNodeField? {
        guard let account = field["Account"] as? String,
              let amount = field ["Amount"] as? String,
              let destination = field ["Destination"] as? String,
              let publicKey = field ["PublicKey"] as? String,
              let settleDelay = field ["SettleDelay"] as? Int else {
            return nil
        }
        return PayChannelNodeField(
            account: account,
            amount: amount,
            destination: destination,
            publicKey: publicKey,
            settleDelay: settleDelay
        )
    }
}

public enum LedgerEntryType: Codable {
    case directory
    case paychannel
    case unknown
}

public struct CreatedNode: Codable {
    public enum NewField: Codable {
        case directory(DirectoryNodeField)
        case paychannel(PayChannelNodeField)
        case unknown
    }
    
    public var ledgerEntryType: LedgerEntryType
    public var ledgerIndex: String
    public var newFields: NewField?
    
    init(
        ledgerEntryType: LedgerEntryType,
        ledgerIndex: String,
        newFields: NewField?
    ) {
        self.ledgerEntryType = ledgerEntryType
        self.ledgerIndex = ledgerIndex
        self.newFields = newFields
    }
    
    static func fromDict(dict: [String: AnyObject]) -> CreatedNode? {
        guard let ledgerEntryTypeString = dict["LedgerEntryType"] as? String,
              let ledgerIndex = dict["LedgerIndex"] as? String,
              let newFields = dict["NewFields"] as? [String: AnyObject] else {
            return nil
        }
        switch(ledgerEntryTypeString) {
        case "DirectoryNode":
            guard let node = DirectoryNodeField.fromDict(field: newFields) else { return nil }
            return CreatedNode(
                ledgerEntryType: LedgerEntryType.directory,
                ledgerIndex: ledgerIndex,
                newFields: NewField.directory(node)
            )
        case "PayChannel":
            guard let node = PayChannelNodeField.fromDict(field: newFields) else { return nil }
            return CreatedNode(
                ledgerEntryType: LedgerEntryType.paychannel,
                ledgerIndex: ledgerIndex,
                newFields: NewField.paychannel(node)
            )
        default:
            return CreatedNode(
                ledgerEntryType: LedgerEntryType.unknown,
                ledgerIndex: ledgerIndex,
                newFields: nil
            )
        }
    }
}

public struct XrplTransactionMeta: Codable {
    public enum AffectedNode: Codable {
        case modified(ModifiedNode)
        case created(CreatedNode)
        case unknown
        func get() -> Any? {
            switch self {
            case .modified(let modified):
                return modified
            case .created(let created):
                return created
            case .unknown:
                return nil
            }
        }
        
        func value() -> String? {
            switch self {
            case .modified:
                return "modified"
            case .created:
                return "created"
            case .unknown:
                return "unknown"
            }
        }
    }
    public var affectedNodes: [AffectedNode]?
    public var transactionResult: String
    public var transactionIndex: Int
    
    public init(affectedNodes: [AffectedNode]?, transactionResult: String, transactionIndex: Int) {
        self.affectedNodes = affectedNodes
        self.transactionResult = transactionResult
        self.transactionIndex = transactionIndex
    }
    
    static func fromDict(dict: [String: AnyObject]) -> XrplTransactionMeta? {
        guard let transactionResult = dict["TransactionResult"] as? String,
              let transactionIndex = dict["TransactionIndex"] as? Int,
            let nodes = dict["AffectedNodes"] as? [[String: AnyObject]] else {
            return nil
        }
        var affectedNodes: [AffectedNode] = []
        for node in nodes {
            for (key, value) in node {
                if key == "ModifiedNode" {
                    if let value = value as? [String : AnyObject] {
                        if let modifiedNode = ModifiedNode.fromDict(dict: value) {
                            affectedNodes.append(AffectedNode.modified(modifiedNode))
                        }
                    }
                }
                if key == "CreatedNode" {
                    if let value = value as? [String : AnyObject] {
                        if let createdNode = CreatedNode.fromDict(dict: value) {
                            affectedNodes.append(AffectedNode.created(createdNode))
                        }
                    }
                }
            }
        }
        return XrplTransactionMeta(
            affectedNodes: affectedNodes,
            transactionResult: transactionResult,
            transactionIndex: transactionIndex
        )
    }
}


/*
 
 MINT TX
 
 Account = radtouEofR55c92fy8xszfQPccjoGi68C3;
 Fee = 10;
 LastLedgerSequence = 28343139;
 NFTokenTaxon = 0;
 Sequence = 577;
 SigningPubKey = EDA9E05E0C81D9EB1D346F8FD44D973BE3956757614731610CB6D8EC774C8D2A09;
 TransactionType = NFTokenMint;
 TxnSignature = C1BCC3CBC49D2460F9C139565C44D9783707766B24E255681C4DB2D399512E97FB0857B7878C34D3021AC7A9CDDAEDE5646642A4AFA92810900CB0B9FA2FF60D;
 hash = 9218904E79064F92E0DAFC12C6878D10325AF6BF1FC4DE2095BEC9DEBB73C838;
 
*/
public struct XrplBaseTransaction: Codable {
    public var account: String
//    public var amount: String
//    public var destination: String
//    public var fee: Int
//    public var flags: Int
//    public var lastLedgerSequence: Int
//    public var publicKey: String
//    public var sequence: Int
//    public var settleDelay: Int
//    public var signingPubKey: String
//    public var transactionType: String
//    public var txnSignature: String
//    public var date: Int
    public var hash: String
//    public var inLedger: Bool
    public var ledgerIndex: Int?
    public var meta: XrplTransactionMeta?
    public var status: String?
    public var validated: Bool?
    
    public init(
        account: String,
        hash: String,
        ledgerIndex: Int? = nil,
        meta: XrplTransactionMeta? = nil,
        status: String? = nil,
        validated: Bool? = nil
    ) {
        self.account = account
        self.hash = hash
        self.ledgerIndex = ledgerIndex
        self.meta = meta
        self.status = status
        self.validated = validated
    }
    
    static func fromDict(
        dict: [String: AnyObject]
    ) -> XrplBaseTransaction? {
        print(dict)
        guard let account = dict["Account"] as? String,
              let hash = dict["hash"] as? String else {
            return nil
        }
        var clone: XrplBaseTransaction = XrplBaseTransaction(
            account: account,
            hash: hash
        )
        
        if let ledgerIndex = dict["ledger_index"] as? Int {
            clone.ledgerIndex = ledgerIndex
        }
        if let status = dict["status"] as? String {
            clone.status = status
        }
        if let validated = dict["validated"] as? Bool {
            clone.validated = validated
        }
        if let metaDict = dict["meta"] as? [String: AnyObject] {
            clone.meta = XrplTransactionMeta.fromDict(dict: metaDict)
        }
        return clone
    }
    
    public func getChannelHex() -> String? {
        guard let meta = meta,
              let affectedNodes = meta.affectedNodes else {
            return nil
        }
        let x = affectedNodes.lastIndex(where: { $0.value() == "created" })
        let node = affectedNodes[x!].get() as? CreatedNode
        print("NODE: \(node)")
        if node?.ledgerEntryType == .paychannel {
            return node?.ledgerIndex
        }
        return nil
    }
}

public struct XrplBaseResponse: Codable {
    public var date: TimeInterval
    public var hash: String
    public var inLedger: Bool
    public var ledgerIndex: Int
    public var validated: Bool
    
    public init(
        date: TimeInterval,
        hash: String,
        inLedger: Bool,
        ledgerIndex: Int,
        validated: Bool
    ) {
        self.date = date
        self.hash = hash
        self.inLedger = inLedger
        self.ledgerIndex = ledgerIndex
        self.validated = validated
    }
    
    static func fromDict(
        dict: [String: AnyObject]
    ) -> XrplBaseResponse? {
        guard let date = dict["date"] as? TimeInterval,
              let hash = dict["hash"] as? String,
              let inLedger = dict["inLedger"] as? Bool,
              let ledgerIndex = dict["ledger_index"] as? Int,
              let validated = dict["validated"] as? Bool else {
            return nil
        }
        return XrplBaseResponse(
            date: date,
            hash: hash,
            inLedger: inLedger,
            ledgerIndex: ledgerIndex,
            validated: validated
        )
    }
}
