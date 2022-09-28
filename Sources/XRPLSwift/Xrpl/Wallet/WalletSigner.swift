//
//  WalletSigner.swift
//
//
//  Created by Denis Angell on 8/6/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/Wallet/signer.ts

import BigInt
import Foundation

public class WalletSigner: Wallet {
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
    //    public func multisign(transactions: [Transaction] | [String]) -> String {
    public static func multisign(transactions: [Transaction]) throws -> String {
        if transactions.isEmpty {
            throw ValidationError("There were 0 transactions to multisign")
        }

        for txOrBlob in transactions {
            let tx: Transaction = getDecodedTransaction(tx: txOrBlob)
            let jsonTx: [String: AnyObject] = try tx.toJson()
            /*
             * This will throw a more clear error for JS users if any of the supplied transactions has incorrect formatting
             */
            // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- validate does not accept Transaction type
            try validate(transaction: jsonTx)
            if jsonTx["Signers"] == nil || (jsonTx["Signers"] as! [String: AnyObject]).isEmpty {
                // swiftlint:disable:next line_length
                throw ValidationError("For multisigning all transactions must include a Signers field containing an array of signatures. You may have forgotten to pass the 'forMultisign' parameter when signing.")
            }

            if jsonTx["SigningPubKey"] as! String != "" {
                throw ValidationError("SigningPubKey must be an empty string for all transactions when multisigning.")
            }
        }

        let decodedTransactions: [Transaction] = transactions.map { tx in
            return getDecodedTransaction(tx: tx)
        }

        try validateTransactionEquivalence(transactions: decodedTransactions)

        return try BinaryCodec.encode(json: getTransactionWithAllSigners(transactions: decodedTransactions).toJson())
    }

    /**
     * Creates a signature that can be used to redeem a specific amount of XRP from a payment channel.
     *
     * @param wallet - The account that will sign for this payment channel.
     * @param channelId - An id for the payment channel to redeem XRP from.
     * @param amount - The amount in drops to redeem.
     * @returns A signature that can be used to redeem a specific amount of XRP from a payment channel.
     * @category Utilities
     */
    public static func authorizeChannel(
        wallet: Wallet,
        channelId: String,
        amount: String
    ) -> String {
        let json: [String: AnyObject] = [
            "channel": channelId,
            "amount": amount
        ] as! [String: AnyObject]
        let signingData = try! BinaryCodec.encodeForSigningClaim(json: json)
        return Keypairs.sign(message: Data(hex: signingData).bytes, privateKey: wallet.privateKey).toHex
    }

    /**
     * Verifies that the given transaction has a valid signature based on public-key encryption.
     *
     * @param tx - A transaction to verify the signature of. (Can be in object or encoded string format).
     * @returns Returns true if tx has a valid signature, and returns false otherwise.
     * @category Utilities
     */
    public static func verifySignature(tx: String) -> Bool {
        let decodedTx: Transaction = self.getDecodedTransaction(tx: tx)
        let json: [String: AnyObject] = try! decodedTx.toJson()
        return Keypairs.verify(
            signature: Data(hex: json["TxnSignature"] as! String).bytes,
            message: Data(hex: try! BinaryCodec.encodeForSigning(json: json)).bytes,
            publicKey: json["SigningPubKey"] as! String
        )
    }
    public static func verifySignature(tx: Transaction) -> Bool {
        let decodedTx: Transaction = WalletSigner.getDecodedTransaction(tx: tx)
        let json: [String: AnyObject] = try! decodedTx.toJson()
        return Keypairs.verify(
            signature: try! BinaryCodec.encodeForSigning(json: json).bytes,
            message: (json["TxnSignature"] as! String).bytes,
            publicKey: json["SigningPubKey"] as! String
        )
    }

    /**
     * The transactions should all be equal except for the 'Signers' field.
     *
     * @param transactions - An array of Transactions which are expected to be equal other than 'Signers'.
     * @throws ValidationError if the transactions are not equal in any field other than 'Signers'.
     */
    static func validateTransactionEquivalence(transactions: [Transaction]) throws {
        //        let exampleTransaction = JSON.stringify({
        //            ...transactions[0],
        //        Signers: null,
        //        })
        var exampleTx = try transactions[0].toJson()
        exampleTx["Signers"] = nil
        guard try transactions.allSatisfy({ tx in
            var cloneTx = try tx.toJson()
            cloneTx["Signers"] = nil
            //            return (exampleTx === cloneTx)
            return true
        }) else {
            throw ValidationError("txJSON is not the same for all signedTransactions")
        }
    }

    static func getTransactionWithAllSigners(transactions: [Transaction]) -> Transaction {
        // Signers must be sorted in the combined transaction - See compareSigners' documentation for more details
        let sortedSigners: [Signer] = transactions.compactMap { tx in
            let cloneTx = try! tx.toJson()
            return cloneTx["Signers"] as? Signer
            //        }.sorted(by: compareSigners)
        }
        //        return { ...transactions[0], Signers: sortedSigners }
        return transactions[0]
    }

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
    // TODO: Refactor this
    static func compareSigners(left: Signer, right: Signer) -> Int {
        if addressToBigNumber(address: left.signer.account) > addressToBigNumber(address: right.signer.account) {
            return 1
        }
        if addressToBigNumber(address: left.signer.account) == addressToBigNumber(address: right.signer.account) {
            return 0
        }
        if addressToBigNumber(address: left.signer.account) < addressToBigNumber(address: right.signer.account) {
            return -1
        }
        return 0
    }

    static func addressToBigNumber(address: String) -> BigUInt {
        let hex: String = try! XrplCodec.decodeClassicAddress(classicAddress: address).toHex
        let numberOfBitsInHex: Int = 16
        return BigUInt(hex, radix: numberOfBitsInHex)!
    }

    static func getDecodedTransaction(tx: String) -> Transaction {
        let decoded: [String: AnyObject] = BinaryCodec.decode(buffer: tx)
        return try! Transaction(decoded)!
    }

    static func getDecodedTransaction(tx: Transaction) -> Transaction {
        let encoded = try! BinaryCodec.encode(json: tx.toJson())
        let decoded: [String: AnyObject] = BinaryCodec.decode(buffer: encoded)
        return try! Transaction(decoded)!
    }
}
