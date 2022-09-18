//
//  KeypairsUtils.swift
//  
//
//  Created by Denis Angell on 8/6/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/ripple-keypairs/src/utils.ts

import Foundation

public struct KeyPair {
    public var privateKey: String
    public var publicKey: String
}

extension Array where Element == UInt8 {
    var bytesToHex: String {
        self.toHexString().uppercased()
    }
    var toHex: String {
        self.toHexString().uppercased()
    }
}

public extension Data {
    var bytesToHex: String {
        self.hexadecimal.uppercased()
    }
    var toHex: String {
        self.hexadecimal.uppercased()
    }
    func computePublicKeyHash() -> Data {
        let hash256: Data = self.sha256()
        let hash160: Data = RIPEMD160.hash(message: hash256)
        return hash160
    }
}

public extension StringProtocol {
    var hexToBytes: [UInt8] {
        var startIndex = self.startIndex
        return stride(from: 0, to: count, by: 2).compactMap { _ in
            let endIndex = index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}
