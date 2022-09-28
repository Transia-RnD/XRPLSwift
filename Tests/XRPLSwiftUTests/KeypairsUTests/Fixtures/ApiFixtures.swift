//
//  ApiFixtures.swift
//
//
//  Created by Denis Angell on 8/7/22.
//

import Foundation

internal class ApiFixtures {

    struct KeyPair {
        var privateKey: String
        var publicKey: String
    }

    var FIXTURES_JSON: [String: AnyObject] = [:]

    public var SECP256K1_SEED: String
    public let SECP256K1_KEYPAIR: KeyPair
    public let SECP256K1_VALIDATOR_KEYPAIR: KeyPair
    public let SECP256K1_ADDRESS: String
    public let SECP256K1_SIGNATURE: String
    public let SECP256K1_MESSAGE: String

    public let ED25519_SEED: String
    public let ED25519_KEYPAIR: KeyPair
    public let ED25519_VALIDATOR_KEYPAIR: KeyPair
    public let ED25519_ADDRESS: String
    public let ED25519_SIGNATURE: String
    public let ED25519_MESSAGE: String

    init() {
        do {
            let data: Data = apiJson.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: AnyObject] {
                self.FIXTURES_JSON = jsonResult
            }

            let secDict: [String: AnyObject] = self.FIXTURES_JSON["secp256k1"] as! [String: AnyObject]
            let edDict: [String: AnyObject] = self.FIXTURES_JSON["ed25519"] as! [String: AnyObject]

            self.SECP256K1_SEED = secDict["seed"] as! String
            let keypairDict: [String: AnyObject] = secDict["keypair"] as! [String: AnyObject]
            self.SECP256K1_KEYPAIR = KeyPair(
                privateKey: keypairDict["privateKey"] as! String,
                publicKey: keypairDict["publicKey"] as! String
            )
            let secVKeypairDict: [String: AnyObject] = secDict["validatorKeypair"] as! [String: AnyObject]
            self.SECP256K1_VALIDATOR_KEYPAIR = KeyPair(
                privateKey: secVKeypairDict["privateKey"] as! String,
                publicKey: secVKeypairDict["publicKey"] as! String
            )
            self.SECP256K1_ADDRESS = secDict["address"] as! String
            self.SECP256K1_SIGNATURE = secDict["signature"] as! String
            self.SECP256K1_MESSAGE = secDict["message"] as! String

            self.ED25519_SEED = edDict["seed"] as! String
            let edKeypairDict: [String: AnyObject] = edDict["keypair"] as! [String: AnyObject]
            self.ED25519_KEYPAIR = KeyPair(
                privateKey: edKeypairDict["privateKey"] as! String,
                publicKey: edKeypairDict["publicKey"] as! String
            )
            let edVKeypairDict: [String: AnyObject] = edDict["validatorKeypair"] as! [String: AnyObject]
            self.ED25519_VALIDATOR_KEYPAIR = KeyPair(
                privateKey: edVKeypairDict["privateKey"] as! String,
                publicKey: edVKeypairDict["publicKey"] as! String
            )
            self.ED25519_ADDRESS = edDict["address"] as! String
            self.ED25519_SIGNATURE = edDict["signature"] as! String
            self.ED25519_MESSAGE = secDict["message"] as! String

        } catch {
            self.SECP256K1_SEED = ""
            self.SECP256K1_KEYPAIR = KeyPair(privateKey: "", publicKey: "")
            self.SECP256K1_VALIDATOR_KEYPAIR = KeyPair(privateKey: "", publicKey: "")
            self.SECP256K1_ADDRESS = ""
            self.SECP256K1_SIGNATURE = ""
            self.SECP256K1_MESSAGE = ""
            self.ED25519_SEED = ""
            self.ED25519_KEYPAIR = KeyPair(privateKey: "", publicKey: "")
            self.ED25519_VALIDATOR_KEYPAIR = KeyPair(privateKey: "", publicKey: "")
            self.ED25519_ADDRESS = ""
            self.ED25519_SIGNATURE = ""
            self.ED25519_MESSAGE = ""
        }
    }
}
