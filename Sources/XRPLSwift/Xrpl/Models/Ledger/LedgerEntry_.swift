//
//  LedgerEntry.swift
//
//
//  Created by Denis Angell on 7/27/22.
//

import Foundation

// swiftlint:disable:file switch_case_alignment
public enum LedgerEntry: Codable {
    case accountRoot(LEAccountRoot)
    case amendments(LEAmendments)
    case check(LECheck)
    case depositPreauth(LEDepositPreauth)
    case directoryNode(LEDirectoryNode)
    case escrow(LEEscrow)
    case feeSettings(LEFeeSettings)
    case ledgerHashes(LELedgerHashes)
    case negativeUNL(LENegativeUNL)
    case offer(LEOffer)
    case payChannel(LEPayChannel)
    case rippleState(LERippleState)
    case signerList(LESignerList)
    case ticket(LETicket)
    enum CodingKeys: String, CodingKey {
        case accountRoot = "AccountRoot"
        case amendments = "Amendments"
        case check = "Check"
        case depositPreauth = "DepositPreauth"
        case directoryNode = "DirectoryNode"
        case escrow = "Escrow"
        case feeSettings = "FeeSettings"
        case ledgerHashes = "LedgerHashes"
        case negativeUNL = "NegativeUNL"
        case offer = "Offer"
        case payChannel = "PayChannel"
        case rippleState = "RippleState"
        case signerList = "SignerList"
        case ticket = "Ticket"
    }

    enum LedgerEntryCodingError: Error {
        case decoding(String)
    }

    init(_ json: [String: AnyObject]) throws {
        guard let entryType: String = json["LedgerEntryType"] as? String else {
            throw LedgerEntryCodingError.decoding("Missing Ledger Entry Type")
        }
        if entryType == "AccountRoot", let value = try? LEAccountRoot(json: json) {
            self = .accountRoot(value)
            return
        }
        if entryType == "Amendments", let value = try? LEAmendments(json: json) {
            self = .amendments(value)
            return
        }
        if entryType == "Check", let value = try? LECheck(json: json) {
            self = .check(value)
            return
        }
        if entryType == "DepositPreauth", let value = try? LEDepositPreauth(json: json) {
            self = .depositPreauth(value)
            return
        }
        if entryType == "DirectoryNode", let value = try? LEDirectoryNode(json: json) {
            self = .directoryNode(value)
            return
        }
        if entryType == "Escrow", let value = try? LEEscrow(json: json) {
            self = .escrow(value)
            return
        }
        if entryType == "FeeSettings", let value = try? LEFeeSettings(json: json) {
            self = .feeSettings(value)
            return
        }
        if entryType == "LedgerHashes", let value = try? LELedgerHashes(json: json) {
            self = .ledgerHashes(value)
            return
        }
        if entryType == "NegativeUNL", let value = try? LENegativeUNL(json: json) {
            self = .negativeUNL(value)
            return
        }
        if entryType == "Offer", let value = try? LEOffer(json: json) {
            self = .offer(value)
            return
        }
        if entryType == "PayChannel", let value = try? LEPayChannel(json: json) {
            self = .payChannel(value)
            return
        }
        if entryType == "RippleState", let value = try? LERippleState(json: json) {
            self = .rippleState(value)
            return
        }
        if entryType == "SignerList", let value = try? LESignerList(json: json) {
            self = .signerList(value)
            return
        }
        if entryType == "Ticket", let value = try? LETicket(json: json) {
            self = .ticket(value)
            return
        }
        throw LedgerEntryCodingError.decoding("Invalid Ledger Entry Type")
    }

    func get() -> Any? {
        switch self {
            case .accountRoot(let value):
                return value
            case .amendments(let value):
                return value
            case .check(let value):
                return value
            case .depositPreauth(let value):
                return value
            case .directoryNode(let value):
                return value
            case .escrow(let value):
                return value
            case .feeSettings(let value):
                return value
            case .ledgerHashes(let value):
                return value
            case .negativeUNL(let value):
                return value
            case .offer(let value):
                return value
            case .payChannel(let value):
                return value
            case .rippleState(let value):
                return value
            case .signerList(let value):
                return value
            case .ticket(let value):
                return value
        }
    }

    func value() -> String? {
        switch self {
            case .directoryNode:
                return "DirectoryNode"
            case .accountRoot:
                return "AccountRoot"
            case .amendments:
                return "Amendments"
            case .check:
                return "Check"
            case .depositPreauth:
                return "DepositPreauth"
            case .escrow:
                return "Escrow"
            case .feeSettings:
                return "FeeSettings"
            case .ledgerHashes:
                return "LedgerHashes"
            case .negativeUNL:
                return "NegativeUNL"
            case .offer:
                return "Offer"
            case .payChannel:
                return "PayChannel"
            case .rippleState:
                return "RippleState"
            case .signerList:
                return "SignerList"
            case .ticket:
                return "Ticket"
        }
    }
}
