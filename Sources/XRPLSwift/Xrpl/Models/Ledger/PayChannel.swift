//
//  PayChannel.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/PayChannel.ts

import Foundation

/**
 The PayChannel object type represents a payment channel. Payment channels
 enable small, rapid off-ledger payments of XRP that can be later reconciled
 with the consensus ledger. A payment channel holds a balance of XRP that can
 only be paid out to a specific destination address until the channel is
 closed.
 */
open class PayChannel: BaseLedgerEntry {
    var ledgerEntryType: String = "PayChannel"
    /**
     The source address that owns this payment channel. This comes from the
     sending address of the transaction that created the channel.
     */
    let account: String
    /**
     The destination address for this payment channel. While the payment
     channel is open, this address is the only one that can receive XRP from the
     channel. This comes from the Destination field of the transaction that
     created the channel.
     */
    let destination: String
    /**
     Total XRP, in drops, that has been allocated to this channel. This
     includes XRP that has been paid to the destination address. This is
     initially set by the transaction that created the channel and can be
     increased if the source address sends a PaymentChannelFund transaction.
     */
    let amount: String
    /**
     Total XRP, in drops, already paid out by the channel. The difference
     between this value and the Amount field is how much XRP can still be paid
     to the destination address with PaymentChannelClaim transactions. If the
     channel closes, the remaining difference is returned to the source address.
     */
    let balance: String
    /**
     Public key, in hexadecimal, of the key pair that can be used to sign
     claims against this channel. This can be any valid secp256k1 or Ed25519
     public key. This is set by the transaction that created the channel and
     must match the public key used in claims against the channel. The channel
     source address can also send XRP from this channel to the destination
     without signed claims.
     */
    let publicKey: String
    /**
     Number of seconds the source address must wait to close the channel if
     it still has any XRP in it. Smaller values mean that the destination
     address has less time to redeem any outstanding claims after the source
     address requests to close the channel. Can be any value that fits in a
     32-bit unsigned integer (0 to 2^32-1). This is set by the transaction that
     creates the channel.
     */
    let settleDelay: Int
    /**
     A hint indicating which page of the source address's owner directory links
     to this object, in case the directory consists of multiple pages.
     */
    let ownerNode: String
    /**
     The identifying hash of the transaction that most recently modified this
     object.
     */
    let previousTxnId: String
    /**
     The index of the ledger that contains the transaction that most recently
     modified this object.
     */
    let previousTxnLgrSeq: Int
    /**
     A bit-map of boolean flags enabled for this payment channel. Currently,
     the protocol defines no flags for PayChannel objects.
     */
    let flags: Int
    /**
     The mutable expiration time for this payment channel, in seconds since the
     Ripple Epoch. The channel is expired if this value is present and smaller
     than the previous ledger's close_time field. See Setting Channel Expiration
     for more details.
     */
    let expiration: Int?
    /**
     The immutable expiration time for this payment channel, in seconds since
     the Ripple Epoch. This channel is expired if this value is present and
     smaller than the previous ledger's close_time field. This is optionally
     set by the transaction that created the channel, and cannot be changed.
     */
    let cancelAfter: Int?
    /**
     An arbitrary tag to further specify the source for this payment channel
     useful for specifying a hosted recipient at the owner's address.
     */
    let sourceTag: Int?
    /**
     An arbitrary tag to further specify the destination for this payment
     channel, such as a hosted recipient at the destination address.
     */
    let destinationTag: Int?
    /**
     A hint indicating which page of the destination's owner directory links to
     this object, in case the directory consists of multiple pages.
     */
    let destinationNode: Int?

    enum CodingKeys: String, CodingKey {
        case account = "Account"
        case destination = "Destination"
        case amount = "Amount"
        case balance = "Balance"
        case publicKey = "PublicKey"
        case settleDelay = "SettleDelay"
        case ownerNode = "OwnerNode"
        case previousTxnId = "PreviousTxnID"
        case previousTxnLgrSeq = "PreviousTxnLgrSeq"
        case flags = "Flags"
        case expiration = "Expiration"
        case cancelAfter = "CancelAfter"
        case sourceTag = "SourceTag"
        case destinationTag = "DestinationTag"
        case destinationNode = "DestinationNode"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        destination = try values.decode(String.self, forKey: .destination)
        amount = try values.decode(String.self, forKey: .amount)
        balance = try values.decode(String.self, forKey: .balance)
        publicKey = try values.decode(String.self, forKey: .publicKey)
        settleDelay = try values.decode(Int.self, forKey: .settleDelay)
        ownerNode = try values.decode(String.self, forKey: .ownerNode)
        previousTxnId = try values.decode(String.self, forKey: .previousTxnId)
        previousTxnLgrSeq = try values.decode(Int.self, forKey: .previousTxnLgrSeq)
        flags = try values.decode(Int.self, forKey: .flags)
        expiration = try? values.decode(Int.self, forKey: .expiration)
        cancelAfter = try? values.decode(Int.self, forKey: .cancelAfter)
        sourceTag = try? values.decode(Int.self, forKey: .sourceTag)
        destinationTag = try? values.decode(Int.self, forKey: .destinationTag)
        destinationNode = try? values.decode(Int.self, forKey: .destinationNode)
        try super.init(from: decoder)
    }
}
