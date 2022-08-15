//
//  RequestFixtures.swift
//  
//
//  Created by Denis Angell on 8/14/22.
//

import XCTest
@testable import XRPLSwift

final class RequestFixtures {
    
    public static func orderBookXRP() -> [String: AnyObject] {
        do {
            let data: Data = orderBookXRPFixtureReq.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String:AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON REQUEST FIXTURE")
        }
        return [:]
    }
    
    public static func orderBook() -> [String: AnyObject] {
        do {
            let data: Data = orderBookXRPFixtureReq.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String:AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON REQUEST FIXTURE")
        }
        return [:]
    }
    
    public static func hashLedger() -> [String: AnyObject] {
        do {
            let data: Data = hashLedgerFixtureReq.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String:AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON REQUEST FIXTURE")
        }
        return [:]
    }
    
    public static func hashLedgerTx() -> [String: AnyObject] {
        do {
            let data: Data = hashLedgerTxFixtureReq.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String:AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON REQUEST FIXTURE")
        }
        return [:]
    }
    
    public static func sign() -> [String: AnyObject] {
        do {
            let data: Data = signFixtureReq.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String:AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON REQUEST FIXTURE")
        }
        return [:]
    }
    
    public static func signAs() -> [String: AnyObject] {
        do {
            let data: Data = signAsFixtureReq.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String:AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON REQUEST FIXTURE")
        }
        return [:]
    }
    
    public static func signEscrow() -> [String: AnyObject] {
        do {
            let data: Data = signEscrowFixtureReq.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String:AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON REQUEST FIXTURE")
        }
        return [:]
    }
    
    public static func signClaim() -> [String: AnyObject] {
        do {
            let data: Data = signClaimFixtureReq.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String:AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON REQUEST FIXTURE")
        }
        return [:]
    }
    
    public static func signTicket() -> [String: AnyObject] {
        do {
            let data: Data = signTicketFixtureReq.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String:AnyObject] {
                return jsonResult
            }
        } catch {
            print(error.localizedDescription)
            fatalError("INVALID JSON REQUEST FIXTURE")
        }
        return [:]
    }
}
