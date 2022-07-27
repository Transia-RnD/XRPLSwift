//
//  TransactionTypes.swift
//  
//
//  Created by Denis Angell on 6/4/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/types/transaction_type.py

enum TransactionType: String {
    case invalid
    case Payment
    case EscrowCreate
    case EscrowFinish
    case EscrowCancel
    case SetRegularKey
    case NickNameSet
    case OfferCreate
    case OfferCancel
    case Contract
    case TicketCreate
    case TicketCancel
    case SignerListSet
    case PaymentChannelCreate
    case PaymentChannelFund
    case PaymentChannelClaim
    case CheckCreate
    case CheckCash
    case CheckCancel
    case DepositPreauth
    case TrustSet
    case AccountDelete
    case NFTokenMint
    case NFTokenBurn
    case NFTokenCreateOffer
    case NFTokenCancelOffer
    case NFTokenAcceptOffer
    case EnableAmendment
    case SetFee
    case SetHook
    case UNLModify
}
