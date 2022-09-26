//
//  Wallet.swift
//  
//
//  Created by Denis Angell on 8/6/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/Wallet/index.ts

import BigInt
import Foundation

// swiftlint:disable:next identifier_name
let DEFAULT_DERIVATION_PATH = "m/44'/144'/0'/0/0"

// function hexFromBuffer(buffer: Buffer): string {
//  return buffer.toString('hex').toUpperCase()
// }

public struct SeedOptions {
    public var masterAddress: String?
    public var algorithm: AlgorithmType = .ed25519
    public var seed: String?
}

public struct DerivationPath {
    public let account: UInt32 = 0
    public let change: UInt32 = 0
    public let addressIndex: UInt32 = 0
}

public struct MnemonicOptions {
    public let masterAddress: String?
    public let derivationPath: DerivationPath
    public let mnemonicEncoding: String?
    public var algorithm: AlgorithmType = .ed25519
}

public struct SignatureResult {
    public let txBlob: String
    public let hash: String
}

/**
 * A utility for deriving a wallet composed of a keypair (publicKey/privateKey).
 * A wallet can be derived from either a seed, mnemonic, or entropy (array of random numbers).
 * It provides functionality to sign/verify transactions offline.
 *
 * @example
 * ```swift
 * // Derive a wallet from a bip39 Mnemonic
 * const wallet = Wallet.fromMnemonic(
 *   'jewel insect retreat jump claim horse second chef west gossip bone frown exotic embark laundry'
 * )
 * console.log(wallet)
 * // Wallet {
 * // publicKey: '02348F89E9A6A3615BA317F8474A3F51D66221562D3CA32BFA8D21348FF67012B2',
 * // privateKey: '00A8F2E77FC0E05890C1B5088AFE0ECF9D96466A4419B897B1AB383E336E1735A2',
 * // classicAddress: 'rwZiksrExmVkR64pf87Jor4cYbmff47SUm',
 * // seed: undefined
 * // }.
 *
 * // Derive a wallet from a base58 encoded seed.
 * const seedWallet = Wallet.fromSeed('ssZkdwURFMBXenJPbrpE14b6noJSu')
 * console.log(seedWallet)
 * // Wallet {
 * // publicKey: '02FE9932A9C4AA2AC9F0ED0F2B89302DE7C2C95F91D782DA3CF06E64E1C1216449',
 * // privateKey: '00445D0A16DD05EFAF6D5AF45E6B8A6DE4170D93C0627021A0B8E705786CBCCFF7',
 * // classicAddress: 'rG88FVLjvYiQaGftSa1cKuE2qNx7aK5ivo',
 * // seed: 'ssZkdwURFMBXenJPbrpE14b6noJSu'
 * // }.
 *
 * // Sign a JSON Transaction
 *  const signed = seedWallet.signTransaction({
 *      TransactionType: 'Payment',
 *      Account: 'rG88FVLjvYiQaGftSa1cKuE2qNx7aK5ivo'
 *      ...........
 * }).
 *
 * console.log(signed)
 * // '1200007321......B01BE1DFF3'.
 * console.log(decode(signed))
 * // {
 * //   TransactionType: 'Payment',
 * //   SigningPubKey: '02FE9932A9C4AA2AC9F0ED0F2B89302DE7C2C95F91D782DA3CF06E64E1C1216449',
 * //   TxnSignature: '3045022100AAD......5B631ABD21171B61B07D304',
 * //   Account: 'rG88FVLjvYiQaGftSa1cKuE2qNx7aK5ivo'
 * //   ...........
 * // }
 * ```
 *
 * @category Signing
 */
public class Wallet {
    public let publicKey: String
    public let privateKey: String
    public let classicAddress: String
    public let seed: String?

    /**
     * Alias for wallet.classicAddress.
     *
     * @returns The wallet's classic address.
     */
    public func address() -> String {
        return self.classicAddress
    }

    /**
     * Creates a new Wallet.
     *
     * @param publicKey - The public key for the account.
     * @param privateKey - The private key used for signing transactions for the account.
     * @param opts - (Optional) Options to initialize a Wallet.
     * @param opts.masterAddress - Include if a Wallet uses a Regular Key Pair. It must be the master address of the account.
     * @param opts.seed - The seed used to derive the account keys.
     */
    public init(
        publicKey: String,
        privateKey: String,
        masterAddress: String? = nil,
        seed: String? = nil
    ) {
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.classicAddress = !(masterAddress ?? "").isEmpty
        ? try! ensureClassicAddress(account: masterAddress!)
        : try! Keypairs.deriveAddress(publicKey: publicKey)
        self.seed = seed
    }

