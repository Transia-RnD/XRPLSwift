//
//  Transaction.swift
//
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/transaction.ts

import Foundation

/**
 
 */
public enum rTransaction: Codable {
    case accountDelete(AccountDelete)
    case accountSet(AccountSet)
    case checkCancel(CheckCancel)
    case checkCash(CheckCash)
    case checkCreate(CheckCreate)
    case depositPreauth(DepositPreauth)
    case escrowCancel(EscrowCancel)
    case escrowCreate(EscrowCreate)
    case escrowFinish(EscrowFinish)
    case nfTokenAcceptOffer(NFTokenAcceptOffer)
    case nfTokenBurn(NFTokenBurn)
    case nfTokenCancelOffer(NFTokenCancelOffer)
    case nfTokenCreateOffer(NFTokenCreateOffer)
    case nfTokenMint(NFTokenMint)
    case offerCancel(OfferCancel)
    case offerCreate(OfferCreate)
    case payment(Payment)
    case paymentChannelClaim(PaymentChannelClaim)
    case paymentChannelCreate(PaymentChannelCreate)
    case paymentChannelFund(PaymentChannelFund)
    case setRegularKey(SetRegularKey)
    case signerListSet(SignerListSet)
    //  case ticketCreate(TicketCreate)
    case trustSet(TrustSet)
}

extension rTransaction {
    
    enum TransactionCodingError: Error {
        case decoding(String)
    }
    
    func toJson() throws -> [String: AnyObject] {
//        self.encode(to: <#T##Encoder#>)
//        return String(data: try self.jsonData(), encoding: encoding)
        return [:]
    }
    
    public func toAny() throws -> Any {
        switch self {
        case .accountDelete(let value):
            return value
        case .accountSet(let value):
            return value
        case .checkCancel(let value):
            return value
        case .checkCreate(let value):
            return value
        case .checkCash(let value):
            return value
        case .depositPreauth(let value):
            return value
        case .escrowFinish(let value):
            return value
        case .escrowCancel(let value):
            return value
        case .escrowCreate(let value):
            return value
        case .nfTokenAcceptOffer(let value):
            return value
        case .nfTokenBurn(let value):
            return value
        case .nfTokenCancelOffer(let value):
            return value
        case .nfTokenCreateOffer(let value):
            return value
        case .nfTokenMint(let value):
            return value
        case .offerCancel(let value):
            return value
        case .offerCreate(let value):
            return value
        case .payment(let value):
            return value
        case .paymentChannelClaim(let value):
            return value
        case .paymentChannelCreate(let value):
            return value
        case .paymentChannelFund(let value):
            return value
        case .setRegularKey(let value):
            return value
        case .signerListSet(let value):
            return value
        case .trustSet(let value):
            return value
        }
    }
    
    public init(from decoder: Decoder) throws {
        if let value = try? AccountDelete.init(from: decoder) {
            self = .accountDelete(value)
            return
        }
        if let value = try? AccountSet.init(from: decoder) {
            self = .accountSet(value)
            return
        }
        if let value = try? CheckCancel.init(from: decoder) {
            self = .checkCancel(value)
            return
        }
        if let value = try? CheckCreate.init(from: decoder) {
            self = .checkCreate(value)
            return
        }
        if let value = try? EscrowFinish.init(from: decoder) {
            self = .escrowFinish(value)
            return
        }
        if let value = try? NFTokenAcceptOffer.init(from: decoder) {
            self = .nfTokenAcceptOffer(value)
            return
        }
        if let value = try? NFTokenBurn.init(from: decoder) {
            self = .nfTokenBurn(value)
            return
        }
        if let value = try? NFTokenCancelOffer.init(from: decoder) {
            self = .nfTokenCancelOffer(value)
            return
        }
        if let value = try? NFTokenCreateOffer.init(from: decoder) {
            self = .nfTokenCreateOffer(value)
            return
        }
        
        if let value = try? NFTokenMint.init(from: decoder) {
            self = .nfTokenMint(value)
            return
        }
        if let value = try? OfferCancel.init(from: decoder) {
            self = .offerCancel(value)
            return
        }
        if let value = try? OfferCreate.init(from: decoder) {
            self = .offerCreate(value)
            return
        }
        if let value = try? Payment.init(from: decoder) {
            self = .payment(value)
            return
        }
        if let value = try? PaymentChannelClaim.init(from: decoder) {
            self = .paymentChannelClaim(value)
            return
        }
        if let value = try? PaymentChannelCreate.init(from: decoder) {
            self = .paymentChannelCreate(value)
            return
        }
        if let value = try? PaymentChannelFund.init(from: decoder) {
            self = .paymentChannelFund(value)
            return
        }
        if let value = try? SetRegularKey.init(from: decoder) {
            self = .setRegularKey(value)
            return
        }
        if let value = try? SignerListSet.init(from: decoder) {
            self = .signerListSet(value)
            return
        }
        //        if let value = try? TicketCreate.init(from: decoder) {
        //            self = .TicketCreate(value)
        //            return
        //        }
        if let value = try? TrustSet.init(from: decoder) {
            self = .trustSet(value)
            return
        }
        throw TransactionCodingError.decoding("DENIS!!!")
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .accountDelete(let value):
            try value.encode(to: encoder)
        case .accountSet(let value):
            try value.encode(to: encoder)
        case .checkCancel(let value):
            try value.encode(to: encoder)
        case .checkCreate(let value):
            try value.encode(to: encoder)
        case .checkCash(let value):
            try value.encode(to: encoder)
        case .depositPreauth(let value):
            try value.encode(to: encoder)
        case .escrowFinish(let value):
            try value.encode(to: encoder)
        case .escrowCancel(let value):
            try value.encode(to: encoder)
        case .escrowCreate(let value):
            try value.encode(to: encoder)
        case .nfTokenAcceptOffer(let value):
            try value.encode(to: encoder)
        case .nfTokenBurn(let value):
            try value.encode(to: encoder)
        case .nfTokenCancelOffer(let value):
            try value.encode(to: encoder)
        case .nfTokenCreateOffer(let value):
            try value.encode(to: encoder)
            
        case .nfTokenMint(let value):
            try value.encode(to: encoder)
        case .offerCancel(let value):
            try value.encode(to: encoder)
        case .offerCreate(let value):
            try value.encode(to: encoder)
        case .payment(let value):
            try value.encode(to: encoder)
        case .paymentChannelClaim(let value):
            try value.encode(to: encoder)
        case .paymentChannelCreate(let value):
            try value.encode(to: encoder)
        case .paymentChannelFund(let value):
            try value.encode(to: encoder)
        case .setRegularKey(let value):
            try value.encode(to: encoder)
        case .signerListSet(let value):
            try value.encode(to: encoder)
            //        case .ticketCreate(let TicketCreate):
            //            try TicketCreate.encode(to: encoder)
        case .trustSet(let value):
            try value.encode(to: encoder)
        }
    }
}



