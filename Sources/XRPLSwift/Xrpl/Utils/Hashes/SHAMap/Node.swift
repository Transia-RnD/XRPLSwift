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
    // swiftlint:disable:next identifier_name
    case TRANSACTION_NO_METADATA = 2
    // swiftlint:disable:next identifier_name
    case TRANSACTION_METADATA = 3
    // swiftlint:disable:next identifier_name
    case ACCOUNT_STATE = 4
}

/**
 * Abstract base class for SHAMapNode.
 */
public protocol HashesNode {
    func addItem(tag: String, node: HashesNode) throws
    func hash() throws -> String
}