    /**
     * Generates a new Wallet using a generated seed.
     *
     * @param algorithm - The digital signature algorithm to generate an address for.
     * @returns A new Wallet derived from a generated seed.
     */
    public static func generate(algorithm: AlgorithmType = .ed25519) -> Wallet {
        let seed: String = try! Keypairs.generateSeed(options: KeypairsOptions(algorithm: algorithm))
        return Wallet.fromSeed(seed: seed)
    }

    /**
     * Derives a wallet from a seed.
     *
     * @param seed - A string used to generate a keypair (publicKey/privateKey) to derive a wallet.
     * @param opts - (Optional) Options to derive a Wallet.
     * @param opts.algorithm - The digital signature algorithm to generate an address for.
     * @param opts.masterAddress - Include if a Wallet uses a Regular Key Pair. It must be the master address of the account.
     * @returns A Wallet derived from a seed.
     */
    public static func fromSeed(
        seed: String,
        masterAddress: String? = nil
    ) -> Wallet {
        return Wallet.deriveWallet(seed: seed, masterAddress: masterAddress)
    }

    /**
     * Derives a wallet from an entropy (array of random numbers).
     *
     * @param entropy - An array of random numbers to generate a seed used to derive a wallet.
     * @param opts - (Optional) Options to derive a Wallet.
     * @param opts.algorithm - The digital signature algorithm to generate an address for.
     * @param opts.masterAddress - Include if a Wallet uses a Regular Key Pair. It must be the master address of the account.
     * @returns A Wallet derived from an entropy.
     */
    public static func fromEntropy(
        entropy: Entropy,
        opts: SeedOptions
    ) -> Wallet {
        let options = KeypairsOptions(entropy: entropy, algorithm: opts.algorithm)
        let seed = try! Keypairs.generateSeed(options: options)
        return Wallet.deriveWallet(seed: seed, masterAddress: opts.masterAddress!)
    }

    /**
     * Derives a wallet from a bip39 or RFC1751 mnemonic (Defaults to bip39).
     *
     * @param mnemonic - A string consisting of words (whitespace delimited) used to derive a wallet.
     * @param opts - (Optional) Options to derive a Wallet.
     * @param opts.masterAddress - Include if a Wallet uses a Regular Key Pair. It must be the master address of the account.
     * @param opts.derivationPath - The path to derive a keypair (publicKey/privateKey). Only used for bip39 conversions.
     * @param opts.mnemonicEncoding - If set to 'rfc1751', this interprets the mnemonic as a rippled RFC1751 mnemonic like
     *                          `wallet_propose` generates in rippled. Otherwise the function defaults to bip39 decoding.
     * @param opts.algorithm - Only used if opts.mnemonicEncoding is 'rfc1751'. Allows the mnemonic to generate its
     *                         secp256k1 seed, or its ed25519 seed. By default, it will generate the secp256k1 seed
     *                         to match the rippled `wallet_propose` default algorithm.
     * @returns A Wallet derived from a mnemonic.
     * @throws ValidationError if unable to derive private key from mnemonic input.
     */
    public static func fromMnemonic(
        mnemonic: String,
        opts: MnemonicOptions
    ) throws -> Wallet {
        if opts.mnemonicEncoding == "rfc1751" {
            return try Wallet.fromRFC1751Mnemonic(mnemonic: mnemonic, opts: opts)
        }
        // Otherwise decode using bip39's mnemonic standard
        //        if !validateMnemonic(mnemonic) {
        //            throw ValidationError("Unable to parse the given mnemonic using bip39 encoding")
        //        }

        let seed = Bip39Mnemonic.createSeed(mnemonic: mnemonic)
        let node = PrivateKey(seed: seed, coin: .bitcoin)

        if node.publicKey.isEmpty {
            throw ValidationError("Unable to derive privateKey from mnemonic input")
        }

        // BIP44 key derivation
        // m/44'
        let purpose = node.derived(at: .hardened(44))
        // m/44'/144'
        let coinType = purpose.derived(at: .hardened(144))
        // m/44'/144'/0'
        let account = coinType.derived(at: .hardened(opts.derivationPath.account))
        // m/44'/144'/0'/0
        let change = account.derived(at: .notHardened(opts.derivationPath.change))
        // m/44'/144'/0'/0/0
        let firstPrivateKey = change.derived(at: .notHardened(opts.derivationPath.addressIndex))

        var finalMasterPrivateKey = Data(repeating: 0x00, count: 33)
        finalMasterPrivateKey.replaceSubrange(1...firstPrivateKey.raw.count, with: firstPrivateKey.raw)
        let address = try Keypairs.deriveAddress(publicKey: firstPrivateKey.publicKey.toHex)

        let publicKey = firstPrivateKey.publicKey.toHex
        let privateKey = finalMasterPrivateKey.toHex
        // TODO: Shouldn't the mnemonic wallet append the address from `deriveAddress`
        //        let opts: SeedOptions = SeedOptions(masterAddress: address, seed: nil)
        let opts: SeedOptions = SeedOptions(masterAddress: opts.masterAddress, seed: nil)
        return Wallet(
            publicKey: publicKey,
            privateKey: privateKey,
            masterAddress: opts.masterAddress,
            seed: nil
        )
    }

