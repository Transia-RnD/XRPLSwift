//
//  File.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/gatewayBalances.ts

import Foundation

/**
 The gateway_balances command calculates the total balances issued by a given
 account, optionally excluding amounts held by operational addresses. Expects
 a response in the form of a {@link GatewayBalancesResponse}.
 *
 @example
 ```swift
 let gatewayBalances = GatewayBalanceRequest(
   id: "example_gateway_balances_1",
   account: "rMwjYedjc7qqtKYVLiAccJSmCwih4LnE2q",
   strict: true,
   hotwallet: ["rKm4uWpg9tfwbVSeATv4KxDe6mpE9yPkgJ","ra7JkEzrgeKHdzKgo4EUUVBnxggY4z37kt"],
   ledgerIndex: "validated"
 )
 ```
 *
 */
public class GatewayBalancesRequest: BaseRequest {
    /// The Address to check. This should be the issuing address.
    public let account: String
  /**
   If true, only accept an address or public key for the account parameter.
   Defaults to false.
   */
    public let strict: Bool?
  /**
   An operational address to exclude from the balances issued, or an array of
   Such addresses.
   */
//    public let hotwallet: String | [String]?
    public let hotwallet: String?
    /// A 20-byte hex string for the ledger version to use.
    public let ledgerHash: String?
  /**
   The ledger index of the ledger version to use, or a shortcut string to
   choose a ledger automatically.
   */
    public let ledgerIndex: LedgerIndex?

    enum CodingKeys: String, CodingKey {
        case account = "account"
        case strict = "strict"
        case hotwallet = "hotwallet"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger-index"
    }

    public init(
        // Required
        account: String,
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil,
        // Optional
        strict: Bool? = nil,
        hotwallet: String? = nil,
        ledgerHash: String? = nil,
        ledgerIndex: LedgerIndex? = nil
    ) {
        // Required
        self.account = account
        // Optional
        self.strict = strict
        self.hotwallet = hotwallet
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        super.init(id: id, command: "gateway_balances", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(GatewayBalancesRequest.self, from: data)
        // Required
        self.account = decoded.account
        // Optional
        self.strict = decoded.strict
        self.hotwallet = decoded.hotwallet
        self.ledgerHash = decoded.ledgerHash
        self.ledgerIndex = decoded.ledgerIndex
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        strict = try values.decodeIfPresent(Bool.self, forKey: .strict)
        hotwallet = try values.decodeIfPresent(String.self, forKey: .hotwallet)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(LedgerIndex.self, forKey: .ledgerIndex)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(account, forKey: .account)
        if let strict = strict { try values.encode(strict, forKey: .strict) }
        if let hotwallet = hotwallet { try values.encode(hotwallet, forKey: .hotwallet) }
        if let ledgerHash = ledgerHash { try values.encode(ledgerHash, forKey: .ledgerHash) }
        if let ledgerIndex = ledgerIndex { try values.encode(ledgerIndex, forKey: .ledgerIndex) }
    }

}

public struct Balance: Codable {
    public let currency: String
    public let value: String
}

public struct BaseBalance: Codable {
    public let balances: [String: [Balance]]
}

public struct BaseCurrency: Codable {
    public let currency: [String: String]
}

/**
 Expected response from a {@link GatewayBalancesRequest}.
 */
public class GatewayBalancesResponse: Codable {
    /// The address of the account that issued the balances.
      public let account: String
    /**
     Total amounts issued to addresses not excluded, as a map of currencies
     to the total value issued.
     */
      public let obligations: BaseCurrency?
    /**
     Amounts issued to the hotwallet addresses from the request. The keys are
     addresses and the values are arrays of currency amounts they hold.
     */
      public let balances: BaseBalance?
    /**
     Total amounts held that are issued by others. In the recommended
     configuration, the issuing address should have none.
     */
      public let assets: BaseBalance?
    /**
     The identifying hash of the ledger version that was used to generate
     this response.
     */
      public let ledgerHash: String?
    /**
     The ledger index of the current in-progress ledger version, which was
     used to retrieve this information.
     */
      public let ledgerIndex: Int?
    /**
     The ledger index of the ledger version that was used to generate this
     response.
     */
      public let ledgerCurrentIndex: Int?
    /**
     validated
     */
      public let validated: Bool?

    enum CodingKeys: String, CodingKey {
        case account = "account"
        case obligations = "obligations"
        case balances = "balances"
        case assets = "assets"
        case ledgerHash = "ledger_hash"
        case ledgerCurrentIndex = "ledger_current_index"
        case ledgerIndex = "ledger_index"
        case validated = "validated"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        obligations = try values.decodeIfPresent(BaseCurrency.self, forKey: .obligations)
        balances = try values.decodeIfPresent(BaseBalance.self, forKey: .balances)
        assets = try values.decodeIfPresent(BaseBalance.self, forKey: .assets)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(Int.self, forKey: .ledgerIndex)
        ledgerCurrentIndex = try values.decodeIfPresent(Int.self, forKey: .ledgerCurrentIndex)
        validated = try values.decodeIfPresent(Bool.self, forKey: .validated)
        //        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
