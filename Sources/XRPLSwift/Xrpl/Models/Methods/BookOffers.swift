////
////  BookOffers.swift
////
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/bookOffers.ts
//
//import Foundation
//
//
//public struct TakerAmount {
//    public let currency: String
//    public let issuer: String?
//}
//
///**
// * The book_offers method retrieves a list of offers, also known as the order.
// * Book, between two currencies. Returns an {@link BookOffersResponse}.
// *
// */
//public class BookOffersRequest: BaseRequest {
//    //    public let command: String = "book_offers"
//    /** A 20-byte hex string for the ledger version to use. */
//    public let ledgerHash: String?
//    /**
//     * The ledger index of the ledger to use, or a shortcut string to choose a
//     * ledger automatically.
//     */
//    public let ledgerIndex: LedgerIndex?
//    /**
//     * If provided, the server does not provide more than this many offers in the
//     * results. The total number of results returned may be fewer than the limit,
//     * because the server omits unfunded offers.
//     */
//    public let limit: Int?
//    /**
//     * The Address of an account to use as a perspective. Unfunded offers placed
//     * by this account are always included in the response.
//     */
//    public let taker: String?
//    /**
//     * Specification of which currency the account taking the offer would
//     * receive, as an object with currency and issuer fields (omit issuer for
//     * XRP), like currency amounts.
//     */
//    public let takerGets: TakerAmount
//    /**
//     * Specification of which currency the account taking the offer would pay, as
//     * an object with currency and issuer fields (omit issuer for XRP), like
//     * currency amounts.
//     */
//    public let takerPays: TakerAmount
//    
//    enum CodingKeys: String, CodingKey {
//        case account = "account"
//        case ledgerHash = "ledger_hash"
//        case ledgerIndex = "ledger_index"
//        case limit = "limit"
//        case taker = "taker"
//        case taker_gets = "taker_gets"
//        case takerPays = "taker_pays"
//    }
//}
//
//public class BookOffer: Offer {
//    /**
//     * Amount of the TakerGets currency the side placing the offer has available
//     * to be traded. (XRP is represented as drops; any other currency is
//     * represented as a decimal value.) If a trader has multiple offers in the
//     * same book, only the highest-ranked offer includes this field.
//     */
//    public let ownerFunds: String?
//    /**
//     * The maximum amount of currency that the taker can get, given the funding
//     * status of the offer.
//     */
//    public let takerGetsFunded: Amount?
//    /**
//     * The maximum amount of currency that the taker would pay, given the funding
//     * status of the offer.
//     */
//    public let takerPaysFunded: Amount?
//    /**
//     * The exchange rate, as the ratio taker_pays divided by taker_gets. For
//     * fairness, offers that have the same quality are automatically taken
//     * first-in, first-out.
//     */
//    public let quality: String?
//}
//
///**
// * Expected response from a {@link BookOffersRequest}.
// *
// */
//public class BookOffersResponse: Codable {
//    /** Array of offer objects, each of which has the fields of an Offer object. */
//    public let offers: [BookOffer]
//    /**
//     * The ledger index of the current in-progress ledger version, which was
//     * used to retrieve this information.
//     */
//    public let ledgerCurrentIndex: Int?
//    /**
//     * The identifying hash of the ledger version that was used when retrieving
//     * this data, as requested.
//     */
//    public let ledgerHash: String?
//    /**
//     * The ledger index of the ledger version that was used when retrieving
//     * this data, as requested.
//     */
//    public let ledgerIndex: Int?
//    public let validated: Bool?
//    
//    enum CodingKeys: String, CodingKey {
//        case offers = "offers"
//        case ledgerCurrentIndex = "ledger_curren_index"
//        case ledgerHash = "ledger_hash"
//        case ledgerIndex = "ledger_index"
//        case validated = "validated"
//    }
//}
