//
//  Node.swift
//  
//
//  Created by Denis Angell on 8/6/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/hashes/SHAMap/node.ts

import Foundation


public enum NodeType: Int {
    case INNER = 1
    case TRANSACTION_NO_METADATA = 2
    case TRANSACTION_METADATA = 3
    case ACCOUNT_STATE = 4
}

/**
 * Abstract base class for SHAMapNode.
 */
public protocol Node {
    func addItem(_tag: String, _node: Node) throws -> Void
    func hash() throws -> String
}
