//
//  RippleKeystoreV3.swift
//  XRPLSwift
//
//  Created by Denis Angell on 11/19/20.
//  Copyright © 2020 Harp Angell. All rights reserved.
//

import Foundation
import CryptoSwift
//import XRPLSwift

public protocol AbstractRippleKeystore {
    var addresses: [String]? {get}
    var isHDKeystore: Bool {get}
    func UNSAFE_getPrivateKeyData(password: String, account: String) throws -> Data
}

public enum AbstractRippleKeystoreError: Error {
    case noEntropyError
    case keyDerivationError
    case aesError
    case invalidAccountError
    case invalidPasswordError
    case encryptionError(String)
}

func toByteArray<T>(_ value: T) -> [UInt8] {
    var value = value
    return withUnsafeBytes(of: &value) { Array($0) }
}

func scrypt (password: String, salt: Data, length: Int, N: Int, R: Int, P: Int) -> Data? {
    guard let passwordData = password.data(using: .utf8) else {return nil}
    guard let deriver = try? Scrypt(password: passwordData.bytes, salt: salt.bytes, dkLen: length, N: N, r: R, p: P) else {return nil}
    guard let result = try? deriver.calculate() else {return nil}
    return Data(result)
}

public struct RippleKdfParamsV3: Decodable, Encodable {
    var salt: String
    var dklen: Int
    var n: Int?
    var p: Int?
    var r: Int?
    var c: Int?
    var prf: String?
}

public struct RippleCipherParamsV3: Decodable, Encodable {
    var iv: String
}

public struct RippleCryptoParamsV3: Decodable, Encodable {
    var ciphertext: String
    var cipher: String
    var cipherparams: RippleCipherParamsV3
    var kdf: String
    var kdfparams: RippleKdfParamsV3
    var mac: String
    var version: String?
}

public struct RippleKeystoreParamsV3: Decodable, Encodable {
    var address: String?
    var crypto: RippleCryptoParamsV3
    var id: String?
    var version: Int
    
    public init(address ad: String?, crypto cr: RippleCryptoParamsV3, id i: String, version ver: Int) {
        address = ad
        crypto = cr
        id = i
        version = ver
    }
}


public class RippleKeystoreV3: AbstractRippleKeystore {
    // Class
    public func getAddress() -> String? {
        return self.address
    }
        
    // Protocol
    public var addresses: [String]? {
        get {
            if self.address != nil {
                return [self.address!]
            }
            return nil
        }
    }
    public var isHDKeystore: Bool = false
    
    public func UNSAFE_getPrivateKeyData(password: String, account: String) throws -> Data {
        if self.addresses?.count == 1 && account == self.addresses?.last {
            guard let privateKey = try? self.getKeyData(password) else {throw AbstractRippleKeystoreError.invalidPasswordError}
            return privateKey
        }
        throw AbstractRippleKeystoreError.invalidAccountError
    }
    
    public func UNSAFE_getWallet(password: String, account: String) throws -> XRPSeedWallet {
        if self.addresses?.count == 1 && account == self.addresses?.last {
            guard let privateKey = try? self.getKeyData(password) else {throw AbstractRippleKeystoreError.invalidPasswordError}
            guard let string: String = String(data: privateKey, encoding: .utf8) else { throw AbstractRippleKeystoreError.invalidPasswordError }
            return try XRPSeedWallet(seed: string)
        }
        throw AbstractRippleKeystoreError.invalidAccountError
    }
    

    // --------------
    private var address: String?
    public var keystoreParams: RippleKeystoreParamsV3?
    
    public convenience init?(_ jsonString: String) {
        let lowercaseJSON = jsonString.lowercased()
        guard let jsonData = lowercaseJSON.data(using: .utf8) else {return nil}
        self.init(jsonData)
    }
    
    public convenience init?(_ jsonData: Data) {
        guard let keystoreParams = try? JSONDecoder().decode(RippleKeystoreParamsV3.self, from: jsonData) else {return nil}
        self.init(keystoreParams)
    }
    
