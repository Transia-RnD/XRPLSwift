//
//  Hashes.swift
//
//
//  Created by Denis Angell on 8/6/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/hashes/index.ts

import Foundation

// swiftlint:disable:next identifier_name
let HASH_HEX: Int = 16
// swiftlint:disable:next identifier_name
let BYTE_LENGTH: Int = 4

func addressToHex(_ address: String) throws -> String {
    return try XrplCodec.decodeClassicAddress(address).toHex
}

func ledgerSpaceHex(_ name: String) throws -> String {
    guard let lsvalue = Character(LedgerSpaces(name).rawValue).asciiValue else {
        throw XrplError("Cannot create ledger space hex from: \(name)")
    }
    return [UInt8].init(repeating: 0x0, count: 1).toHex + String(lsvalue, radix: HASH_HEX)
}

func currencyToHex(_ currency: String) throws -> String {
    let MASK: UInt8 = 0xff
    if currency.count != 3 { return currency }
    var bytes: [UInt8] = [UInt8](repeating: 0, count: 20)
    guard
        let first = currency.utf8.first,
        let second = currency.utf8.dropFirst().first,
        let third = currency.utf8.dropFirst(2).first
    else {
        throw XrplError("Cannot create currency hex from: \(currency)")
    }
    bytes[12] = UInt8(first & MASK)
    bytes[13] = UInt8(second & MASK)
    bytes[14] = UInt8(third & MASK)
    return bytes.toHex
}

extension Character {
    var unicodeScalarCodePoint: UInt32 {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        return scalars[scalars.startIndex].value
    }
}

/**
 * Hash the given binary transaction data with the single-signing prefix.
 *
 * See [Serialization Format](https://xrpl.org/serialization.html).
 *
 * @param txBlobHex - The binary transaction blob as a hexadecimal String.
 * @returns The hash to sign.
 * @category Utilities
 */
public func hashTx(_ txBlobHex: String) -> String {
    let prefix: String = HashPrefix.TRANSACTION_SIGN.rawValue.asBigByteArray.toHexString().uppercased()
    return sha512Half(prefix + txBlobHex)
}

/**
 * Compute AccountRoot Ledger Object Index.
 *
 * All objects in a ledger's state tree have a unique Index.
 * The AccountRoot Ledger Object Index is derived by hashing the
 * address with a namespace identifier. This ensures every
 * Index is unique.
 *
 * See [Ledger Object Indexes](https://xrpl.org/ledger-object-ids.html).
 *
 * @param address - The classic account address.
 * @returns The Ledger Object Index for the account.
 * @category Utilities
 */
public func hashAccountRoot(_ address: String) throws -> String {
    return sha512Half(try ledgerSpaceHex("account") + addressToHex(address))
}

/**
 * [SignerList Index Format](https://xrpl.org/signerlist.html#signerlist-id-format).
 *
 * The Index of a SignerList object is the SHA-512Half of the following values, concatenated in order:
 *   * The RippleState space key (0x0053)
 *   * The AccountID of the owner of the SignerList
 *   * The SignerListID (currently always 0).
 *
 * This method computes a SignerList Ledger Object Index.
 *
 * @param address - The classic account address of the SignerList owner (starting with r).
 * @returns The Index of the account's SignerList object.
 * @category Utilities
 */
public func hashSignerListId(_ address: String) throws -> String {
    return sha512Half("\(try ledgerSpaceHex("signerList") + addressToHex(address))00000000")
}

/**
 * [Offer Index Format](https://xrpl.org/offer.html#offer-id-format).
 *
 * The Index of a Offer object is the SHA-512Half of the following values, concatenated in order:
 * * The Offer space key (0x006F)
 * * The AccountID of the account placing the offer
 * * The Sequence number of the OfferCreate transaction that created the offer.
 *
 * This method computes an Offer Index.
 *
 * @param address - The classic account address of the SignerList owner (starting with r).
 * @param sequence - Sequence of the Offer.
 * @returns The Index of the account's Offer object.
 * @category Utilities
 */

public func hashOfferId(_ address: String, _ sequence: Int) throws -> String {
    let prefix: String = try ledgerSpaceHex("offer")
    let addressHex: String = try addressToHex(address)
    let hexSequence = String(sequence, radix: 16).padding(leftTo: 8, withPad: "0")
    return sha512Half(prefix + addressHex + hexSequence)
}

/**
 * Compute the hash of a Trustline.
 *
 * @param address1 - One of the addresses in the Trustline.
 * @param address2 - The other address in the Trustline.
 * @param currency - Currency in the Trustline.
 * @returns The hash of the Trustline.
 * @category Utilities
 */
public func hashTrustline(
    _ address1: String,
    _ address2: String,
    _ currency: String
) throws -> String {
    let address1Hex = try addressToHex(address1)
    let address2Hex = try addressToHex(address2)
    let swap = address1Hex > address2Hex
    let lowAddressHex = swap ? address2Hex : address1Hex
    let highAddressHex = swap ? address1Hex : address2Hex
    let prefix: String = try ledgerSpaceHex("rippleState")
    let currencyHex: String = try currencyToHex(currency)
    return sha512Half(prefix + lowAddressHex + highAddressHex + currencyHex)
}

/// **
// * Compute the Hash of an Escrow LedgerEntry.
// *
// * @param address - Address of the Escrow.
// * @param sequence - OfferSequence of the Escrow.
// * @returns The hash of the Escrow LedgerEntry.
// * @category Utilities
// */
public func hashEscrow(_ address: String, _ sequence: Int) throws -> String {
    let hexString: String = try ledgerSpaceHex("escrow") +
    addressToHex(address) +
    String(sequence, radix: HASH_HEX).padding(leftTo: BYTE_LENGTH * 2, withPad: "0")
    return sha512Half(hexString)
}

/**
 * Compute the hash of a Payment Channel.
 *
 * @param address - Account of the Payment Channel.
 * @param dstAddress - Destination Account of the Payment Channel.
 * @param sequence - Sequence number of the Transaction that created the Payment Channel.
 * @returns Hash of the Payment Channel.
 * @category Utilities
 */
public func hashPaymentChannel(
    _ address: String,
    _ dstAddress: String,
    _ sequence: Int
) throws -> String {
    let hexString: String = try ledgerSpaceHex("paychan") +
    addressToHex(address) +
    addressToHex(dstAddress) +
    String(sequence, radix: HASH_HEX).padding(leftTo: BYTE_LENGTH * 2, withPad: "0")
    return sha512Half(hexString)
}

extension String {
    func padding(leftTo paddedLength: Int, withPad pad: String = " ", startingAt padStart: Int = 0) -> String {
        let rightPadded = self.padding(toLength: max(count, paddedLength), withPad: pad, startingAt: padStart)
        return "".padding(toLength: paddedLength, withPad: rightPadded, startingAt: count % paddedLength)
    }

    func padding(rightTo paddedLength: Int, withPad pad: String = " ", startingAt padStart: Int = 0) -> String {
        return self.padding(toLength: paddedLength, withPad: pad, startingAt: padStart)
    }
}
