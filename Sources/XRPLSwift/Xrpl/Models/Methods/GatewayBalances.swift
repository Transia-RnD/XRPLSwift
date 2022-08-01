////
////  File.swift
////
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/gatewayBalances.ts
//
//import Foundation
//
//
///**
// * The gateway_balances command calculates the total balances issued by a given
// * account, optionally excluding amounts held by operational addresses. Expects
// * a response in the form of a {@link GatewayBalancesResponse}.
// *
// * @example
// * ```ts
// * const gatewayBalances: GatewayBalanceRequest = {
// *   "id": "example_gateway_balances_1",
// *   "command": "gateway_balances",
// *   "account": "rMwjYedjc7qqtKYVLiAccJSmCwih4LnE2q",
// *   "strict": true,
// *   "hotwallet": ["rKm4uWpg9tfwbVSeATv4KxDe6mpE9yPkgJ","ra7JkEzrgeKHdzKgo4EUUVBnxggY4z37kt"],
// *   "ledger_index": "validated"
// * }
// * ```
// *
// */
//open class GatewayBalancesRequest: BaseRequest {
////    public let command: String = "gateway_balances"
//  /** The Address to check. This should be the issuing address. */
//    public let account: String
//  /**
//   * If true, only accept an address or public key for the account parameter.
//   * Defaults to false.
//   */
//    public let strict: Bool?
//  /**
//   * An operational address to exclude from the balances issued, or an array of
//   * Such addresses.
//   */
////    public let hotwallet: String | [String]?
//    public let hotwallet: String?
//  /** A 20-byte hex string for the ledger version to use. */
//    public let ledgerHash: String?
//  /**
//   * The ledger index of the ledger version to use, or a shortcut string to
//   * choose a ledger automatically.
//   */
//    public let ledgerIndex: rLedgerIndex?
//    
//    enum CodingKeys: String, CodingKey {
//        case account = "account"
//        case strict = "strict"
//        case hotwallet = "hotwallet"
//        case ledgerHash = "ledgerHash"
//        case ledgerIndex = "ledgerIndex"
//    }
//    
//}
//
//public struct Balance: Codable {
//    public let currency: String
//    public let value: String
//}
//
//public struct BaseBalance: Codable {
//    public let balances: [String: [Balance]]
//}
//
//public struct BaseCurrency: Codable {
//    public let currency: [String: String]
//}
//
//
///**
// * Expected response from a {@link GatewayBalancesRequest}.
// *
// * @category Responses
// */
//public class GatewayBalancesResponse: Codable {
//    /** The address of the account that issued the balances. */
//      public let account: String
//    /**
//     * Total amounts issued to addresses not excluded, as a map of currencies
//     * to the total value issued.
//     */
//      public let obligations: BaseCurrency?
//    /**
//     * Amounts issued to the hotwallet addresses from the request. The keys are
//     * addresses and the values are arrays of currency amounts they hold.
//     */
//      public let balances: BaseBalance?
//    /**
//     * Total amounts held that are issued by others. In the recommended
//     * configuration, the issuing address should have none.
//     */
//      public let assets: BaseBalance?
//    /**
//     * The identifying hash of the ledger version that was used to generate
//     * this response.
//     */
//      public let ledgerHash: String?
//    /**
//     * The ledger index of the ledger version that was used to generate this
//     * response.
//     */
//      public let ledgerCurrentIndex: Int?
//    /**
//     * The ledger index of the current in-progress ledger version, which was
//     * used to retrieve this information.
//     */
//      public let ledgerIndex: Int?
//    
//    enum CodingKeys: String, CodingKey {
//        case account = "account"
//        case obligations = "obligations"
//        case balances = "balances"
//        case ledgerHash = "ledgerHash"
//        case ledgerCurrentIndex = "ledgerCurrentIndex"
//        case ledgerIndex = "ledgerIndex"
//    }
//}