    public init?(_ keystoreParams: RippleKeystoreParamsV3) {
        if (keystoreParams.version != 3) {return nil}
        if (keystoreParams.crypto.version != nil && keystoreParams.crypto.version != "1") {return nil}
        self.keystoreParams = keystoreParams
        if keystoreParams.address != nil {
            self.address = keystoreParams.address!
        } else {
            return nil
        }
    }
    
    public init? (password: String = "xrp3swift", aesMode: String = "aes-128-cbc") throws {
        guard var newPrivateKey = XRPSeedWallet().seed.data(using: .utf8) else {return nil}
        defer {Data.zero(&newPrivateKey)}
        try encryptDataToStorage(password, keyData: newPrivateKey, aesMode: aesMode)
    }
    
    public init? (privateKey: Data, password: String = "xrp3swift", aesMode: String = "aes-128-cbc") throws {
        guard privateKey.count == 29 else {return nil}
        guard let seed = String(data: privateKey, encoding: .utf8), XRPSeedWallet.validate(seed: seed) else {return nil}
        try encryptDataToStorage(password, keyData: privateKey, aesMode: aesMode)
    }
    
    fileprivate func encryptDataToStorage(_ password: String, keyData: Data?, dkLen: Int=32, N: Int = 4096, R: Int = 6, P: Int = 1, aesMode: String = "aes-128-cbc") throws {
        if (keyData == nil) { throw AbstractRippleKeystoreError.encryptionError("Encryption without key data") }
        let saltLen = 32;
        guard let saltData = Data.randomBytes(length: saltLen) else {throw AbstractRippleKeystoreError.noEntropyError}
        guard let derivedKey = scrypt(password: password, salt: saltData, length: dkLen, N: N, R: R, P: P) else {throw AbstractRippleKeystoreError.keyDerivationError}
        let last16bytes = Data(derivedKey[(derivedKey.count - 16)...(derivedKey.count-1)])
        let encryptionKey = Data(derivedKey[0...15])
        guard let IV = Data.randomBytes(length: 16) else {throw AbstractRippleKeystoreError.noEntropyError}
        var aesCipher : AES?
        switch aesMode {
        case "aes-128-cbc":
            aesCipher = try? AES(key: encryptionKey.bytes, blockMode: CBC(iv: IV.bytes), padding: .noPadding)
        case "aes-128-ctr":
            aesCipher = try? AES(key: encryptionKey.bytes, blockMode: CTR(iv: IV.bytes), padding: .noPadding)
        default:
            aesCipher = nil
        }
        if aesCipher == nil { throw AbstractRippleKeystoreError.aesError }
        
        guard let seed = String(data: keyData!, encoding: .utf8) else {throw AbstractRippleKeystoreError.keyDerivationError}
        guard let bytes = try? XRPSeedWallet.decode(seed: seed) else {throw AbstractRippleKeystoreError.noEntropyError}
        guard let encryptedKey = try aesCipher?.encrypt(bytes) else {throw AbstractRippleKeystoreError.aesError}
        let encryptedKeyData = Data(encryptedKey)
        var dataForMAC = Data()
        dataForMAC.append(last16bytes)
        dataForMAC.append(encryptedKeyData)
        let mac = dataForMAC.sha3(.keccak256)
        let kdfparams = RippleKdfParamsV3(salt: saltData.toHexString(), dklen: dkLen, n: N, p: P, r: R, c: nil, prf: nil)
        let cipherparams = RippleCipherParamsV3(iv: IV.toHexString())
        let crypto = RippleCryptoParamsV3(
            ciphertext: encryptedKeyData.toHexString(),
            cipher: aesMode,
            cipherparams: cipherparams,
            kdf: "scrypt",
            kdfparams: kdfparams,
            mac: mac.toHexString(),
            version: nil
        )
        let wallet = try XRPSeedWallet(seed: seed)
        self.address = wallet.address
        let keystoreparams = RippleKeystoreParamsV3(address: wallet.address, crypto: crypto, id: UUID().uuidString.lowercased(), version: 3)
        self.keystoreParams = keystoreparams
    }
    
    public func regenerate(oldPassword: String, newPassword: String, dkLen: Int=32, N: Int = 4096, R: Int = 6, P: Int = 1) throws {
        var keyData = try self.getKeyData(oldPassword)
        if keyData == nil {
            throw AbstractRippleKeystoreError.encryptionError("Failed to decrypt a keystore")
        }
        defer {Data.zero(&keyData!)}
        try self.encryptDataToStorage(newPassword, keyData: keyData!, aesMode: self.keystoreParams!.crypto.cipher)
    }
    
