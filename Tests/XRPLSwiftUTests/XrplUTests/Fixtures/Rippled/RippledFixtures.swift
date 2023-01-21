//
//  File.swift
//
//
//  Created by Denis Angell on 9/18/22.
//

import XCTest
@testable import XRPLSwift

final class RippledFixtures {

    public static func accountObjects() -> [String: AnyObject] {
        do {
            let data: Data = rippledAccountObjectsJson.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON RESPONSE FIXTURE")
        }
        return [:]
    }

    public static func accountInfo() -> [String: AnyObject] {
        do {
            let data: Data = rippledAccountInfoJson.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON RESPONSE FIXTURE")
        }
        return [:]
    }

    public static func serverInfo() -> [String: AnyObject] {
        do {
            let data: Data = rippledServerInfoJson.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON RESPONSE FIXTURE")
        }
        return [:]
    }

    public static func ledger() -> [String: AnyObject] {
        do {
            let data: Data = rippledLedgerJson.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON RESPONSE FIXTURE")
        }
        return [:]
    }
}

final class RippledTxFixtures {

    public static func offerCreateSell() -> [String: AnyObject] {
        do {
            let data: Data = rippledTxOfferCreateSellJson.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON RESPONSE FIXTURE")
        }
        return [:]
    }

    public static func offerCreateSellTx() -> [String: AnyObject] {
        do {
            let data: Data = rippledTxOfferCreateSellTxJson.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON RESPONSE FIXTURE")
        }
        return [:]
    }
}
