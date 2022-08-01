////
////  File.swift
////
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/depositAuthorized.ts
//
//import Foundation
//
//
///**
// * The deposit_authorized command indicates whether one account is authorized to
// * send payments directly to another. Expects a response in the form of a {@link
// * DepositAuthorizedResponse}.
// *
// * @category Requests
// */
//public class DepositAuthorizedRequest: BaseRequest {
//    //    public let command: String = "deposit_authorized"
//    /** The sender of a possible payment. */
//    public let sourceAccount: String
//    /** The recipient of a possible payment. */
//    public let destinationAccount: String
//    /** A 20-byte hex string for the ledger version to use. */
//    public let ledgerHash: String?
//    /**
//     * The ledger index of the ledger to use, or a shortcut string to choose a
//     * ledger automatically.
//     */
//    public let ledgerIndex: LedgerIndex?
//    
//    enum CodingKeys: String, CodingKey {
//        case sourceAccount = "sourceAccount"
//        case destinationAccount = "destinationAccount"
//        case ledgerHash = "ledgerHash"
//        case ledgerIndex = "ledgerIndex"
//    }
//}
//
///**
// * Expected response from a {@link DepositAuthorizedRequest}.
// *
// * @category Responses
// */
//public class DepositAuthorizedResponse: BaseResponse {
//    /**
//     * Whether the specified source account is authorized to send payments
//     * directly to the destination account. If true, either the destination
//     * account does not require Deposit Authorization or the source account is
//     * preauthorized.
//     */
//    public let depositAuthorized: Bool
//    /** The destination account specified in the request. */
//    public let destinationAccount: String
//    /**
//     * The identifying hash of the ledger that was used to generate this
//     * Response.
//     */
//    public let ledgerHash: String?
//    /**
//     * The ledger index of the ledger version that was used to generate this
//     * Response.
//     */
//    public let ledgerIndex: Int?
//    /**
//     * The ledger index of the current in-progress ledger version, which was
//     * used to generate this response.
//     */
//    public let ledgerCurrentIndex: Int?
//    /** The source account specified in the request. */
//    public let sourceAccount: String
//    /** If true, the information comes from a validated ledger version. */
//    public let validated: Bool?
//    
//    enum CodingKeys: String, CodingKey {
//        case depositAuthorized = "depositAuthorized"
//        case destinationAccount = "destinationAccount"
//        case ledgerHash = "ledgerHash"
//        case ledgerIndex = "ledgerIndex"
//        case ledgerCurrentIndex = "ledgerCurrentIndex"
//        case sourceAccount = "sourceAccount"
//        case validated = "validated"
//    }
//}