    /**
     * Derives a wallet from a RFC1751 mnemonic, which is how `wallet_propose` encodes mnemonics.
     *
     * @param mnemonic - A string consisting of words (whitespace delimited) used to derive a wallet.
     * @param opts - (Optional) Options to derive a Wallet.
     * @param opts.masterAddress - Include if a Wallet uses a Regular Key Pair. It must be the master address of the account.
     * @param opts.algorithm - The digital signature algorithm to generate an address for.
     * @returns A Wallet derived from a mnemonic.
     */
    private static func fromRFC1751Mnemonic(
        mnemonic: String,
        opts: MnemonicOptions
    ) throws -> Wallet {
        fatalError("NOT IMPLEMENTED")
        //        let seed = rfc1751MnemonicToKey(mnemonic)
        let seed: [UInt8] = []
        let encodedSeed = try XrplCodec.encodeSeed(entropy: seed, type: opts.algorithm)
        let seedOpts: SeedOptions = SeedOptions(
            masterAddress: opts.masterAddress,
            algorithm: opts.algorithm,
            seed: nil
        )
        return Wallet.fromSeed(seed: encodedSeed, masterAddress: opts.masterAddress!)
    }

    /**
     * Derive a Wallet from a seed.
     *
     * @param seed - The seed used to derive the wallet.
     * @param opts - (Optional) Options to derive a Wallet.
     * @param opts.algorithm - The digital signature algorithm to generate an address for.
     * @param opts.masterAddress - Include if a Wallet uses a Regular Key Pair. It must be the master address of the account.
     * @returns A Wallet derived from the seed.
     */
    private static func deriveWallet(
        seed: String,
        masterAddress: String? = nil
    ) -> Wallet {
        let keypair: KeyPair = try! Keypairs.deriveKeypair(seed: seed)
        return Wallet(
            publicKey: keypair.publicKey,
            privateKey: keypair.privateKey,
            masterAddress: masterAddress,
            seed: seed
        )
    }

    /**
     *    multisign?: boolean | string,
     * Signs a transaction offline.
     *
     * @param this - Wallet instance.
     * @param transaction - A transaction to be signed offline.
     * @param multisign - Specify true/false to use multisign or actual address (classic/x-address) to make multisign tx request.
     * @returns A signed transaction.
     * @throws ValidationError if the transaction is already signed or does not encode/decode to same result.
     * @throws XrplError if the issued currency being signed is XRP ignoring case.
     */
    public func sign(
        transaction: Transaction,
        multisign: Bool = false,
        signingFor: String? = nil
    ) throws -> SignatureResult {
        let tx = try! transaction.toJson()
        return try self.sign(transaction: tx, multisign: multisign, signingFor: signingFor)
    }

