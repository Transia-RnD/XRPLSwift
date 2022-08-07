//
//  rSignor.swift
//  
//
//  Created by Denis Angell on 8/6/22.
//

import Foundation

public class rSignor: rWallet {
    
    /**
     * Takes several transactions with Signer fields (in object or blob form) and creates a
     * single transaction with all Signers that then gets signed and returned.
     *
     * @param transactions - An array of signed Transactions (in object or blob form) to combine into a single signed Transaction.
     * @returns A single signed Transaction which has all Signers from transactions within it.
     * @throws ValidationError if:
     * - There were no transactions given to sign
     * - The SigningPubKey field is not the empty string in any given transaction
     * - Any transaction is missing a Signers field.
     * @category Signing
     */
//    public func multisign(transactions: [rTransaction] | String) -> String {
//      if transactions.length == 0 {
//          throw XrplError.validation("There were 0 transactions to multisign")
//      }
//
//      transactions.forEach((txOrBlob) => {
//        let tx: rTransaction = getDecodedTransaction(txOrBlob)
//
//        /*
//         * This will throw a more clear error for JS users if any of the supplied transactions has incorrect formatting
//         */
//        // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- validate does not accept Transaction type
//        validate(tx as unknown as Record<string, unknown>)
//        if tx.Signers == nil || tx.Signers.length == 0 {
//          throw XrplError.validation(
//            "For multisigning all transactions must include a Signers field containing an array of signatures. You may have forgotten to pass the 'forMultisign' parameter when signing.",
//          )
//        }
//
//        if tx.SigningPubKey != '' {
//          throw XrplError.validation(
//            "SigningPubKey must be an empty string for all transactions when multisigning.",
//          )
//        }
//      })
//
//        let decodedTransactions: [rTransaction] = transactions.map(
//        (txOrBlob: String | rTransaction) => {
//          return getDecodedTransaction(txOrBlob)
//        },
//      )
//
//      validateTransactionEquivalence(decodedTransactions)
//
//      return encode(getTransactionWithAllSigners(decodedTransactions))
//    }

    /**
     * Creates a signature that can be used to redeem a specific amount of XRP from a payment channel.
     *
     * @param wallet - The account that will sign for this payment channel.
     * @param channelId - An id for the payment channel to redeem XRP from.
     * @param amount - The amount in drops to redeem.
     * @returns A signature that can be used to redeem a specific amount of XRP from a payment channel.
     * @category Utilities
     */
//    public func authorizeChannel(
//      wallet: rWallet,
//      channelId: String,
//      amount: String,
//    ) -> String {
//      let signingData = encodeForSigningClaim({
//        channel: channelId,
//        amount,
//      })
//
//      return signWithKeypair(signingData, wallet.privateKey)
//    }

    /**
     * Verifies that the given transaction has a valid signature based on public-key encryption.
     *
     * @param tx - A transaction to verify the signature of. (Can be in object or encoded string format).
     * @returns Returns true if tx has a valid signature, and returns false otherwise.
     * @category Utilities
     */
//    public func verifySignature(tx: rTransaction | String) -> Bool {
//    public func verifySignature(tx: rTransaction) -> Bool {
//      let decodedTx: rTransaction = getDecodedTransaction(tx)
//      return verify(
//        encodeForSigning(decodedTx),
//        decodedTx.TxnSignature,
//        decodedTx.SigningPubKey,
//      )
//    }

    /**
     * The transactions should all be equal except for the 'Signers' field.
     *
     * @param transactions - An array of Transactions which are expected to be equal other than 'Signers'.
     * @throws ValidationError if the transactions are not equal in any field other than 'Signers'.
     */
//    func validateTransactionEquivalence(transactions: [rTransaction]) throws -> {
//      const exampleTransaction = JSON.stringify({
//        ...transactions[0],
//        Signers: null,
//      })
//      if (
//        transactions
//          .slice(1)
//          .some(
//            (tx) => JSON.stringify({ ...tx, Signers: null }) !== exampleTransaction,
//          )
//      ) {
//        throw new ValidationError(
//          'txJSON is not the same for all signedTransactions',
//        )
//      }
//    }

//    func getTransactionWithAllSigners(
//      transactions: [rTransaction],
//    ) -> rTransaction {
//      // Signers must be sorted in the combined transaction - See compareSigners' documentation for more details
//      const sortedSigners: Signer[] = flatMap(
//        transactions,
//        (tx) => tx.Signers ?? [],
//      ).sort(compareSigners)
//
//      return { ...transactions[0], Signers: sortedSigners }
//    }

    /**
     * If presented in binary form, the Signers array must be sorted based on
     * the numeric value of the signer addresses, with the lowest value first.
     * (If submitted as JSON, the submit_multisigned method handles this automatically.)
     * https://xrpl.org/multi-signing.html.
     *
     * @param left - A Signer to compare with.
     * @param right - A second Signer to compare with.
     * @returns 1 if left \> right, 0 if left = right, -1 if left \< right, and null if left or right are NaN.
     */
//    func compareSigners(left: Signer, right: Signer) -> Int {
//      return addressToBigNumber(left.Signer.Account).comparedTo(
//        addressToBigNumber(right.Signer.Account),
//      )
//    }

//    func addressToBigNumber(address: string): BigNumber {
//        let hex: String = Buffer.from(decodeAccountID(address)).toString('hex')
//        let numberOfBitsInHex: Int = 16
//      return BigNumber(hex, numberOfBitsInHex)
//    }

//    func getDecodedTransaction(txOrBlob: Transaction | string): Transaction {
//    func getDecodedTransaction(txOrBlob: rTransaction | String) -> rTransaction {
//      if txOrBlob is "object" {
//        // We need this to handle X-addresses in multisigning
//        // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- We are casting here to get strong typing
//          return decode(BinaryCodec.encode(txOrBlob)) as unknown as rTransaction
//      }
//
//      // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- We are casting here to get strong typing
//        return BinaryCodec.decode(txOrBlob) as unknown as rTransaction
//    }
}
