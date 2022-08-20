////
////  Hashes.swift
////  
////
////  Created by Denis Angell on 8/6/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/hashes/index.ts
//
// import Foundation
//
// let HEX: Int = 16
// let BYTE_LENGTH: Int = 4
//
// func addressToHex(address: String) -> String {
//    return try! XrplCodec.decodeClassicAddress(classicAddress: address).toHexString()
// }
//
// func ledgerSpaceHex(name: keyof typeof ledgerSpaces) -> String {
//    return ledgerSpaces[name].charCodeAt(0).toString(HEX).padStart(4, "0")
// }
//
// let MASK: Int = 0xff
// func currencyToHex(currency: String) -> String {
//    if currency.count != 3 {
//        return currency
//    }
//    
//    var bytes = [UInt8].init(repeating: 0, count: 20)
//    bytes[12] = Character(currency[0]).unicodeScalarCodePoint() & MASK
//    bytes[13] = Character(currency[1]).unicodeScalarCodePoint() & MASK
//    bytes[14] = Character(currency[2]).unicodeScalarCodePoint() & MASK
//    return bytes.toHexString()
// }
//
// extension Character {
//    func unicodeScalarCodePoint() -> UInt32 {
//        let characterString = String(self)
//        let scalars = characterString.unicodeScalars
//        return scalars[scalars.startIndex].value
//    }
// }
//
/// **
// * Hash the given binary transaction data with the single-signing prefix.
// *
// * See [Serialization Format](https://xrpl.org/serialization.html).
// *
// * @param txBlobHex - The binary transaction blob as a hexadecimal String.
// * @returns The hash to sign.
// * @category Utilities
// */
// public func hashTx(txBlobHex: String) -> String {
//    let prefix: String = HashPrefix.TRANSACTION_SIGN.rawValue.asBigByteArray.toHexString().uppercased()
//    return sha512Half(hex: prefix + txBlobHex)
// }
//
/// **
// * Compute AccountRoot Ledger Object Index.
// *
// * All objects in a ledger's state tree have a unique Index.
// * The AccountRoot Ledger Object Index is derived by hashing the
// * address with a namespace identifier. This ensures every
// * Index is unique.
// *
// * See [Ledger Object Indexes](https://xrpl.org/ledger-object-ids.html).
// *
// * @param address - The classic account address.
// * @returns The Ledger Object Index for the account.
// * @category Utilities
// */
// public func hashAccountRoot(address: String) -> String {
//    return sha512Half(hex: ledgerSpaceHex("account") + addressToHex(address: address))
// }
//
/// **
// * [SignerList Index Format](https://xrpl.org/signerlist.html#signerlist-id-format).
// *
// * The Index of a SignerList object is the SHA-512Half of the following values, concatenated in order:
// *   * The RippleState space key (0x0053)
// *   * The AccountID of the owner of the SignerList
// *   * The SignerListID (currently always 0).
// *
// * This method computes a SignerList Ledger Object Index.
// *
// * @param address - The classic account address of the SignerList owner (starting with r).
// * @returns The Index of the account's SignerList object.
// * @category Utilities
// */
// public func hashSignerListId(address: String) -> String {
//    return sha512Half(hex: "\(ledgerSpaceHex("signerList") + addressToHex(address))00000000")
// }
//
/// **
// * [Offer Index Format](https://xrpl.org/offer.html#offer-id-format).
// *
// * The Index of a Offer object is the SHA-512Half of the following values, concatenated in order:
// * * The Offer space key (0x006F)
// * * The AccountID of the account placing the offer
// * * The Sequence number of the OfferCreate transaction that created the offer.
// *
// * This method computes an Offer Index.
// *
// * @param address - The classic account address of the SignerList owner (starting with r).
// * @param sequence - Sequence of the Offer.
// * @returns The Index of the account's Offer object.
// * @category Utilities
// */
// public func hashOfferId(address: String, sequence: Int) -> String {
//    let hexPrefix = ledgerSpaces.offer.charCodeAt(0).toString(HEX).padStart(2, '0')
//    let hexSequence = sequence.toString(HEX).padStart(8, "0")
//    let prefix: String = "00\(hexPrefix)"
//    return sha512Half(prefix + addressToHex(address) + hexSequence)
// }
//
/// **
// * Compute the hash of a Trustline.
// *
// * @param address1 - One of the addresses in the Trustline.
// * @param address2 - The other address in the Trustline.
// * @param currency - Currency in the Trustline.
// * @returns The hash of the Trustline.
// * @category Utilities
// */
// public func hashTrustline(
//    address1: String,
//    address2: String,
//    currency: String
// ) -> String {
//    let address1Hex = addressToHex(address: address1)
//    let address2Hex = addressToHex(address: address2)
//    
//    let swap = new BigNumber(address1Hex, 16).isGreaterThan(BigNumber(address2Hex, 16))
//    let lowAddressHex = swap ? address2Hex : address1Hex
//    let highAddressHex = swap ? address1Hex : address2Hex
//    
//    let prefix: String = ledgerSpaceHex("rippleState")
//    return sha512Half(hex: prefix + lowAddressHex + highAddressHex + currencyToHex(currency: currency))
// }
//
/// **
// * Compute the Hash of an Escrow LedgerEntry.
// *
// * @param address - Address of the Escrow.
// * @param sequence - OfferSequence of the Escrow.
// * @returns The hash of the Escrow LedgerEntry.
// * @category Utilities
// */
// public func hashEscrow(address: String, sequence: Int) -> String {
//    return sha512Half(hex: ledgerSpaceHex("escrow") + addressToHex(address: address) + sequence.toString(HEX).padStart(BYTE_LENGTH * 2, "0"))
// }
//
/// **
// * Compute the hash of a Payment Channel.
// *
// * @param address - Account of the Payment Channel.
// * @param dstAddress - Destination Account of the Payment Channel.
// * @param sequence - Sequence number of the Transaction that created the Payment Channel.
// * @returns Hash of the Payment Channel.
// * @category Utilities
// */
// public func hashPaymentChannel(
//    address: String,
//    dstAddress: String,
//    sequence: Int
// ) -> String {
//    return sha512Half(
//        ledgerSpaceHeader("paychan") +
//        addressToHex(address: address) +
//        addressToHex(dstAddress) +
//        sequence.toString(HEX).padStart(BYTE_LENGTH * 2, "0")
//    )
// }