    public func sign(
//        transaction: Transaction,
        transaction: [String: AnyObject],
        //    multisign?: boolean | string,
        multisign: Bool = false,
        signingFor: String? = nil
    ) throws -> SignatureResult {
        var multisignAddress: String = ""
        if let signer = signingFor, signer.starts(with: "X") {
            multisignAddress = signer
        } else if multisign {
            multisignAddress = self.classicAddress
        }

//        let tx = try! transaction.toJson()
        var tx = transaction

        if tx["TxnSignature"] != nil || tx["Signers"] != nil {
            throw ValidationError("txJSON must not contain `TxnSignature` or `Signers` properties")
        }

        removeTrailingZeros(tx: &tx)

//        let encoder = JSONEncoder()
//        let txData = try encoder.encode(transaction)
//        var txToSignAndEncode = try JSONSerialization.jsonObject(with: tx, options: .mutableLeaves) as? [String: AnyObject]
        var txToSignAndEncode = tx

        txToSignAndEncode["SigningPubKey"] = !multisignAddress.isEmpty ? "" as AnyObject : self.publicKey as AnyObject

        if !multisignAddress.isEmpty {
            let signer = try Signer(json: [
                "Account": multisignAddress,
                "SigningPubKey": self.publicKey,
                "TxnSignature": try computeSignature(
                    tx: txToSignAndEncode,
                    privateKey: self.privateKey,
                    signAs: multisignAddress
                )
            ] as! [String: AnyObject])
            txToSignAndEncode["Signers"] = [signer] as AnyObject
        } else {
            let signature: String = try computeSignature(
                tx: txToSignAndEncode,
                privateKey: self.privateKey
            )
            txToSignAndEncode["TxnSignature"] = signature as AnyObject
        }
        let serialized = try BinaryCodec.encode(json: txToSignAndEncode)
        try self.checkTxSerialization(serialized: serialized, tx: transaction)
        return SignatureResult(txBlob: serialized, hash: try hashSignedTx(tx: serialized))
    }

    /**
     * Verifies a signed transaction offline.
     *
     * @param signedTransaction - A signed transaction (hex string of signTransaction result) to be verified offline.
     * @returns Returns true if a signedTransaction is valid.
     */
    public func verifyTransaction(signedTransaction: String) -> Bool {
        let tx = BinaryCodec.decode(buffer: signedTransaction)
        let messageHex: String = try! BinaryCodec.encodeForSigning(json: tx)
        let signature = tx["TxnSignature"] as? String
        return Keypairs.verify(signature: messageHex.bytes, message: signature!.bytes, publicKey: self.publicKey)
    }

    /**
     * Gets an X-address in Testnet/Mainnet format.
     *
     * @param tag - A tag to be included within the X-address.
     * @param isTestnet - A boolean to indicate if X-address should be in Testnet (true) or Mainnet (false) format.
     * @returns An X-address.
     */
    public func getXAddress(tag: Int? = nil, isTest: Bool = false) -> String {
        return try! AddressCodec.classicAddressToXAddress(classicAddress: self.classicAddress, tag: tag, isTest: isTest)
    }

    /**
     *  Decode a serialized transaction, remove the fields that are added during the signing process,
     *  and verify that it matches the transaction prior to signing. This gives the user a sanity check
     *  to ensure that what they try to encode matches the message that will be recieved by rippled.
     *
     * @param serialized - A signed and serialized transaction.
     * @param tx - The transaction prior to signing.
     * @throws A ValidationError if the transaction does not have a TxnSignature/Signers property, or if
     * the serialized Transaction desn't match the original transaction.
     * @throws XrplError if the transaction includes an issued currency which is equivalent to XRP ignoring case.
     */
    private func checkTxSerialization(serialized: String, tx: [String: AnyObject]) throws {
        // Decode the serialized transaction:
        var decoded: [String: AnyObject] = BinaryCodec.decode(buffer: serialized) as [String: AnyObject]
//        var txCopy = try tx.toJson()
        var txCopy = tx

        /*
         * And ensure it is equal to the original tx, except:
         * - It must have a TxnSignature or Signers (multisign).
         */
        if decoded["TxnSignature"] == nil && decoded["Signers"] == nil {
            throw ValidationError("Serialized transaction must have a TxnSignature or Signers property")
        }
        // - We know that the original tx did not have TxnSignature, so we should delete it:
        decoded["TxnSignature"] = nil
        // - We know that the original tx did not have Signers, so if it exists, we should delete it:
        decoded["Signers"] = nil

        /*
         * - If SigningPubKey was not in the original tx, then we should delete it.
         *   But if it was in the original tx, then we should ensure that it has not been changed.
         */
        if txCopy["SigningPubKey"] == nil {
            decoded["SigningPubKey"] = nil
        }

        /*
         * - Memos have exclusively hex data which should ignore case.
         *   Since decode goes to upper case, we set all tx memos to be uppercase for the comparison.
         */
        if let memos = txCopy["Memos"] as? [[String: AnyObject]] {
            txCopy["Memos"] = memos.map { memoclone -> [String: AnyObject] in
                var innerMemo = memoclone["Memo"] as! [String: AnyObject]
                if let memoData = innerMemo["MemoData"] as? String {
                    innerMemo["MemoData"] = memoData.uppercased() as AnyObject
                }
                if let memoType = innerMemo["MemoType"] as? String {
                    innerMemo["MemoType"] = memoType.uppercased() as AnyObject
                }
                if let memoFormat = innerMemo["MemoFormat"] as? String {
                    innerMemo["MemoFormat"] = memoFormat.uppercased() as AnyObject
                }
                return innerMemo
            } as AnyObject
        }
        if txCopy["TransactionType"] as! String == "NFTokenMint" && txCopy["URI"] != nil {
            if !isHex(str: txCopy["URI"] as! String) {
                throw ValidationError("URI must be a hex value")
            }
            txCopy["URI"] = (txCopy["URI"] as! String).uppercased() as AnyObject
        }

        try txCopy.forEach { (key: String, _: AnyObject) in
            let standardCurrencyCodeLen = 3
            if txCopy[key] != nil && isIssuedCurrency(input: txCopy[key]!) {
                let decodedAmount: Any = try xAmount.from(value: decoded[key] as! [String: String]).toJson()
                var decodedIC = try IssuedCurrencyAmount(decodedAmount as! [String: AnyObject])
                let decodedCurrency = decodedIC.currency
                let txCurrency = try IssuedCurrencyAmount(txCopy[key] as! [String: AnyObject]).currency

                if txCurrency.count == standardCurrencyCodeLen && txCurrency.uppercased() == "XRP" {
                    throw ValidationError("Trying to sign an issued currency with a similar standard code to XRP (received \(txCurrency)'). XRP is not an issued currency.")
                }

                // Standardize the format of currency codes to the 40 byte hex string for comparison
                let amount = try IssuedCurrencyAmount(txCopy[key] as! [String: AnyObject])
                if amount.currency.count != decodedCurrency.count {
                    if decodedCurrency.count == standardCurrencyCodeLen {
                        decodedIC.currency = isoToHex(iso: decodedCurrency)
                    } else {
                        //                        txCopy[key]!["currency"] = isoToHex(iso: amount.currency)
                    }
                }
            }
        }

        if !(decoded == txCopy) {
            let data = [
                "decoded": decoded,
                "tx": txCopy
            ] as [String: AnyObject]
//            let error = ValidationError(
//                "Serialized transaction does not match original txJSON. See error.data",
//                data
//            )
//            throw error
        }
    }
}

