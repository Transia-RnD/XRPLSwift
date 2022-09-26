//
//  SubmitSugar.swift
//  
//
//  Created by Denis Angell on 8/1/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/sugar/submit.ts

import Foundation
import NIO

/** Approximate time for a ledger to close, in milliseconds */
// swiftlint:disable:next identifier_name
let LEDGER_CLOSE_TIME = 4000

/**
 * Submits a signed/unsigned transaction.
 * Steps performed on a transaction:
 *    1. Autofill.
 *    2. Sign & Encode.
 *    3. Submit.
 *
 * @param this - A Client.
 * @param transaction - A transaction to autofill, sign & encode, and submit.
 * @param opts - (Optional) Options used to sign and submit a transaction.
 * @param opts.autofill - If true, autofill a transaction.
 * @param opts.failHard - If true, and the transaction fails locally, do not retry or relay the transaction to other servers.
 * @param opts.wallet - A wallet to sign a transaction. It must be provided when submitting an unsigned transaction.
 * @returns A promise that contains SubmitResponse.
 * @throws RippledError if submit request fails.
 */

public enum SubmitTransaction: Codable {
    case tx(Transaction)
    case string(String)
}

extension SubmitTransaction {

    enum AmountCodingError: Error {
        case decoding(String)
    }

    public init(from decoder: Decoder) throws {
        if let value = try? Transaction.init(from: decoder) {
            self = .tx(value)
            return
        }
        if let value = try? String.init(from: decoder) {
            self = .string(value)
            return
        }
        throw AmountCodingError.decoding("SubmitTransaction not mapped")
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .tx(let tx):
            try tx.encode(to: encoder)
        case .string(let string):
            try string.encode(to: encoder)
        }
    }
}

public class SubmitOptions {
    public var autofill: Bool?
    public var failHard: Bool?
    public var wallet: Wallet

    public init(
        autofill: Bool?,
        failHard: Bool?,
        wallet: Wallet
    ) {
        self.autofill = autofill
        self.failHard = failHard
        self.wallet = wallet
    }
}

func submit(
    this: XrplClient,
    transaction: Transaction,
    autofill: Bool? = false,
    failHard: Bool? = false,
    wallet: Wallet?
// ) async throws -> EventLoopFuture<TxResponse> {
) async throws -> EventLoopFuture<Any> {
    let signedTx = try await getSignedTx(client: this, transaction: transaction, wallet: wallet)
    return try await submitRequest(client: this, signedTransaction: signedTx, failHard: failHard)
}

/**
 * Asynchronously submits a transaction and verifies that it has been included in a
 * validated ledger (or has errored/will not be included for some reason).
 * See [Reliable Transaction Submission](https://xrpl.org/reliable-transaction-submission.html).
 *
 * @param this - A Client.
 * @param transaction - A transaction to autofill, sign & encode, and submit.
 * @param opts - (Optional) Options used to sign and submit a transaction.
 * @param opts.autofill - If true, autofill a transaction.
 * @param opts.failHard - If true, and the transaction fails locally, do not retry or relay the transaction to other servers.
 * @param opts.wallet - A wallet to sign a transaction. It must be provided when submitting an unsigned transaction.
 * @returns A promise that contains TxResponse, that will return when the transaction has been validated.
 */
func submitAndWait(
    this: XrplClient,
    //  transaction: Transaction | string,
    transaction: Transaction,
    opts: SubmitOptions? = nil
// ) async throws -> EventLoopFuture<TxResponse> {
) async throws -> String {
    let signedTx = try await getSignedTx(
        client: this,
        transaction: transaction,
        autofill: (opts?.autofill)!,
        wallet: opts?.wallet
    )

    let lastLedger: Int? = getLastLedgerSequence(transaction: signedTx)
    if lastLedger == nil {
        throw ValidationError("Transaction must contain a LastLedgerSequence value for reliable submission.")
    }

    let response = try await submitRequest(client: this, signedTransaction: signedTx, failHard: opts?.failHard)
//    let txHash = opts?.hashes.hashSignedTx(signedTx)
    //    return waitForFinalTransactionOutcome(
    //        this,Int
    //        txHash,
    //        lastLedger,
    //        response.result.engine_result,
    //    )
    return ""
}

// Helper functions

// Encodes and submits a signed transaction.
func submitRequest(
    client: XrplClient,
    signedTransaction: Transaction,
    failHard: Bool? = false
// ) async throws -> EventLoopFuture<SubmitResponse> {
) async throws -> EventLoopFuture<Any> {
    if !isSigned(transaction: try signedTransaction.toJson()) {
        throw ValidationError("Transaction must be signed")
    }
    let signedTxEncoded: String = try BinaryCodec.encode(json: signedTransaction.toJson())
    let request = SubmitRequest(
        txBlob: signedTxEncoded,
//        failHard: isAccountDelete(transaction: signedTransaction) || failHard!
        failHard: failHard!
    )
    return try await client.request(req: request)!
}

