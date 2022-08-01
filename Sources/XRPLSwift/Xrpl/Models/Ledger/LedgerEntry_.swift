//
//  File.swift
//  
//
//  Created by Denis Angell on 7/27/22.
//

import Foundation

//import AccountRoot from './AccountRoot'
//import Amendments from './Amendments'
//import Check from './Check'
//import DepositPreauth from './DepositPreauth'
//import DirectoryNode from './DirectoryNode'
//import Escrow from './Escrow'
//import FeeSettings from './FeeSettings'
//import LedgerHashes from './LedgerHashes'
//import NegativeUNL from './NegativeUNL'
//import Offer from './Offer'
//import PayChannel from './PayChannel'
//import RippleState from './RippleState'
//import SignerList from './SignerList'
//import Ticket from './Ticket'

enum LedgerEntry: Codable {
    case AccountRoot
    case Amendments
    case Check
    case DepositPreauth
    case DirectoryNode(rNode)
    case Escrow
    case FeeSettings
    case LedgerHashes
    case NegativeUNL
    case Offer
    case PayChannel
    case RippleState
    case SignerList
    case Ticket
    
    func get() -> Any? {
        switch self {
        case .DirectoryNode(let DirectoryNode):
            return DirectoryNode
        case .AccountRoot:
            return nil
        case .Amendments:
            return nil
        case .Check:
            return nil
        case .DepositPreauth:
            return nil
        case .Escrow:
            return nil
        case .FeeSettings:
            return nil
        case .LedgerHashes:
            return nil
        case .NegativeUNL:
            return nil
        case .Offer:
            return nil
        case .PayChannel:
            return nil
        case .RippleState:
            return nil
        case .SignerList:
            return nil
        case .Ticket:
            return nil
        }
    }
    
    func value() -> String? {
        switch self {
        case .DirectoryNode:
            return "DirectoryNode"
        case .AccountRoot:
            return "AccountRoot"
        case .Amendments:
            return "Amendments"
        case .Check:
            return "Check"
        case .DepositPreauth:
            return "DepositPreauth"
        case .Escrow:
            return "Escrow"
        case .FeeSettings:
            return "FeeSettings"
        case .LedgerHashes:
            return "LedgerHashes"
        case .NegativeUNL:
            return "NegativeUNL"
        case .Offer:
            return "Offer"
        case .PayChannel:
            return "PayChannel"
        case .RippleState:
            return "RippleState"
        case .SignerList:
            return "SignerList"
        case .Ticket:
            return "Ticket"
        }
    }
}
