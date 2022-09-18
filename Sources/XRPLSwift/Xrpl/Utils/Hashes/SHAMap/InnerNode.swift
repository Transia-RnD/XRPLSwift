////
////  InnerNode.swift
////  
////
////  Created by Denis Angell on 8/6/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/hashes/SHAMap/InnerNode.ts
//
// import Foundation
//
// let HEX_ZERO: String = "0000000000000000000000000000000000000000000000000000000000000000"
//
// let SLOT_MAX: Int = 15
// let HEX: Int = 16
//
/// **
// * Class for SHAMap InnerNode.
// */
// class InnerNode: Node {
//    public let leaves: [ [slot: Int]: Node? ]
//    public let type: NodeType
//    public let depth: Int
//    public let empty: Bool
//    
//    /**
//     * Define an Inner (non-leaf) node in a SHAMap tree.
//     *
//     * @param depth - I.e. How many parent inner nodes.
//     */
//    public init(depth: Int = 0) {
//        super()
//        self.leaves = [:]
//        self.type = NodeType.INNER
//        self.depth = depth
//        self.empty = true
//    }
//    
//    /**
//     * Adds an item to the InnerNode.
//     *
//     * @param tag - Equates to a ledger entry `index`.
//     * @param node - Node to add.
//     * @throws If there is a index collision.
//     */
//    public func addItem(tag: String, node: Node) -> Void {
//        let existingNode = self.getNode(parseInt(tag[self.depth], HEX))
//        
//        if existingNode == nil {
//            self.setNode(parseInt(tag[self.depth], HEX), node)
//            return
//        }
//        
//        // A node already exists in this slot
//        if (existingNode instanceof InnerNode) {
//            // There is an inner node, so we need to go deeper
//            existingNode.addItem(tag, node)
//        } else if (existingNode instanceof LeafNode) {
//            if (existingNode.tag == tag) {
//                // Collision
//                throw XrplError("Tried to add a node to a SHAMap that was already in there.")
//            } else {
//                let newInnerNode = InnerNode(self.depth + 1)
//                
//                // Parent new and existing node
//                newInnerNode.addItem(existingNode.tag, existingNode)
//                newInnerNode.addItem(tag, node)
//                
//                // And place the newly created inner node in the slot
//                self.setNode(parseInt(tag[this.depth], HEX), newInnerNode)
//            }
//        }
//    }
//    
//    /**
//     * Overwrite the node that is currently in a given slot.
//     *
//     * @param slot - A number 0-15.
//     * @param node - To place.
//     * @throws If slot is out of range.
//     */
//    public setNode(slot: number, node: Node) -> Void {
//        if slot < 0 || slot > SLOT_MAX {
//            throw XrplError("Invalid slot: slot must be between 0-15.")
//        }
//        self.leaves[slot] = node
//        self.empty = false
//    }
//    
//    /**
//     * Get the node that is currently in a given slot.
//     *
//     * @param slot - A number 0-15.
//     * @returns Node currently in a slot.
//     * @throws If slot is out of range.
//     */
//    public func getNode(slot: Int) throws -> Node? {
//        if slot < 0 || slot > SLOT_MAX {
//            throw XrplError("Invalid slot: slot must be between 0-15.")
//        }
//        return self.leaves[slot]
//    }
//    
//    /**
//     * Get the hash of a LeafNode.
//     *
//     * @returns Hash of the LeafNode.
//     */
//    public func hash() -> String {
//        if self.empty {
//            return HEX_ZERO
//        }
//        let hex: String = ""
//        for let iter = 0; iter <= SLOT_MAX; iter++ {
//            const child = this.leaves[iter]
//            const hash: string = child == null ? HEX_ZERO : child.hash
//            hex += hash
//        }
//        
//        let prefix = HashPrefix.INNER_NODE.toString(HEX)
//        return sha512Half(prefix + hex)
//    }
// }
