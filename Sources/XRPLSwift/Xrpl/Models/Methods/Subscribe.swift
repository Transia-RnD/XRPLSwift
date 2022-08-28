////
////  File.swift
////
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/subscribe.ts
//
// import Foundation
//
//
// struct Book {
//  /**
//   * Specification of which currency the account taking the Offer would
//   * receive, as a currency object with no amount.
//   */
//    let taker_gets: Currency
//  /**
//   * Specification of which currency the account taking the Offer would pay, as
//   * a currency object with no amount.
//   */
//    let taker_pays: Currency
//  /**
//   * Unique account address to use as a perspective for viewing offers, in the.
//   * XRP Ledger's base58 format.
//   */
//    let taker: String
//  /**
//   * If true, return the current state of the order book once when you
//   * subscribe before sending updates. The default is false.
//   */
//    let snapshot?: boolean
//  /** If true, return both sides of the order book. The default is false. */
//    let both?: boolean
// }
//
/// **
// * The subscribe method requests periodic notifications from the server when
// * certain events happen. Expects a response in the form of a.
// * {@link SubscribeResponse}.
// *
// * @category Requests
// */
// open class SubscribeRequest: BaseRequest {
//    let command: String = "subscribe"
//  /** Array of string names of generic streams to subscribe to. */
//    let streams?: StreamType[]
//  /**
//   * Array with the unique addresses of accounts to monitor for validated
//   * transactions. The addresses must be in the XRP Ledger's base58 format.
//   * The server sends a notification for any transaction that affects at least
//   * one of these accounts.
//   */
//    let accounts?: [String]
//  /** Like accounts, but include transactions that are not yet finalized. */
//    let accounts_proposed?: [String]
//  /**
//   * Array of objects defining order books  to monitor for updates, as detailed
//   * Below.
//   */
//    let books?: Book[]
//  /**
//   * URL where the server sends a JSON-RPC callbacks for each event.
//   * Admin-only.
//   */
//    let url?: String
//  /** Username to provide for basic authentication at the callback URL. */
//    let url_username?: String
//  /** Password to provide for basic authentication at the callback URL. */
//    let url_password?: String
// }
//
// type BooksSnapshot = Offer[]
//
/// **
// * Response expected from a {@link SubscribeRequest}.
// *
// * @category Responses
// */
// open class SubscribeResponse: BaseResponse {
//  result: Record<String, never> | LedgerStreamResponse | BooksSnapshot
// }
//
// struct BaseStream {
//  type: String
// }
//
/// **
// * The `ledger` stream only sends `ledgerClosed` messages when the consensus
// * process declares a new validated ledger. The message identifies the ledger
// * And provides some information about its contents.
// *
// * @category Streams
// */
// open class LedgerStream: BaseStream {
//    let type: 'ledgerClosed'
//  /**
//   * The reference transaction cost as of this ledger version, in drops of XRP.
//   * If this ledger version includes a SetFee pseudo-transaction the new.
//   * Transaction cost applies starting with the following ledger version.
//   */
//    let fee_base: Int
//  /** The reference transaction cost in "fee units". */
//    let fee_ref: Int
//  /** The identifying hash of the ledger version that was closed. */
//    let ledger_hash: String
//  /** The ledger index of the ledger that was closed. */
//    let ledger_index: Int
//  /** The time this ledger was closed, in seconds since the Ripple Epoch. */
//    let ledger_time: Int
//  /**
//   * The minimum reserve, in drops of XRP, that is required for an account. If
//   * this ledger version includes a SetFee pseudo-transaction the new base reserve
//   * applies starting with the following ledger version.
//   */
//    let reserve_base: Int
//  /**
//   * The owner reserve for each object an account owns in the ledger, in drops
//   * of XRP. If the ledger includes a SetFee pseudo-transaction the new owner
//   * reserve applies after this ledger.
//   */
//    let reserve_inc: Int
//  /** Number of new transactions included in this ledger version. */
//    let txn_count: Int
//  /**
//   * Range of ledgers that the server has available. This may be a disjoint
//   * sequence such as 24900901-24900984,24901116-24901158. This field is not
//   * returned if the server is not connected to the network, or if it is
//   * connected but has not yet obtained a ledger from the network.
//   */
//    let validated_ledgers?: String
// }
//
/// **
// * This response mirrors the LedgerStream, except it does NOT include the 'type' nor 'txn_count' fields.
// */
//// eslint-disable-next-line import/no-unused-modules -- Detailed enough to be worth exporting for end users.
// open class LedgerStreamResponse {
//  /**
//   * The reference transaction cost as of this ledger version, in drops of XRP.
//   * If this ledger version includes a SetFee pseudo-transaction the new.
//   * Transaction cost applies starting with the following ledger version.
//   */
//    let fee_base: Int
//  /** The reference transaction cost in "fee units". */
//    let fee_ref: Int
//  /** The identifying hash of the ledger version that was closed. */
//    let ledger_hash: String
//  /** The ledger index of the ledger that was closed. */
//    let ledger_index: Int
//  /** The time this ledger was closed, in seconds since the Ripple Epoch. */
//    let ledger_time: Int
//  /**
//   * The minimum reserve, in drops of XRP, that is required for an account. If
//   * this ledger version includes a SetFee pseudo-transaction the new base reserve
//   * applies starting with the following ledger version.
//   */
//    let reserve_base: Int
//  /**
//   * The owner reserve for each object an account owns in the ledger, in drops
//   * of XRP. If the ledger includes a SetFee pseudo-transaction the new owner
//   * reserve applies after this ledger.
//   */
//    let reserve_inc: Int
//  /**
//   * Range of ledgers that the server has available. This may be a disjoint
//   * sequence such as 24900901-24900984,24901116-24901158. This field is not
//   * returned if the server is not connected to the network, or if it is
//   * connected but has not yet obtained a ledger from the network.
//   */
//    let validated_ledgers?: String
// }
//
/// **
// * The validations stream sends messages whenever it receives validation
// * messages, also called validation votes, regardless of whether or not the
// * validation message is from a trusted validator.
// *
// * @category Streams
// */
// open class ValidationStream: BaseStream {
//    let type: 'validationReceived'
//  /**
//   * The value validationReceived indicates this is from the validations
//   * Stream.
//   */
//    let amendments?: [String]
//  /** The amendments this server wants to be added to the protocol. */
//    let base_fee?: Int
//  /**
//   * The unscaled transaction cost (reference_fee value) this server wants to
//   * set by Fee voting.
//   */
//    let flags: Int
//  /**
//   * Bit-mask of flags added to this validation message. The flag 0x80000000
//   * indicates that the validation signature is fully-canonical. The flag
//   * 0x00000001 indicates that this is a full validation; otherwise it's a
//   * partial validation. Partial validations are not meant to vote for any
//   * particular ledger. A partial validation indicates that the validator is
//   * still online but not keeping up with consensus.
//   */
//    let full: Bool
//  /**
//   * If true, this is a full validation. Otherwise, this is a partial
//   * validation. Partial validations are not meant to vote for any particular
//   * ledger. A partial validation indicates that the validator is still online
//   * but not keeping up with consensus.
//   */
//    let ledger_hash: String
//  /** The ledger index of the proposed ledger. */
//    let ledger_index: String
//  /**
//   * The local load-scaled transaction cost this validator is currently
//   * enforcing, in fee units.
//   */
//    let load_fee?: Int
//  /**
//   * The validator's master public key, if the validator is using a validator
//   * token, in the XRP Ledger's base58 format.
//   */
//    let master_key?: String
//  /**
//   * The minimum reserve requirement (`account_reserve` value) this validator
//   * wants to set by fee voting.
//   */
//    let reserve_base?: Int
//  /**
//   * The increment in the reserve requirement (owner_reserve value) this
//   * validator wants to set by fee voting.
//   */
//    let reserve_inc?: Int
//  /** The signature that the validator used to sign its vote for this ledger. */
//    let signature: String
//  /** When this validation vote was signed, in seconds since the Ripple Epoch. */
//    let signing_time: Int
//  /**
//   * The public key from the key-pair that the validator used to sign the
//   * message, in the XRP Ledger's base58 format. This identifies the validator
//   * sending the message and can also be used to verify the signature. If the
//   * validator is using a token, this is an ephemeral public key.
//   */
//    let validation_public_key: String
// }
//
/// **
// * Many subscriptions result in messages about transactions.
// *
// * @category Streams
// */
// open class TransactionStream: BaseStream {
//    let status: String
//    let type: 'transaction'
//  /** String Transaction result code. */
//    let engine_result: String
//  /** Numeric transaction response code, if applicable. */
//    let engine_result_code: Int
//  /** Human-readable explanation for the transaction response. */
//    let engine_result_message: String
//  /**
//   * The ledger index of the current in-progress ledger version for which this
//   * transaction is currently proposed.
//   */
//    let ledger_current_index?: Int
//  /** The identifying hash of the ledger version that includes this transaction. */
//    let ledger_hash?: String
//  /** The ledger index of the ledger version that includes this transaction. */
//    let ledger_index?: Int
//  /**
//   * The transaction metadata, which shows the exact outcome of the transaction
//   * in detail.
//   */
//    let meta?: TransactionMetadata
//  /** The definition of the transaction in JSON format. */
//    let transaction: Transaction & ResponseOnlyTxInfo
//  /**
//   * If true, this transaction is included in a validated ledger and its
//   * outcome is final. Responses from the transaction stream should always be
//   * validated.
//   */
//    let validated?: boolean
//    let warnings?: Array<{ id: Int; message: String }>
// }
//
/// **
// * The admin-only `peer_status` stream reports a large amount of information on
// * the activities of other rippled servers to which this server is connected, in
// * particular their status in the consensus process.
// *
// * @category Streams
// */
// open class PeerStatusStream: BaseStream {
//    let type: 'peerStatusChange'
//  /**
//   * The type of event that prompted this message. See Peer Status Events for
//   * possible values.
//   */
//    let action: 'CLOSING_LEDGER' | 'ACCEPTED_LEDGER' | 'SWITCHED_LEDGER' | 'LOST_SYNC'
//  /** The time this event occurred, in seconds since the Ripple Epoch. */
//    let date: Int
//  /** The identifying Hash of a ledger version to which this message pertains. */
//    let ledger_hash?: String
//  /** The Ledger Index of a ledger version to which this message pertains. */
//    let ledger_index?: Int
//  /** The largest Ledger Index the peer has currently available. */
//    let ledger_index_max?: Int
//  /** The smallest Ledger Index the peer has currently available. */
//    let ledger_index_min?: Int
// }
//
/// **
// * The format of an order book stream message is the same as that of
// * transaction stream messages, except that OfferCreate transactions also
// * contain the following field.
// */
// struct ModifiedOfferCreateTransaction extends OfferCreate {
//  /**
//   * Numeric amount of the TakerGets currency that the Account sending this
//   * OfferCreate transaction has after executing this transaction. This does not
//   * check whether the currency amount is frozen.
//   */
//    let owner_funds: String
// }
//
/// **
// * When you subscribe to one or more order books with the `books` field, you
// * get back any transactions that affect those order books. Has the same format
// * as a {@link TransactionStream} but the transaction can have a `owner_funds`
// * field.
// *
// * @category Streams
// */
// open class OrderBookStream: BaseStream {
//    let status: String
//    let type: 'transaction'
//    let engine_result: String
//    let engine_result_code: Int
//    let engine_result_message: String
//    let ledger_current_index?: Int
//    let ledger_hash?: String
//    let ledger_index?: Int
//    let meta: TransactionMetadata
//    let transaction: (Transaction | ModifiedOfferCreateTransaction) & {
//    /**
//     * This number measures the number of seconds since the "Ripple Epoch" of January 1, 2000 (00:00 UTC)
//     */
//    date?: Int
//    /**
//     * Every signed transaction has a unique "hash" that identifies it.
//     * The transaction hash can be used to look up its final status, which may serve as a "proof of payment"
//     */
//    hash?: String
//  }
//    let validated: Bool
// }
//
/// **
// * The consensus stream sends consensusPhase messages when the consensus
// * process changes phase. The message contains the new phase of consensus the
// * server is in.
// *
// * @category Streams
// */
// open class ConsensusStream: BaseStream {
//    let type: consensusPhase'
//  /**
//   * The new consensus phase the server is in. Possible values are open,
//   * establish, and accepted.
//   */
//    let consensus: 'open' | 'establish' | 'accepted'
// }
//
/// **
// * The path_find method searches for a path along which a transaction can
// * possibly be made, and periodically sends updates when the path changes over
// * time.
// *
// * @category Streams
// */
// open class PathFindStream: BaseStream {
//    let type: 'path_find'
//  /** Unique address that would send a transaction. */
//    let source_account: String
//  /** Unique address of the account that would receive a transaction. */
//    let destination_account: String
//  /** Currency Amount that the destination would receive in a transaction. */
//    let destination_amount: Amount
//  /**
//   * If false, this is the result of an incomplete search. A later reply may
//   * have a better path. If true, then this is the best path found. (It is still
//   * theoretically possible that a better path could exist, but rippled won't
//   * find it.) Until you close the pathfinding request, rippled continues to
//   * send updates each time a new ledger closes.
//   */
//    let full_reply: Bool
//  /** The ID provided in the WebSocket request is included again at this level. */
//    let id: Int | String
//  /** Currency Amount that would be spent in the transaction.  */
//    let send_max?: Amount
//  /**
//   * Array of objects with suggested paths to take. If empty, then no paths
//   * were found connecting the source and destination accounts.
//   */
//    let alternatives:
//    | []
//    | {
//        paths_computed: Path[]
//        source_amount: Amount
//      }
// }
//
/// **
// * @category Streams
// */
// export type Stream =
//  | LedgerStream
//  | ValidationStream
//  | TransactionStream
//  | PathFindStream
//  | PeerStatusStream
//  | OrderBookStream
//  | ConsensusStream