func submitRequest(
    client: XrplClient,
    signedTransaction: String,
    failHard: Bool? = false
// ) async throws -> EventLoopFuture<SubmitResponse> {
) async throws -> EventLoopFuture<Any> {
    if !isSigned(transaction: signedTransaction) {
        throw ValidationError("Transaction must be signed")
    }

    let signedTxEncoded: String = signedTransaction
    let request = SubmitRequest(
        txBlob: signedTxEncoded,
//        failHard: isAccountDelete(transaction: signedTransaction) || failHard!
        failHard: failHard ?? false
    )
    return try await client.request(req: request)!
}

/// *
// * The core logic of reliable submission.  This polls the ledger until the result of the
// * transaction can be considered final, meaning it has either been included in a
// * validated ledger, or the transaction"s lastLedgerSequence has been surpassed by the
// * latest ledger sequence (meaning it will never be included in a validated ledger).
// */
//// eslint-disable-next-line max-params, max-lines-per-function -- this function needs to display and do with more information.
// func waitForFinalTransactionOutcome(
//  client: Client,
//  txHash: string,
//  lastLedger: number,
//  submissionResult: string,
// ) -> async EventLoopFuture<TxResponse> {
//  await sleep(LEDGER_CLOSE_TIME)
//
//  const latestLedger = await client.getLedgerIndex()
//
//  if (lastLedger < latestLedger) {
//    throw new XrplError(
//      `The latest ledger sequence ${latestLedger} is greater than the transaction"s LastLedgerSequence (${lastLedger}).\n` +
//        `Preliminary result: ${submissionResult}`,
//    )
//  }
//
//  const txResponse = await client
//    .request({
//      command: "tx",
//      transaction: txHash,
//    })
//    .catch(async (error) => {
//      // error is of an unknown type and hence we assert type to extract the value we need.
//      // eslint-disable-next-line @typescript-eslint/consistent-type-assertions,@typescript-eslint/no-unsafe-member-access -- ^
//      const message = error?.data?.error as string
//      if (message === "txnNotFound") {
//        return waitForFinalTransactionOutcome(
//          client,
//          txHash,
//          lastLedger,
//          submissionResult,
//        )
//      }
//      throw new Error(
//        `${message} \n Preliminary result: ${submissionResult}.\nFull error details: ${String(
//          error,
//        )}`,
//      )
//    })
//
//  if (txResponse.result.validated) {
//    return txResponse
//  }
//
//  return waitForFinalTransactionOutcome(
//    client,
//    txHash,
//    lastLedger,
//    submissionResult,
//  )
// }

// checks if the transaction has been signed
func isSigned(transaction: String) -> Bool {
    let tx = BinaryCodec.decode(buffer: transaction)
    return isSigned(transaction: tx)
}
func isSigned(transaction: [String: AnyObject]) -> Bool {
    return transaction["SigningPubKey"] != nil || transaction["TxnSignature"] != nil
}

// initializes a transaction for a submit request
func getSignedTx(
    client: XrplClient,
    transaction: String,
    autofill: Bool? = true,
    wallet: Wallet?
// ) async throws -> EventLoopFuture<String> {
) async throws -> String {
    if isSigned(transaction: transaction) {
        return transaction
    }

    guard let wallet = wallet else {
        throw ValidationError("Wallet must be provided when submitting an unsigned transaction")
    }

    //    let tx = transaction is String ? (decode(transaction) as? Transaction) : transaction
//    let encoder = JSONEncoder()
//    let txs = try encoder.encode(transaction)
//    var tx = try transaction.toAny() as! BaseTransaction
//    if autofill {
//        tx = try await AutoFillSugar().autofill(client: client, transaction: tx, signersCount: 0).wait()
//    }
//    return try opts.wallet.sign(transaction: transaction, multisign: false).txBlob
    return ""
}
func getSignedTx(
    client: XrplClient,
    transaction: Transaction,
    autofill: Bool = true,
    wallet: Wallet?
) async throws -> String {
//    if isSigned(transaction: transaction) {
//        return transaction
//    }
    guard let wallet = wallet else {
        throw ValidationError("Wallet must be provided when submitting an unsigned transaction")
    }
//    var tx = try transaction.toAny() as! BaseTransaction
    var tx = try transaction.toJson() as! [String: AnyObject]
    if autofill {
        tx = try await AutoFillSugar().autofill(client: client, transaction: tx, signersCount: 0).wait()
    }
    return try wallet.sign(transaction: tx, multisign: false).txBlob
}

// checks if there is a LastLedgerSequence as a part of the transaction
func getLastLedgerSequence(
    //  transaction: Transaction | string,
    transaction: String
) -> Int? {
//    let tx = typeof transaction === "string" ? decode(transaction) : transaction
    let tx = transaction
    //   eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- converts LastLedgSeq to number if present.

//    return tx.LastLedgerSequence as? Int
    return 0
}

// checks if the transaction is an AccountDelete transaction
func isAccountDelete(transaction: SubmitTransaction) -> Bool {
//    let tx = transaction is String ? BinaryCodec.decode(transaction) : transaction
    let tx = transaction
//    return tx.TransactionType == "AccountDelete"
    return false
}
