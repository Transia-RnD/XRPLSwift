////
////  File.swift
////  
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/unsubscribe.ts
//
//import Foundation
//
//
//struct Book {
//  let taker_gets: Currency
//  let taker_pays: Currency
//  let both: Bool?
//}
//
///**
// * The unsubscribe command tells the server to stop sending messages for a
// * particular subscription or set of subscriptions. Expects a response in the
// * form of an {@link UnsubscribeResponse}.
// *
// * @category Requests
// */
//open class UnsubscribeRequest: BaseRequest {
////  command: String = "unsubscribe"
//  /**
//   * Array of string names of generic streams to unsubscribe from, including.
//   * Ledger, server, transactions, and transactions_proposed.
//   */
//  streams: [StreamType]?
//  /**
//   * Array of unique account addresses to stop receiving updates for, in the.
//   * XRP Ledger's base58 format.
//   */
//  accounts: [String]?
//  /**
//   * Like accounts, but for accounts_proposed subscriptions that included
//   * not-yet-validated transactions.
//   */
//  accounts_proposed: [String]?
//  /**
//   * Array of objects defining order books to unsubscribe from, as explained
//   * below.
//   */
//  books: Book[]?
//}
//
///**
// * Response expected from a {@link UnsubscribeRequest}.
// *
// * @category Responses
// */
//open class UnsubscribeResponse: BaseResponse {
//  result: Record<String, never>
//}
