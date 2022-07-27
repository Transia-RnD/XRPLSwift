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
  case DirectoryNode
  case Escrow
  case FeeSettings
  case LedgerHashes
  case NegativeUNL
  case Offer
  case PayChannel
  case RippleState
  case SignerList
  case Ticket
}
