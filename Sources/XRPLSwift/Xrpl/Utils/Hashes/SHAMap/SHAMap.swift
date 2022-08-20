////
////  File.swift
////
////
////  Created by Denis Angell on 8/6/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/hashes/SHAMap/index.ts
//
// import Foundation
//
//
//
// class SHAMap {
//  public root: InnerNode
//
//  /**
//   * SHAMap tree constructor.
//   */
//  public init() {
//    self.root = InnerNode(0)
//  }
//
//  /**
//   * Add an item to the SHAMap.
//   *
//   * @param tag - Index of the Node to add.
//   * @param data - Data to insert into the tree.
//   * @param type - Type of the node to add.
//   */
//  public func addItem(tag: string, data: string, type: NodeType) -> Void {
//    self.root.addItem(tag, LeafNode(tag, data, type))
//  }
//
//  /**
//   * Get the hash of the SHAMap.
//   *
//   * @returns The hash of the root of the SHAMap.
//   */
//  public func hash() -> String {
//    return self.root.hash
//  }
// }
