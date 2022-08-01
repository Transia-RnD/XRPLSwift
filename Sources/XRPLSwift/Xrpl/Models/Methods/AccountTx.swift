////
////  File.swift
////
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/accountTx.ts
//
//import Foundation
//
//
///**
// * The account_tx method retrieves a list of transactions that involved the
// * specified account. Expects a response in the form of a {@link
// * AccountTxResponse}.
// *
// * @category Requests
// */
//public class AccountTxRequest: BaseRequest {
////    public let command: String = "account_tx"
//    /** A unique identifier for the account, most commonly the account's address. */
//    public let account: String
//    /**
//     * Use to specify the earliest ledger to include transactions from. A value
//     * of -1 instructs the server to use the earliest validated ledger version
//     * available.
//     */
//    public let ledgerIndexMin: Int?
//    /**
//     * Use to specify the most recent ledger to include transactions from. A
//     * value of -1 instructs the server to use the most recent validated ledger
//     * version available.
//     */
//    public let ledgerIndexMax: Int?
//    /** Use to look for transactions from a single ledger only. */
//    public let ledgerHash: String?
//    /** Use to look for transactions from a single ledger only. */
//    public let ledgerIndex: rLedgerIndex?
//    /**
//     * If true, return transactions as hex strings instead of JSON. The default is
//     * false.
//     */
//    public let binary: Bool?
//    /**
//     * If true, returns values indexed with the oldest ledger first. Otherwise,
//     * the results are indexed with the newest ledger first.
//     */
//    public let forward: Bool?
//    /**
//     * Default varies. Limit the number of transactions to retrieve. The server
//     * is not required to honor this value.
//     */
//    public let limit: Int?
//    /**
//     * Value from a previous paginated response. Resume retrieving data where
//     * that response left off. This value is stable even if there is a change in
//     * the server's range of available ledgers.
//     */
//    public let marker: Any?
//    
//    enum CodingKeys: String, CodingKey {
//        case account = "account"
//        case ledgerIndexMin = "ledger_index_min"
//        case ledgerIndexMax = "ledger_index_max"
//        case ledgerHash = "ledger_hash"
//        case ledgerIndex = "ledger_index"
//        case binary = "binary"
//        case forward = "forward"
//        case limit = "limit"
//        case marker = "marker"
//    }
//}
//
//struct AccountTransaction {
//    /** The ledger index of the ledger version that included this transaction. */
//    public let ledgerIndex: Int
//    /**
//     * If binary is True, then this is a hex string of the transaction metadata.
//     * Otherwise, the transaction metadata is included in JSON format.
//     */
//    public let meta: String | TransactionMetadata
//    /** JSON object defining the transaction. */
//    public let tx: Transaction? & ResponseOnlyTxInfo
//    /** Unique hashed String representing the transaction. */
//    public let txBlob: String?
//    /**
//     * Whether or not the transaction is included in a validated ledger. Any
//     * transaction not yet in a validated ledger is subject to change.
//     */
//    public let validated: Bool
//}
//
///**
// * Expected response from an {@link AccountTxRequest}.
// *
// * @category Responses
// */
//public class AccountTxResponse: Codable {
//    /** Unique Address identifying the related account. */
//    public let account: String
//    /**
//     * Array of transactions matching the request's criteria, as explained
//     * below.
//     */
//    public let transactions: [AccountTransaction]
//    /**
//     * The ledger index of the earliest ledger actually searched for
//     * transactions.
//     */
//    public let ledgerIndexMin: Int
//    /**
//     * The ledger index of the most recent ledger actually searched for
//     * transactions.
//     */
//    public let ledgerIndexMax: Int
//    /**
//     * If included and set to true, the information in this response comes from
//     * a validated ledger version. Otherwise, the information is subject to
//     * change.
//     */
//    public let validated: Bool?
//    
//    /** The limit value used in the request. */
//    public let limit: Int
//    /**
//     * Server-defined value indicating the response is paginated. Pass this
//     * to the next call to resume where this call left off.
//     */
//    public let marker: Any?
//    
//    enum CodingKeys: String, CodingKey {
//        case account = "account"
//        case transactions = "transactions"
//        case ledgerIndexMin = "ledger_index_min"
//        case ledgerIndexMax = "ledger_index_max"
//        case validated = "validated"
//        case limit = "limit"
//        case marker = "marker"
//    }
//}
