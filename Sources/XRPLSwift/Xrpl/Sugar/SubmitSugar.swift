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
    case tx(rTransaction)
    case string(String)
}

extension SubmitTransaction {
    
    enum rAmountCodingError: Error {
        case decoding(String)
    }
    
    public init(from decoder: Decoder) throws {
        if let value = try? rTransaction.init(from: decoder) {
            self = .tx(value)
            return
        }
        if let value = try? String.init(from: decoder) {
            self = .string(value)
            return
        }
        throw rAmountCodingError.decoding("OOPS")
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
    transaction: rTransaction,
    opts: SubmitOptions?
) async -> EventLoopFuture<TxResponse> {
    let signedTx = await getSignedTx(this, transaction, opts)
    return submitRequest(this, signedTx, opts?.failHard)
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
//func submitAndWait(
//  this: Client,
//  transaction: Transaction | string,
//  opts?: {
//    // If true, autofill a transaction.
//    autofill?: boolean
//    // If true, and the transaction fails locally, do not retry or relay the transaction to other servers.
//    failHard?: boolean
//    // A wallet to sign a transaction. It must be provided when submitting an unsigned transaction.
//    wallet?: Wallet
//  },
//) -> async EventLoopFuture<TxResponse> {
//  const signedTx = await getSignedTx(this, transaction, opts)
//
//  const lastLedger = getLastLedgerSequence(signedTx)
//  if (lastLedger == null) {
//    throw new ValidationError(
//      "Transaction must contain a LastLedgerSequence value for reliable submission.",
//    )
//  }
//
//  const response = await submitRequest(this, signedTx, opts?.failHard)
//
//  const txHash = hashes.hashSignedTx(signedTx)
//  return waitForFinalTransactionOutcome(
//    this,
//    txHash,
//    lastLedger,
//    response.result.engine_result,
//  )
//}

// Helper functions

// Encodes and submits a signed transaction.
func submitRequest(
client: XrplClient,
//  signedTransaction: Transaction | string,
signedTransaction: rTransaction,
failHard = false,
) async -> EventLoopFuture<SubmitResponse> {
    if (!isSigned(signedTransaction)) {
        throw new ValidationError("Transaction must be signed")
    }
    
    const signedTxEncoded =
    typeof signedTransaction === "string"
    ? signedTransaction
    : encode(signedTransaction)
    const request: SubmitRequest = {
    command: "submit",
    tx_blob: signedTxEncoded,
    fail_hard: isAccountDelete(signedTransaction) || failHard,
    }
    return client.request(request)
}

///*
// * The core logic of reliable submission.  This polls the ledger until the result of the
// * transaction can be considered final, meaning it has either been included in a
// * validated ledger, or the transaction"s lastLedgerSequence has been surpassed by the
// * latest ledger sequence (meaning it will never be included in a validated ledger).
// */
//// eslint-disable-next-line max-params, max-lines-per-function -- this function needs to display and do with more information.
//func waitForFinalTransactionOutcome(
//  client: Client,
//  txHash: string,
//  lastLedger: number,
//  submissionResult: string,
//) -> async EventLoopFuture<TxResponse> {
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
//}

// checks if the transaction has been signed
//func isSigned(transaction: Transaction | String) -> Bool {
func isSigned(transaction: rTransaction) -> Bool {
    return false
    //    let tx = transaction is String ? decode(transaction) : transaction
    //    return (
    //        tx is String &&
    //        (tx.signingPubKey != nil || tx.txnSignature != nil)
    //    )
}

// initializes a transaction for a submit request
func getSignedTx(
    client: XrplClient,
    //  transaction: Transaction | string,
    transaction: rTransaction,
    opts: SubmitOptions
) async throws -> EventLoopFuture<rTransaction> {
    //    if isSigned(transaction: transaction) {
    //        return transaction
    //    }
    
    if opts.wallet == nil {
        throw XrplError.validation("Wallet must be provided when submitting an unsigned transaction")
    }
    
    //    let tx = transaction is String ? (decode(transaction) as? rTransaction) : transaction
    var tx = transaction
    if opts.autofill! {
        tx = AutoFillSugar().autofill(client: client, transaction: tx, signersCount: 0).wait()
    }
    
//    return opts.wallet.sign(tx).txBlob
}

//// checks if there is a LastLedgerSequence as a part of the transaction
//func getLastLedgerSequence(
//  transaction: Transaction | string,
//) -> Int? {
//  const tx = typeof transaction === "string" ? decode(transaction) : transaction
//  // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- converts LastLedgSeq to number if present.
//  return tx.LastLedgerSequence as? Int
//}
//
//// checks if the transaction is an AccountDelete transaction
//func isAccountDelete(transaction: SubmitTransaction) -> Bool {
//  const tx = typeof transaction === "string" ? decode(transaction) : transaction
//  return tx.TransactionType === "AccountDelete"
//}
