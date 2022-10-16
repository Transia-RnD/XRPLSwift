//
//  TestFixtures.swift
//
//
//  Created by Denis Angell on 7/28/22.
//

import XCTest
@testable import XRPLSwift

final class Fixtures4Testing {

    public var ACCOUNT_OBJECTS: [String: AnyObject] = [:]

    init() {
        do {
            let data: Data = accountObjectFixture.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: AnyObject] {
                self.ACCOUNT_OBJECTS = jsonResult
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

final class ResponseFixtures {

    public static func sign() -> [String: AnyObject] {
        do {
            let data: Data = signFixtureResp.data(using: .utf8)!
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

    public static func signAs() -> [String: AnyObject] {
        do {
            let data: Data = signAsFixtureResp.data(using: .utf8)!
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

    public static func signEscrow() -> [String: AnyObject] {
        do {
            let data: Data = signEscrowFixtureResp.data(using: .utf8)!
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

    public static func signClaim() -> String {
        return signClaimFixtureResp
//        do {
//            let data: Data = signClaimFixtureResp.data(using: .utf8)!
//            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//            if let jsonResult = jsonResult as? [String: AnyObject] {
//                return jsonResult
//            }
//        } catch {
//            print(error.localizedDescription)
//            fatalError("INVALID JSON RESPONSE FIXTURE")
//        }
//        return [:]
    }

    public static func signTicket() -> [String: AnyObject] {
        do {
            let data: Data = signTicketFixtureResp.data(using: .utf8)!
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
