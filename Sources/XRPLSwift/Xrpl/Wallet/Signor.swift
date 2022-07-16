////
////  Signor.swift
////  
////
////  Created by Denis Angell on 6/18/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/Wallet/signer.ts
//
//import Foundation
//
//
//public class Signor: Wallet {
//    public func addMultiSignSignature(wallet: Wallet) throws -> RawTransaction {
//        // make sure all fields are compatible
//        self.fields = self.enforceJSONTypes(fields: self.fields)
//        
//        // add account public key to fields
//        self.fields["SigningPubKey"] = ""
//        
//        // serialize transation to binary
//        let blob = Serializer().serializeTx(tx: self.fields, forSigning: true)
//        
//        // add the transaction prefix/suffix to the blob
//        let data: [UInt8] = HASH_TX_MULTISIGN + blob + wallet.accountID
//        
//        // sign the prefixed blob
//        let algorithm = SeedWallet.getSeedTypeFrom(publicKey: wallet.publicKey).algorithm
//        let signature = try algorithm.sign(message: data, privateKey: [UInt8](Data(hex: wallet.privateKey)))
//        
//        // verify signature
//        let verified = try algorithm.verify(signature: signature, message: data, publicKey: [UInt8](Data(hex: wallet.publicKey)))
//        if !verified {
//            fatalError()
//        }
//        
//        // add the signature to the fields
//        let signatureDictionary = NSDictionary(dictionary: [
//            "Signer" : NSDictionary(dictionary: [
//                "Account" : wallet.address,
//                "SigningPubKey" : wallet.publicKey,
//                "TxnSignature" : signature.toHexString().uppercased() as Any,
//            ])
//        ])
//        var signers: [NSDictionary] = self.fields["Signers"] as? [NSDictionary] ?? [NSDictionary]()
//        signers.append(signatureDictionary)
//        signers.sort { (d1, d2) in
//            let n1 = Data(base58Decoding: (d1["Signer"] as! NSDictionary)["Account"] as! String)!
//            let n2 = Data(base58Decoding: (d2["Signer"] as! NSDictionary)["Account"] as! String)!
//            return BigInt(n1.hexadecimal, radix: 16)! < BigInt(n2.hexadecimal, radix: 16)!
//        }
//        self.fields["Signers"] = signers as Any
//        
//        
//        return self
//    }
//}
