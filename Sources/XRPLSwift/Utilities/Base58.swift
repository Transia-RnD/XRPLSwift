//
//  BaseX.swift
//  XRPLSwift
//
//  Created by Mitch Lang on 5/3/19.
//

import Foundation
import BigInt

extension String {

    public init(base58Encoding bytes: Data, alphabet: [UInt8] = AddressCodecUtils.xrplAlphabet) {
        var x = BigUInt(bytes)
        let radix = BigUInt(alphabet.count)
        
        var answer = [UInt8]()
        answer.reserveCapacity(bytes.count)

        while x > 0 {
            let (quotient, modulus) = x.quotientAndRemainder(dividingBy: radix)
            answer.append(alphabet[Int(modulus)])
            x = quotient
        }
        
        let prefix = Array(bytes.prefix(while: {$0 == 0})).map { _ in alphabet[0] }
        answer.append(contentsOf: prefix)
        answer.reverse()

        self = String(bytes: answer, encoding: String.Encoding.utf8)!
    }

}

extension Data {
    
    init?(base58Decoding string: String, alphabet: [UInt8] = AddressCodecUtils.xrplAlphabet) {
        var answer = BigUInt(0)
        var j = BigUInt(1)
        let radix = BigUInt(alphabet.count)
        let byteString = [UInt8](string.utf8)

        for ch in byteString.reversed() {
            if let index = alphabet.firstIndex(of: ch) {
                answer = answer + (j * BigUInt(index))
                j *= radix
            } else {
                return nil
            }
        }

        let bytes = answer.serialize()
        self = byteString.prefix(while: { i in i == alphabet[0]}) + bytes
    }

}
