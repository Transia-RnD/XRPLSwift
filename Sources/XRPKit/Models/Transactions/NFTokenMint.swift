//
//  NFTokenMint.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

public enum NFTokenMintFlag: UInt32 {
    case tfBurnable = 1
    case tfOnlyXrp = 2
    case tfTrustline = 4
    case tfTransferable = 8
}

public class NFTokenMint: XRPTransaction {
    
    public init(
        wallet: XRPWallet,
        tokenTaxon: Int,
        issuer: String? = nil,
        transferFee: Int? = nil,
        uri: String? = nil
    ) {
        var _fields: [String:Any] = [
            "TransactionType" : "NFTokenMint",
            "TokenTaxon": tokenTaxon
        ]
        
        if let issuer = issuer {
            _fields["Issuer"] = issuer
        }
        
        // TODO: Hex
        if let transferFee = transferFee {
            _fields["TransferFee"] = transferFee
        }
        
        if let uri = uri {
            _fields["URI"] = uri.data(using: String.Encoding.utf8)?.toHexString().uppercased()
        }
        
        super.init(wallet: wallet, fields: _fields)
    }
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