    fileprivate func getKeyData(_ password: String) throws -> Data? {
        guard let keystoreParams = self.keystoreParams else {
            print("ERROR: PARAMS")
            return nil
        }
        guard let saltData = Data.fromHex(keystoreParams.crypto.kdfparams.salt) else {
            print("ERROR: SALT")
            return nil
        }
        let derivedLen = keystoreParams.crypto.kdfparams.dklen
        var passwordDerivedKey:Data?
        switch keystoreParams.crypto.kdf {
        case "scrypt":
            guard let N = keystoreParams.crypto.kdfparams.n else {
                print("ERROR: KDF-N")
                return nil
            }
            guard let P = keystoreParams.crypto.kdfparams.p else {
                print("ERROR: KDF-P")
                return nil
            }
            guard let R = keystoreParams.crypto.kdfparams.r else {
                print("ERROR: KDF-R")
                return nil
            }
            passwordDerivedKey = scrypt(password: password, salt: saltData, length: derivedLen, N: N, R: R, P: P)
        case "pbkdf2":
            guard let algo = keystoreParams.crypto.kdfparams.prf else {return nil}
            var hashVariant:HMAC.Variant?;
            switch algo {
                case "hmac-sha256" :
                    hashVariant = HMAC.Variant.sha256
                case "hmac-sha384" :
                    hashVariant = HMAC.Variant.sha384
                case "hmac-sha512" :
                    hashVariant = HMAC.Variant.sha512
                default:
                    hashVariant = nil
            }
            guard hashVariant != nil else {return nil}
            guard let c = keystoreParams.crypto.kdfparams.c else {return nil}
            guard let passData = password.data(using: .utf8) else {return nil}
            guard let derivedArray = try? PKCS5.PBKDF2(password: passData.bytes, salt: saltData.bytes, iterations: c, keyLength: derivedLen, variant: hashVariant!).calculate() else {return nil}
            passwordDerivedKey = Data(derivedArray)
        default:
            return nil
        }
        guard let derivedKey = passwordDerivedKey else {
            print("ERROR: DERIVED KEY")
            return nil
        }
        var dataForMAC = Data()
        let derivedKeyLast16bytes = Data(derivedKey[(derivedKey.count - 16)...(derivedKey.count - 1)])
        dataForMAC.append(derivedKeyLast16bytes)
        guard let cipherText = Data.fromHex(keystoreParams.crypto.ciphertext) else {return nil}
        if (cipherText.count != 16) {return nil}
        dataForMAC.append(cipherText)
        let mac = dataForMAC.sha3(.keccak256)
        guard let calculatedMac = Data.fromHex(keystoreParams.crypto.mac), mac.constantTimeComparisonTo(calculatedMac) else {return nil}
        let cipher = keystoreParams.crypto.cipher
        let decryptionKey = derivedKey[0...15]
        guard let IV = Data.fromHex(keystoreParams.crypto.cipherparams.iv) else {return nil}
        var decryptedPK:Array<UInt8>?
        switch cipher {
        case "aes-128-ctr":
            guard let aesCipher = try? AES(key: decryptionKey.bytes, blockMode: CTR(iv: IV.bytes), padding: .noPadding) else {return nil}
            decryptedPK = try aesCipher.decrypt(cipherText.bytes)
        case "aes-128-cbc":
            guard let aesCipher = try? AES(key: decryptionKey.bytes, blockMode: CBC(iv: IV.bytes), padding: .noPadding) else {return nil}
            decryptedPK = try? aesCipher.decrypt(cipherText.bytes)
        default:
            return nil
        }
        let decryptedPKString = try XRPSeedWallet.encode(bytes: decryptedPK!)
        guard decryptedPKString != nil else {return nil}
        return decryptedPKString?.data(using: .utf8)
    }
    
    public func serialize() throws -> Data? {
        guard let params = self.keystoreParams else {return nil}
        let data = try JSONEncoder().encode(params)
        return data
    }
}
