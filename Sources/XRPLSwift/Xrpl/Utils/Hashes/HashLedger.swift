//
//  HashLedger.swift
//
//
//  Created by Denis Angell on 8/6/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/hashes/hashLedger.ts

import Foundation

class HashLedger {
    let HEX = 16

    func intToHex(integer: Int, byteLength: Int) -> String {
        let foo = String(integer, radix: HEX).padding(toLength: byteLength * 2, withPad: "0", startingAt: 0)
        return foo
    }

    func bytesToHex(bytes: [UInt8]) -> String {
        return bytes.map { String(format: "%02hhx", $0) }.joined()
    }

    func bigintToHex(integerString: String, byteLength: Int) -> String {
        guard let integer = Int(integerString) else { return "" }
        let hex = String(integer, radix: HEX)
        return hex.padding(toLength: byteLength * 2, withPad: "0", startingAt: 0)
    }

    func addLengthPrefix(hex: String) throws -> String {
        let length = hex.count / 2
        if length <= 192 {
            return bytesToHex(bytes: [UInt8(length)]) + hex
        }
        if length <= 12480 {
            let prefix = length - 193
            return bytesToHex(bytes: [193 + UInt8(prefix >> 8), UInt8(prefix & 0xff)]) + hex
        }
        if length <= 918744 {
            let prefix = length - 12481
            return bytesToHex(bytes: [241 + UInt8(prefix >> 16), UInt8((prefix >> 8) & 0xff), UInt8(prefix & 0xff)]) + hex
        }
        throw XrplError("variableIntegerOverflow")
    }

    static func hashSignedTx(_ tx: String) throws -> String {
        let txBlob: String = tx
        let txObject: [String: AnyObject] = BinaryCodec.decode(tx)

        if txObject["TxnSignature"] == nil && txObject["Signers"] == nil {
            throw ValidationError("The transaction must be signed to hash it.")
        }

        let prefix = String(HashPrefix.TRANSACTION_ID.rawValue, radix: 16)
        return sha512Half(prefix + txBlob)
    }

    static func hashSignedTx(_ tx: Transaction) throws -> String {
        let txBlob: String = try BinaryCodec.encode(tx.toJson())
        let txObject: [String: AnyObject] = try tx.toJson()

        if txObject["TxnSignature"] == nil && txObject["Signers"] == nil {
            throw ValidationError("The transaction must be signed to hash it.")
        }

        let prefix = String(HashPrefix.TRANSACTION_ID.rawValue, radix: 16)
        return sha512Half(prefix + txBlob)
    }

//    func hashLedgerHeader(_ ledgerHeader: BaseLedger) -> String {
//        let prefix = HashPrefix.ledger.rawValue.uppercased()
//
//        let ledger = prefix +
//            intToHex(Int(ledgerHeader.ledgerIndex), byteLength: 4) +
//            bigintToHex(ledgerHeader.totalCoins, byteLength: 8) +
//            ledgerHeader.parentHash +
//            ledgerHeader.transactionHash +
//            ledgerHeader.accountHash +
//            intToHex(Int(ledgerHeader.parentCloseTime), byteLength: 4) +
//            intToHex(Int(ledgerHeader.closeTime), byteLength: 4) +
//            intToHex(Int(ledgerHeader.closeTimeResolution), byteLength: 1) +
//            intToHex(Int(ledgerHeader.closeFlags), byteLength: 1)
//
//        return sha512Half(ledger)
//    }


//    func hashTxTree(_ transactions: [Transaction]) -> String {
//        let shamap = SHAMap()
//        for txJSON in transactions {
//            let txBlobHex = txJSON.encode()
//            let metaHex = txJSON.metaData?.encode() ?? "{}".data(using: .utf8)!.hexEncodedString()
//            let txHash = hashSignedTx(txJSON)
//            let data = addLengthPrefix(txBlobHex) + addLengthPrefix(metaHex)
//            shamap.addItem(txHash, data, NodeType.transactionMetadata)
//        }
//
//        return shamap.hash
//    }
}
