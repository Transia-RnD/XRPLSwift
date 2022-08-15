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

enum HexConvertError: Error {
    case wrongInputStringLength
    case wrongInputStringCharacters
}

public extension StringProtocol {
    func asHexArrayFromNonValidatedSource() -> [UInt8] {
        var startIndex = self.startIndex
        return stride(from: 0, to: count, by: 2).compactMap { _ in
            let endIndex = index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
    
    func toBytes() -> [UInt8] {
        //        if count % 2 != 0 { throw HexConvertError.wrongInputStringLength }
        let characterSet = "0123456789ABCDEFabcdef"
        let wrongCharacter = first { return !characterSet.contains($0) }
        if wrongCharacter != nil { return [] }
        return asHexArrayFromNonValidatedSource()
    }
    
    func asHexArray() throws -> [UInt8] {
        //        if count % 2 != 0 { throw HexConvertError.wrongInputStringLength }
        let characterSet = "0123456789ABCDEFabcdef"
        let wrongCharacter = first { return !characterSet.contains($0) }
        if wrongCharacter != nil { throw HexConvertError.wrongInputStringCharacters }
        return asHexArrayFromNonValidatedSource()
    }
}

extension Array where Element == UInt8 {
    var toHex: String {
        self.toHexString().uppercased()
    }
}

public extension Data {
    var toHex: String {
        self.hexadecimal.uppercased()
//        self.toHexString().uppercased()
    }
    func computePKHash() -> Data {
        let hash256: Data = self.sha256()
        let hash160: Data = RIPEMD160.hash(message: hash256)
        return hash160
    }
}
