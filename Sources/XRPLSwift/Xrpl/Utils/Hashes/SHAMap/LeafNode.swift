//
//  LeafNode.swift
//  
//
//  Created by Denis Angell on 8/6/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/hashes/SHAMap/LeafNode.ts

import Foundation

let HEX: Int = 16

/**
 * Class for SHAMap Leaf Node.
 */
class LeafNode: Node {
    public let tag: String
    public let type: NodeType
    public let data: String
    
    /**
     * Leaf node in a SHAMap tree.
     *
     * @param tag - Equates to a ledger entry `index`.
     * @param data - Hex of account state, transaction etc.
     * @param type - One of TYPE_ACCOUNT_STATE, TYPE_TRANSACTION_MD etc.
     */
    public init(tag: String, data: String, type: NodeType) {
//        super()
        self.tag = tag
        self.type = type
        self.data = data
    }
    
    /**
     * Add item to Leaf.
     *
     * @param tag - Index of the Node.
     * @param node - Node to insert.
     * @throws When called, because LeafNodes cannot addItem.
     */
    public func addItem(_tag: String, _node: Node) throws -> Void {
        throw XrplError.unknown("Cannot call addItem on a LeafNode")
        // try self.addItem(_tag: _tag, _node: _node)
    }
    
    /**
     * Get the hash of a LeafNode.
     *
     * @returns Hash or undefined.
     * @throws If node is of unknown type.
     */
    public func hash() throws -> String {
        switch (self.type) {
        case NodeType.ACCOUNT_STATE:
            let leafPrefix: String = HashPrefix.LEAF_NODE.rawValue.asBigByteArray.toHexString()
            return sha512Half(hex: leafPrefix + self.data + self.tag)
        case NodeType.TRANSACTION_NO_METADATA:
            let txIDPrefix: String = HashPrefix.TRANSACTION_ID.rawValue.asBigByteArray.toHexString()
            return sha512Half(hex: txIDPrefix + self.data)
        case NodeType.TRANSACTION_METADATA:
            let txNodePrefix: String = HashPrefix.TRANSACTION_NODE.rawValue.asBigByteArray.toHexString()
            return sha512Half(hex: txNodePrefix + self.data + self.tag)
        default:
            throw XrplError.unknown("Tried to hash a SHAMap node of unknown type.")
        }
    }
}