/**
 * Signs a transaction with the proper signing encoding.
 *
 * @param tx - A transaction to sign.
 * @param privateKey - A key to sign the transaction with.
 * @param signAs - Multisign only. An account address to include in the Signer field.
 * Can be either a classic address or an XAddress.
 * @returns A signed transaction in the proper format.
 */
func computeSignature(
    tx: [String: AnyObject],
    privateKey: String,
    signAs: String? = nil
) throws -> String {
    //    if signAs != nil && !signAs!.isEmpty {
    //        let classicAddress = AddressCodec.isValidXAddress(xAddress: signAs!)
    //        ? AddressCodec.xAddressToClassicAddress(xAddress: signAs!).classicAddress
    //        : signAs
    //        return sign(encodeForMultisigning(tx, classicAddress), privateKey)
    //    }
    let encoded = try BinaryCodec.encodeForSigning(json: tx)
    return Keypairs.sign(
        message: Data(hex: encoded).bytes,
        privateKey: privateKey
    ).toHex
}

/**
 * Remove trailing insignificant zeros for non-XRP Payment amount.
 * This resolves the serialization mismatch bug when encoding/decoding a non-XRP Payment transaction
 * with an amount that contains trailing insignificant zeros; for example, '123.4000' would serialize
 * to '123.4' and cause a mismatch.
 *
 * @param tx - The transaction prior to signing.
 */
func removeTrailingZeros(tx: inout [String: AnyObject]) {
    if let tt = tx["TransactionType"] as? String, tt == "Payment", let amountValue = tx["amount"] as? String, amountValue.contains(where: { $0 == "."}) {
//        tx["Amount"] = BigInt(tx["Amount"]) as AnyObject
        tx["Amount"] = tx["Amount"]
    }
 }

/**
 * Convert an ISO code to a hex string representation
 *
 * @param iso - A 3 letter standard currency code
 */
func isoToHex(iso: String) -> String {
    return try! isoToBytes(iso: iso).toHex
}

public func == (lhs: [String: AnyObject], rhs: [String: AnyObject]) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

extension Dictionary where Key == String, Value: Any {
    func object<T: Decodable>() -> T? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: []) {
            return try? JSONDecoder().decode(T.self, from: data)
        } else {
            return nil
        }
    }
}