/**
 * @category Transaction Models
 */
public class rTransactionAndMetadata: Codable {
    public let transaction: rTransaction
    public let metadata: rTransactionMetadata
    
//    enum CodingKeys: String, CodingKey {
//        case transaction = "transaction"
//        case metadata = "metadata"
//    }
//    
//    required public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        transaction = try values.decode(rTransaction.self, forKey: .transaction)
//        metadata = try values.decode(rTransactionMetadata.self, forKey: .metadata)
//    }
}

/**
 * Verifies various Transaction Types.
 * Encode/decode and individual type validation.
 *
 * @param transaction - A Transaction.
 * @throws ValidationError When the Transaction is malformed.
 * @category Utilities
 */
func validate(transaction: [String: Any]) throws {
    guard let tx = transaction as? BaseTransaction else {
        throw XrplError.validation("Object does not have a `TransactionType`")
    }
//    if tx. == nil {
//        throw XrplError.validation("Object does not have a `TransactionType`")
//    }
    // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- okay here
//    setTransactionFlagsToNumber(tx)
//    switch (tx.TransactionType) {
//    case "AccountDelete":
//        validateAccountDelete(tx)
//        break
//
//    case "AccountSet":
//        validateAccountSet(tx)
//        break
//
//    case "CheckCancel":
//        validateCheckCancel(tx)
//        break
//
//    case "CheckCash":
//        validateCheckCash(tx)
//        break
//
//    case "CheckCreate":
//        validateCheckCreate(tx)
//        break
//
//    case "DepositPreauth":
//        validateDepositPreauth(tx)
//        break
//
//    case "EscrowCancel":
//        validateEscrowCancel(tx)
//        break
//
//    case "EscrowCreate":
//        validateEscrowCreate(tx)
//        break
//
//    case "EscrowFinish":
//        validateEscrowFinish(tx)
//        break
//
//    case "NFTokenAcceptOffer":
//        validateNFTokenAcceptOffer(tx)
//        break
//
//    case "NFTokenBurn":
//        validateNFTokenBurn(tx)
//        break
//
//    case "NFTokenCancelOffer":
//        validateNFTokenCancelOffer(tx)
//        break
//
//    case "NFTokenCreateOffer":
//        validateNFTokenCreateOffer(tx)
//        break
//
//    case "NFTokenMint":
//        validateNFTokenMint(tx)
//        break
//
//    case "OfferCancel":
//        validateOfferCancel(tx)
//        break
//
//    case "OfferCreate":
//        validateOfferCreate(tx)
//        break
//
//    case "Payment":
//        validatePayment(tx)
//        break
//
//    case "PaymentChannelClaim":
//        validatePaymentChannelClaim(tx)
//        break
//
//    case "PaymentChannelCreate":
//        validatePaymentChannelCreate(tx)
//        break
//
//    case "PaymentChannelFund":
//        validatePaymentChannelFund(tx)
//        break
//
//    case "SetRegularKey":
//        validateSetRegularKey(tx)
//        break
//
//    case "SignerListSet":
//        validateSignerListSet(tx)
//        break
//
//    case "TicketCreate":
//        validateTicketCreate(tx)
//        break
//
//    case "TrustSet":
//        validateTrustSet(tx)
//        break
        
//    default:
//        throw XrplError.validation("Invalid field TransactionType: ${tx.TransactionType}")
//    }
//    throw XrplError.validation("Invalid Transaction: \(tx.TransactionType)")
//    if (
//        !_.isEqual(
//            decode(encode(tx)),
//            _.omitBy(tx, (value) => value == null),
//        )
//    ) {
//        throw new ValidationError(`Invalid Transaction: ${tx.TransactionType}`)
//    }
}
