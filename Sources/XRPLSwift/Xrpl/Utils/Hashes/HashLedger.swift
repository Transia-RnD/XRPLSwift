////
////  HashLedger.swift
////  
////
////  Created by Denis Angell on 8/6/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/hashes/hashLedger.ts
//
//import Foundation
//
//let HEX: Int = 16
//
////interface HashLedgerHeaderOptions {
////  computeTreeHashes?: boolean
////}
//
//func intToHex(integer: Int, byteLength: Int) -> String {
//  let foo = Number(integer)
//    .toString(HEX)
//    .padStart(byteLength * 2, "0")
//
//  return foo
//}
//
//func bytesToHex(bytes: [UInt8]) -> string {
//  return Buffer.from(bytes).toString("hex")
//}
//
//func bigintToHex(
////  integerString: string | number | BigNumber,
//  integerString: String,
//  byteLength: Int
//) -> String {
//  let hex = BigNumber(integerString).toString(HEX)
//  return hex.padStart(byteLength * 2, "0")
//}
//
//func addLengthPrefix(hex: String) -> string {
//  let length = hex.length / 2
//  if length <= 192 {
//    return bytesToHex([length]) + hex
//  }
//  if length <= 12480 {
//    const prefix = length - 193
//    return bytesToHex([193 + (prefix >>> 8), prefix & 0xff]) + hex
//  }
//  if length <= 918744 {
//    const prefix = length - 12481
//    return (
//      bytesToHex([
//        241 + (prefix >>> 16),
//        (prefix >>> 8) & 0xff,
//        prefix & 0xff,
//      ]) + hex
//    )
//  }
//    throw new XrplError.unknown("Variable integer overflow.")
//}
//
///**
// * Hashes the Transaction object as the ledger does. Throws if the transaction is unsigned.
// *
// * @param tx - A transaction to hash. Tx may be in binary blob form. Tx must be signed.
// * @returns A hash of tx.
// * @throws ValidationError if the Transaction is unsigned.\
// * @category Utilities
// */
////public func hashSignedTx(tx: Transaction | string): string {
//public func hashSignedTx(tx: rTransaction) -> String {
//  let txBlob: string
//  let txObject: Transaction
//  if (tx is String) {
//    txBlob = tx
//    /* eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Required until updated in binary codec. */
//    txObject = decode(tx) as unknown as Transaction
//  } else {
//    txBlob = encode(tx)
//    txObject = tx
//  }
//
//  if (txObject.TxnSignature === undefined && txObject.Signers === undefined) {
//    throw new ValidationError('The transaction must be signed to hash it.')
//  }
//
//  const prefix = HashPrefix.TRANSACTION_ID.toString(16).toUpperCase()
//  return sha512Half(prefix.concat(txBlob))
//}
//
///**
// * Compute the hash of a ledger.
// *
// * @param ledgerHeader - Ledger to compute the hash of.
// * @returns The hash of the ledger.
// * @category Utilities
// */
//public func hashLedgerHeader(ledgerHeader: rLedger) -> String {
//  let prefix = HashPrefix.LEDGER.toString(HEX).toUpperCase()
//
//  let ledger =
//    prefix +
//    intToHex(Number(ledgerHeader.ledger_index), 4) +
//    bigintToHex(ledgerHeader.total_coins, 8) +
//    ledgerHeader.parent_hash +
//    ledgerHeader.transaction_hash +
//    ledgerHeader.account_hash +
//    intToHex(ledgerHeader.parent_close_time, 4) +
//    intToHex(ledgerHeader.close_time, 4) +
//    intToHex(ledgerHeader.close_time_resolution, 1) +
//    intToHex(ledgerHeader.close_flags, 1)
//
//  return sha512Half(ledger)
//}
//
///**
// * Compute the root hash of the SHAMap containing all transactions.
// *
// * @param transactions - List of Transactions.
// * @returns The root hash of the SHAMap.
// * @category Utilities
// */
//public func hashTxTree(
//  transactions: Array<Transaction & { metaData?: TransactionMetadata }>,
//) -> String {
//  let shamap = SHAMap()
//  for (const txJSON of transactions) {
//    const txBlobHex = encode(txJSON)
//    const metaHex = encode(txJSON.metaData ?? {})
//    const txHash = hashSignedTx(txBlobHex)
//    const data = addLengthPrefix(txBlobHex) + addLengthPrefix(metaHex)
//    shamap.addItem(txHash, data, NodeType.TRANSACTION_METADATA)
//  }
//
//  return shamap.hash
//}
//
///**
// * Compute the state hash of a list of LedgerEntries.
// *
// * @param entries - List of LedgerEntries.
// * @returns Hash of SHAMap that consists of all entries.
// * @category Utilities
// */
//public func hashStateTree(entries: [LedgerEntry]) -> String {
//  let shamap = SHAMap()
//
//  entries.forEach((ledgerEntry) => {
//    let data = encode(ledgerEntry)
//    shamap.addItem(ledgerEntry.index, data, NodeType.ACCOUNT_STATE)
//  })
//
//  return shamap.hash
//}
//
//func computeTransactionHash(
//  ledger: Ledger,
//  options: HashLedgerHeaderOptions,
//) throws -> String {
//  let { transaction_hash } = ledger
//
//  if (!options.computeTreeHashes) {
//    return transaction_hash
//  }
//
//  if (ledger.transactions == null) {
//      throw XrplError.validation("transactions is missing from the ledger")
//  }
//
//  const transactionHash = hashTxTree(ledger.transactions)
//
//  if (transaction_hash !== transactionHash) {
//    throw new ValidationError(
//      'transactionHash in header' +
//        ' does not match computed hash of transactions',
//      {
//        transactionHashInHeader: transaction_hash,
//        computedHashOfTransactions: transactionHash,
//      },
//    )
//  }
//
//  return transactionHash
//}
//
//func computeStateHash(
//  ledger: Ledger,
//  options: HashLedgerHeaderOptions
//) -> String {
//  let { account_hash } = ledger
//
//  if !options.computeTreeHashes {
//    return account_hash
//  }
//
//  if ledger.accountState == nil {
//    throw new ValidationError('accountState is missing from the ledger')
//  }
//
//  const stateHash = hashStateTree(ledger.accountState)
//
//  if (account_hash !== stateHash) {
//      throw  XrplError.validation(
//      "stateHash in header does not match computed hash of state",
//    )
//  }
//
//  return stateHash
//}
//
///**
// * Compute the hash of a ledger.
// *
// * @param ledger - Ledger to compute the hash for.
// * @param options - Allow client to recompute Transaction and State Hashes.
// * @param options.computeTreeHashes - Whether to recompute the Transaction and State Hashes.
// * @returns The has of ledger.
// * @category Utilities
// */
//public func hashLedger(
//  ledger: Ledger,
//  options: {
//    computeTreeHashes: Bool?
//  } = {},
//) -> String {
//  let subhashes = {
//    transaction_hash: computeTransactionHash(ledger, options),
//    account_hash: computeStateHash(ledger, options),
//  }
//  return hashLedgerHeader({ ...ledger, ...subhashes })
//}
