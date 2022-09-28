//
//  LedgerEntry.swift
//
//
//  Created by Denis Angell on 7/27/22.
//

import Foundation

public enum LedgerEntry: Codable {
    case accountRoot
    case amendments
    case check
    case depositPreauth
    case directoryNode(Node)
    case escrow
    case feeSettings
    case ledgerHashes
    case negativeUNL
    case offer
    case payChannel
    case rippleState
    case signerList
    case ticket
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

    func get() -> Any? {
        switch self {
        case .accountRoot:
            return nil
        case .amendments:
            return nil
        case .check:
            return nil
        case .depositPreauth:
            return nil
        case .directoryNode(let value):
            return value
        case .escrow:
            return nil
        case .feeSettings:
            return nil
        case .ledgerHashes:
            return nil
        case .negativeUNL:
            return nil
        case .offer:
            return nil
        case .payChannel:
            return nil
        case .rippleState:
            return nil
        case .signerList:
            return nil
        case .ticket:
            return nil
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
