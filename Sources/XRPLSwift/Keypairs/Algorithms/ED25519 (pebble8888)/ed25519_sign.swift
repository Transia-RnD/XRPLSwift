//
//  ed25519_sign.swift
//
//  Copyright 2017 pebble8888. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//	arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//	including commercial applications, and to alter it and redistribute it
//	freely, subject to the following restrictions:
//
//	1. The origin of this software must not be misrepresented; you must not
//	claim that you wrote the original software. If you use this software
//	in a product, an acknowledgment in the product documentation would be
//	appreciated but is not required.
//
//	2. Altered source versions must be plainly marked as such, and must not be
//	misrepresented as being the original software.
//
//	3. This notice may not be removed or altered from any source distribution.
//

import Foundation
// swiftlint:disable all

/**
 * ed25519 fast calculation implementation
 * ported from SUPERCOP https://bench.cr.yp.to/supercop.html
 */
public struct Ed25519 {

    static func crypto_hash_sha512(_ r: inout [UInt8], _ k: [UInt8], len: Int) {
        r = sha512(Array(k[0..<len]))
    }

    private static func randombytes(_ r: inout [UInt8], len: Int) {
        r = [UInt8](repeating: 0, count: len)
        // @note Apple API
        r = try! URandom().bytes(count: len)
        //        let result = SecRandomCopyBytes(kSecRandomDefault, len, &r)
        //        assert(result == 0)
    }

    private static func crypto_verify_32(_ x: [UInt8], _ y: [UInt8]) -> Bool {
        if x.count != 32 || y.count != 32 {
            return false
        }
        for i in 0..<32 {
            if x[i] != y[i] {
                return false
            }
        }
        return true
    }

    /// create keypair
    /// - Parameters:
    ///   - publicKey: private key 32bytes
    ///   - secretKey: secret key 32bytes
    public static func generateKeyPair() -> (publicKey: [UInt8], secretKey: [UInt8]) {
        var secretKey = [UInt8](repeating: 0, count: 32)
        // create secret key 32byte
        randombytes(&secretKey, len: 32)
        let publicKey = calcPublicKey(secretKey: secretKey)
        return (publicKey, secretKey)
    }

    /// calc public key from secret key
    /// - Parameters:
    ///   - secretKey: secret key 32bytes
    /// - Return: public key 32bytes
    public static func calcPublicKey(secretKey: [UInt8]) -> [UInt8] {
        assert(secretKey.count == 32)
        var sc_sk = sc()
        var ge_pk = ge()
        var az = [UInt8](repeating: 0, count: 64)
        var pk = [UInt8](repeating: 0, count: 32)
        // sha512 of sk
        crypto_hash_sha512(&az, secretKey, len: 32)
        // calc public key
        az[0] &= 248 // clear lowest 3bit
        az[31] &= 127 // clear highest bit
        az[31] |= 64 // set second highest bit

        sc.sc25519_from32bytes(&sc_sk, az)

        // gepk = a * G
        ge.ge25519_scalarmult_base(&ge_pk, sc_sk)
        ge.ge25519_pack(&pk, ge_pk)
        assert(pk.count == 32)
        return pk
    }

    /// validate key pair
    /// - Parameters:
    ///   - publicKey: public key 32bytes
    ///   - secretKey: secret key 32bytes
    public static func isValidKeyPair(publicKey: [UInt8], secretKey: [UInt8]) -> Bool {
        if publicKey.count != 32 {
            return false
        }
        if secretKey.count != 32 {
            return false
        }
        let calc_pk = calcPublicKey(secretKey: secretKey)
        for i in 0..<32 {
            if calc_pk[i] != publicKey[i] {
                return false
            }
        }
        return true
    }

    /// signing
    /// - Parameters:
    ///   - message: message
    ///   - secretKey: 32 bytes secret key
    /// - Return: 64 bytes signature
    public static func sign(message: [UInt8], secretKey: [UInt8]) -> [UInt8] {
        assert(secretKey.count == 32)
        let mlen: Int = message.count
        var az = [UInt8](repeating: 0, count: 64)
        var nonce = [UInt8](repeating: 0, count: 64)
        var hram = [UInt8](repeating: 0, count: 64)
        var sc_k = sc()
        var sc_s = sc()
        var sc_sk = sc()
        var ge_r = ge()
        /* pk: 32-byte public key A */
        let pk = calcPublicKey(secretKey: secretKey)
        crypto_hash_sha512(&az, secretKey, len: 32)
        az[0] &= 248 // clear lowest 3bit
        az[31] &= 127 // clear highest bit
        az[31] |= 64 // set second highest bit

        var sm = [UInt8](repeating: 0, count: mlen+64)
        for i in 0..<mlen {
            sm[64+i] = message[i]
        }
        for i in 0..<32 {
            sm[32+i] = az[32+i]
        }

        /* az: 32-byte scalar a, 32-byte rendomizer z */
        let data: [UInt8] = Array(sm[32..<(mlen+64)])
        crypto_hash_sha512(&nonce, data, len: mlen+32)
        /* nonce: 64-byte H(z,m) */
        // sck = r
        sc.sc25519_from64bytes(&sc_k, nonce)
        // r * B
        ge.ge25519_scalarmult_base(&ge_r, sc_k)
        // R
        ge.ge25519_pack(&sm, ge_r)
        // set pk
        for i in 0..<32 {
            sm[i+32] = pk[i]
        }
        // k
        crypto_hash_sha512(&hram, sm, len: mlen+64)
        // sc_s = k
        sc.sc25519_from64bytes(&sc_s, hram)
        // sc_sk = s
        sc.sc25519_from32bytes(&sc_sk, az)
        // sc_s = k * s
        sc.sc25519_mul(&sc_s, sc_s, sc_sk)
        // add, modulo L
        sc.sc25519_add(&sc_s, sc_s, sc_k)
        // S
        var a = [UInt8](repeating: 0, count: 32)
        sc.sc25519_to32bytes(&a, sc_s)
        // set S
        for i in 0..<32 {
            sm[32+i] = a[i]
        }

        var signature = [UInt8](repeating: 0, count: 64)
        for i in 0..<64 {
            signature[i] = sm[i]
        }
        return signature
    }
}
