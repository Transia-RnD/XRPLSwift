//
//  File.swift
//  
//
//  Created by Denis Angell on 8/6/22.
//

import Foundation


//let DEFAULT_ALGORITHM: ED25519 = ED25519.self
let DEFAULT_DERIVATION_PATH = "m/44'/144'/0'/0/0"

//function hexFromBuffer(buffer: Buffer): string {
//  return buffer.toString('hex').toUpperCase()
//}


public struct SeedOptions {
    public let masterAddress: String?
    public let algorithm: AlgorithType? = .ed25519
    public let seed: String?
}

public struct MnemonicOptions {
    public let masterAddress: String?
    public let derivationPath: String?
    public let mnemonicEncoding: String?
    public let algorithm: AlgorithType? = .ed25519
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
 * ```typescript
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
public class rWallet {
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
        opts: SeedOptions
    ) {
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.classicAddress = !opts.masterAddress!.isEmpty
        ? try! ensureClassicAddress(account: opts.masterAddress!)
        : try! XrplCodec.decodeAccountPublicKey(accountPublicKey: publicKey).toHexString()
        self.seed = opts.seed
    }
    
    /**
     * Generates a new Wallet using a generated seed.
     *
     * @param algorithm - The digital signature algorithm to generate an address for.
     * @returns A new Wallet derived from a generated seed.
     */
    public static func generate(algorithm: AlgorithType = .ed25519) -> rWallet {
        let options: SeedOptions = SeedOptions(masterAddress: nil, seed: nil)
        let seed: String = try! Keypairs.generateSeed(options: KeypairsOptions(algorithm: algorithm))
        return rWallet.fromSeed(seed: seed, opts: options)
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
        opts: SeedOptions
    ) -> rWallet {
        return rWallet.deriveWallet(seed: seed, opts: opts)
    }
    
    /**
     * Derives a wallet from a secret (AKA a seed).
     *
     * @param secret - A string used to generate a keypair (publicKey/privateKey) to derive a wallet.
     * @param opts - (Optional) Options to derive a Wallet.
     * @param opts.algorithm - The digital signature algorithm to generate an address for.
     * @param opts.masterAddress - Include if a Wallet uses a Regular Key Pair. It must be the master address of the account.
     * @returns A Wallet derived from a secret (AKA a seed).
     */
    // eslint-disable-next-line @typescript-eslint/member-ordering -- Member is used as a function here
    //  public static func fromSecret = Wallet.fromSeed
    
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
    ) -> rWallet {
        let options = KeypairsOptions(entropy: entropy, algorithm: opts.algorithm)
        let seed = try! Keypairs.generateSeed(options: options)
        return rWallet.deriveWallet(seed: seed, opts: opts)
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
    ) -> rWallet {
        //        if opts.mnemonicEncoding == "rfc1751" {
        //            return rWallet.fromRFC1751Mnemonic(mnemonic, SeedOptions)
        //        }
        // Otherwise decode using bip39's mnemonic standard
        //        if !validateMnemonic(mnemonic) {
        //            throw XrplError.validation("Unable to parse the given mnemonic using bip39 encoding")
        //        }
        
        let seed = Bip39Mnemonic.createSeed(mnemonic: mnemonic)
        
        //        // BIP44 key derivation
        //        // m/44'
        //        let purpose = privateKey.derived(at: .hardened(44))
        //        // m/44'/144'
        //        let coinType = purpose.derived(at: .hardened(144))
        //        // m/44'/144'/0'
        //        let account = coinType.derived(at: .hardened(account))
        //        // m/44'/144'/0'/0
        //        let change = account.derived(at: .notHardened(change))
        //        // m/44'/144'/0'/0/0
        //        let firstPrivateKey = change.derived(at: .notHardened(addressIndex))
        //
        //        var finalMasterPrivateKey = Data(repeating: 0x00, count: 33)
        //        finalMasterPrivateKey.replaceSubrange(1...firstPrivateKey.raw.count, with: firstPrivateKey.raw)
        //        let address = rWallet.deriveAddress(publicKey: firstPrivateKey.publicKey.hexadecimal)
        
        //        let keypairOptions: KeypairsOptions = KeypairsOptions(algorithm: opts.algorithm)
        //        let masterNode = rWallet.fromSeed(seed: seed, opts: keypairOptions)
        //        let node = masterNode.derivePath(
        //            opts.derivationPath ?? DEFAULT_DERIVATION_PATH,
        //        )
        //        if node.privateKey == nil {
        //            throw XrplError.validation("Unable to derive privateKey from mnemonic input")
        //        }
        //
        let publicKey = "hexFromBuffer(node.publicKey)"
        let privateKey = "hexFromBuffer(node.privateKey)"
        let opts: SeedOptions = SeedOptions(masterAddress: opts.masterAddress!, seed: seed.toHexString())
        return rWallet(publicKey: publicKey, privateKey: "00\(privateKey)", opts: opts)
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
    //    private static func fromRFC1751Mnemonic(
    //        mnemonic: string,
    //        opts: { masterAddress?: string; algorithm?: ECDSA },
    //    ) -> rWallet {
    //        const seed = rfc1751MnemonicToKey(mnemonic)
    //        let encodeAlgorithm: 'ed25519' | 'secp256k1'
    //        if (opts.algorithm === ECDSA.ed25519) {
    //            encodeAlgorithm = 'ed25519'
    //        } else {
    //            // Defaults to secp256k1 since that's the default for `wallet_propose`
    //            encodeAlgorithm = 'secp256k1'
    //        }
    //        const encodedSeed = encodeSeed(seed, encodeAlgorithm)
    //        return Wallet.fromSeed(encodedSeed, {
    //        masterAddress: opts.masterAddress,
    //        algorithm: opts.algorithm,
    //        })
    //    }
    
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
        opts: SeedOptions
    ) -> rWallet {
        let keypairOptions: KeypairsOptions = KeypairsOptions(algorithm: opts.algorithm)
        let keypair: KeyPair = try! Keypairs.deriveKeypair(seed: seed)
        return rWallet(publicKey: keypair.publicKey, privateKey: keypair.privateKey, opts: opts)
    }
    
    /**
     * Signs a transaction offline.
     *
     * @param this - Wallet instance.
     * @param transaction - A transaction to be signed offline.
     * @param multisign - Specify true/false to use multisign or actual address (classic/x-address) to make multisign tx request.
     * @returns A signed transaction.
     * @throws ValidationError if the transaction is already signed or does not encode/decode to same result.
     * @throws XrplError if the issued currency being signed is XRP ignoring case.
     */
    //     eslint-disable-next-line max-lines-per-function -- introduced more checks to support both string and boolean inputs.
    public func sign(
        transaction: rTransaction,
        //    multisign?: boolean | string,
        multisign: Bool
    ) throws -> SignatureResult {
        //        let multisignAddress: Bool | string = false
        //        let multisignAddress: Bool = false
        //        if multisign is String && multisign.startsWith("X") {
        //            multisignAddress = multisign
        //        } else if (multisign) {
        //            multisignAddress = this.classicAddress
        //        }
        
        let tx = try! transaction.toAny()
        
        //        if tx.TxnSignature || tx.Signers {
        //            throw XrplError.validation("txJSON must not contain `TxnSignature` or `Signers` properties")
        //        }
        
//        removeTrailingZeros(tx: transaction)
        
        let encoder = JSONEncoder()
//        print(transaction)
//        let txs = try encoder.encode(transaction)
//        var tx = try transaction.toAny() as! BaseTransaction
//        let signedTxEncoded: String = try BinaryCodec.encode(data: try encoder.encode(signedTransaction))
        
        let txData = try encoder.encode(transaction)
        var txToSignAndEncode = try JSONSerialization.jsonObject(with: txData, options: .mutableLeaves) as? [String: AnyObject]
        let multisignAddress: Bool = false
        
//        txToSignAndEncode?["SigningPubKey"] = multisignAddress ? "" : self.publicKey as AnyObject
        txToSignAndEncode?["SigningPubKey"] = self.publicKey as AnyObject
        
        let signature: String = computeSignature(
            tx: txToSignAndEncode!,
            privateKey: self.privateKey
        )
        
        txToSignAndEncode?["TxnSignature"] = signature as AnyObject
        
        //        txToSignAndEncode.TxnSignature = computeSignature(
        //            txToSignAndEncode,
        //            this.privateKey,
        //        )
        
        //        if (multisignAddress) {
        //            let Signer = Signer(
        //            let signer = {
        //                Account: multisignAddress,
        //                SigningPubKey: this.publicKey,
        //                TxnSignature: computeSignature(
        //                    txToSignAndEncode,
        //                    this.privateKey,
        //                    multisignAddress,
        //                ),
        //            }
        //            txToSignAndEncode.Signers = [{ Signer: signer }]
        //        } else {
        //            txToSignAndEncode.TxnSignature = computeSignature(
        //                txToSignAndEncode,
        //                this.privateKey,
        //            )
        //        }
        
        let serialized = try BinaryCodec.encode(json: txToSignAndEncode!)
//        self.checkTxSerialization(serialized, tx)
        return SignatureResult(txBlob: serialized, hash: "hashSignedTx(serialized)")
    }
    
    /**
     * Verifies a signed transaction offline.
     *
     * @param signedTransaction - A signed transaction (hex string of signTransaction result) to be verified offline.
     * @returns Returns true if a signedTransaction is valid.
     */
    //    public func verifyTransaction(signedTransaction: String) -> Bool {
    //        const tx = decode(signedTransaction)
    //        const messageHex: string = encodeForSigning(tx)
    //        const signature = tx.TxnSignature
    //        return verify(messageHex, signature, this.publicKey)
    //    }
    
    /**
     * Gets an X-address in Testnet/Mainnet format.
     *
     * @param tag - A tag to be included within the X-address.
     * @param isTestnet - A boolean to indicate if X-address should be in Testnet (true) or Mainnet (false) format.
     * @returns An X-address.
     */
    //    public func getXAddress(tag: number | false = false, isTestnet = false): string {
    //        return classicAddressToXAddress(this.classicAddress, tag, isTestnet)
    //    }
    
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
    // eslint-disable-next-line class-methods-use-this, max-lines-per-function -- Helper for organization purposes
    //    private checkTxSerialization(serialized: string, tx: Transaction) -> Void {
    //        // Decode the serialized transaction:
    //        const decoded = decode(serialized)
    //        const txCopy = { ...tx }
    //
    //        /*
    //         * And ensure it is equal to the original tx, except:
    //         * - It must have a TxnSignature or Signers (multisign).
    //         */
    //        if (!decoded.TxnSignature && !decoded.Signers) {
    //            throw new ValidationError(
    //                'Serialized transaction must have a TxnSignature or Signers property',
    //            )
    //        }
    //        // - We know that the original tx did not have TxnSignature, so we should delete it:
    //        delete decoded.TxnSignature
    //        // - We know that the original tx did not have Signers, so if it exists, we should delete it:
    //        delete decoded.Signers
    //
    //        /*
    //         * - If SigningPubKey was not in the original tx, then we should delete it.
    //         *   But if it was in the original tx, then we should ensure that it has not been changed.
    //         */
    //        if (!tx.SigningPubKey) {
    //            delete decoded.SigningPubKey
    //        }
    //
    //        /*
    //         * - Memos have exclusively hex data which should ignore case.
    //         *   Since decode goes to upper case, we set all tx memos to be uppercase for the comparison.
    //         */
    //        txCopy.Memos?.map((memo) => {
    //            const memoCopy = { ...memo }
    //            if (memo.Memo.MemoData) {
    //                memoCopy.Memo.MemoData = memo.Memo.MemoData.toUpperCase()
    //            }
    //
    //            if (memo.Memo.MemoType) {
    //                memoCopy.Memo.MemoType = memo.Memo.MemoType.toUpperCase()
    //            }
    //
    //            if (memo.Memo.MemoFormat) {
    //                memoCopy.Memo.MemoFormat = memo.Memo.MemoFormat.toUpperCase()
    //            }
    //
    //            return memo
    //        })
    //
    //        if (txCopy.TransactionType === 'NFTokenMint' && txCopy.URI) {
    //            if (!isHex(txCopy.URI)) {
    //                throw new ValidationError('URI must be a hex value')
    //            }
    //            txCopy.URI = txCopy.URI.toUpperCase()
    //        }
    
    /* eslint-disable @typescript-eslint/consistent-type-assertions -- We check at runtime that this is safe */
    //        Object.keys(txCopy).forEach((key) => {
    //          const standard_currency_code_len = 3
    //          if (txCopy[key] && isIssuedCurrency(txCopy[key])) {
    //            const decodedAmount = decoded[key] as unknown as IssuedCurrencyAmount
    //            const decodedCurrency = decodedAmount.currency
    //            const txCurrency = (txCopy[key] as IssuedCurrencyAmount).currency
    //
    //            if (
    //              txCurrency.length === standard_currency_code_len &&
    //              txCurrency.toUpperCase() === 'XRP'
    //            ) {
    //              throw new XrplError(
    //                `Trying to sign an issued currency with a similar standard code to XRP (received '${txCurrency}'). XRP is not an issued currency.`,
    //              )
    //            }
    //
    //            // Standardize the format of currency codes to the 40 byte hex string for comparison
    //            const amount = txCopy[key] as IssuedCurrencyAmount
    //            if (amount.currency.length !== decodedCurrency.length) {
    //              /* eslint-disable-next-line max-depth -- Easier to read with two if-statements */
    //              if (decodedCurrency.length === standard_currency_code_len) {
    //                decodedAmount.currency = isoToHex(decodedCurrency)
    //              } else {
    //                /* eslint-disable-next-line @typescript-eslint/no-unsafe-member-access -- We need to update txCopy directly */
    //                txCopy[key].currency = isoToHex(txCopy[key].currency)
    //              }
    //            }
    //          }
    //        })
    /* eslint-enable @typescript-eslint/consistent-type-assertions -- Done with dynamic checking */
    
    //        if (!_.isEqual(decoded, txCopy)) {
    //          const data = {
    //            decoded,
    //            tx,
    //          }
    //          const error = new ValidationError(
    //            'Serialized transaction does not match original txJSON. See error.data',
    //            data,
    //          )
    //          throw error
    //        }
    //    }
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
) -> String {
//    if signAs != nil && !signAs!.isEmpty {
//        let classicAddress = AddressCodec.isValidXAddress(xAddress: signAs!)
//        ? AddressCodec.xAddressToClassicAddress(xAddress: signAs!).classicAddress
//        : signAs
//        return sign(encodeForMultisigning(tx, classicAddress), privateKey)
//    }
    return Keypairs.sign(
        message: try! BinaryCodec.encodeForSigning(json: tx).asHexArray(),
        privateKey: privateKey
    ).toHexString()
}

/**
 * Remove trailing insignificant zeros for non-XRP Payment amount.
 * This resolves the serialization mismatch bug when encoding/decoding a non-XRP Payment transaction
 * with an amount that contains trailing insignificant zeros; for example, '123.4000' would serialize
 * to '123.4' and cause a mismatch.
 *
 * @param tx - The transaction prior to signing.
 */
//func removeTrailingZeros(tx: rTransaction) -> Void {
//    if (
//        tx.TransactionType == "Payment" &&
//        tx.Amount is "string" &&
//        tx.Amount.value.includes(".") &&
//        tx.Amount.value.endsWith("0")
//    ) {
//        // eslint-disable-next-line no-param-reassign -- Required to update Transaction.Amount.value
//        tx.Amount = { ...tx.Amount }
//        // eslint-disable-next-line no-param-reassign -- Required to update Transaction.Amount.value
//        tx.Amount.value = new BigNumber(tx.Amount.value).toString()
//    }
//}

/**
 * Convert an ISO code to a hex string representation
 *
 * @param iso - A 3 letter standard currency code
 */
/* eslint-disable @typescript-eslint/no-magic-numbers -- Magic numbers are from rippleds of currency code encoding */
//func isoToHex(iso: String) -> String {
//    let bytes = Buffer.alloc(20)
//    if iso != "XRP" {
//        let isoBytes = iso.split("").map((chr) => chr.charCodeAt(0))
//        bytes.set(isoBytes, 12)
//    }
//    return bytes.asHexString()
//}
