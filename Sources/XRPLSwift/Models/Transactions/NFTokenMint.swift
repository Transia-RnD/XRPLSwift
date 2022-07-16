//
//  NFTokenMint.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/nftoken_mint.py

public enum NFTokenMintFlag: UInt32 {
    // Transaction Flags for an NFTokenMint Transaction.

    case tfBurnable = 0x00000001
    /*
    If set, indicates that the minted token may be burned by the issuer even
    if the issuer does not currently hold the token. The current holder of
    the token may always burn it.
    */
    
    case tfOnlyXrp = 0x00000002
    /*
    If set, indicates that the token may only be offered or sold for XRP.
    */
    
    case tfTrustline = 0x00000004
    /*
    If set, indicates that the issuer wants a trustline to be automatically
    created.
    */
    
    case tfTransferable = 0x00000008
    /*
    If set, indicates that this NFT can be transferred. This flag has no
    effect if the token is being transferred from the issuer or to the
    issuer.
    */
}

public class NFTokenMint: Transaction {
    
    /*
    The NFTokenMint transaction creates an NFToken object and adds it to the
    relevant NFTokenPage object of the minter. If the transaction is
    successful, the newly minted token will be owned by the minter account
    specified by the transaction.
    */

    public var nftokenTaxon: Int
    /*
    Indicates the taxon associated with this token. The taxon is generally a
    value chosen by the minter of the token and a given taxon may be used for
    multiple tokens. The implementation reserves taxon identifiers greater
    than or equal to 2147483648 (0x80000000). If you have no use for this
    field, set it to 0.
    :meta hide-value:
    */

    public var issuer: Address?
    /*
    Indicates the account that should be the issuer of this token. This value
    is optional and should only be specified if the account executing the
    transaction is not the `Issuer` of the `NFToken` object. If it is
    present, the `MintAccount` field in the `AccountRoot` of the `Issuer`
    field must match the `Account`, otherwise the transaction will fail.
    */

    public var transferFee: Int?
    /*
    Specifies the fee charged by the issuer for secondary sales of the Token,
    if such sales are allowed. Valid values for this field are between 0 and
    50000 inclusive, allowing transfer rates between 0.000% and 50.000% in
    increments of 0.001%. This field must NOT be present if the
    `tfTransferable` flag is not set.
    */

    public var uri: String?
    /*
    URI that points to the data and/or metadata associated with the NFT.
    This field need not be an HTTP or HTTPS URL; it could be an IPFS URI, a
    magnet link, immediate data encoded as an RFC2379 "data" URL, or even an
    opaque issuer-specific encoding. The URI is not checked for validity.
    This field must be hex-encoded. You can use `xrpl.utils.str_to_hex` to
    convert a UTF-8 string to hex.
    */
    
    public init(
        from wallet: Wallet,
        nftokenTaxon: Int,
        issuer: Address? = nil,
        transferFee: Int? = nil,
        uri: String? = nil
    ) {
        
        self.nftokenTaxon = nftokenTaxon
        self.issuer = issuer
        self.transferFee = transferFee
        self.uri = uri
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        var _fields: [String:Any] = [
            "TransactionType": TransactionType.NFTokenMint.rawValue,
            "NFTokenTaxon": nftokenTaxon
        ]
        
        if let issuer = issuer {
            _fields["Issuer"] = issuer.rAddress
        }
        
        // TODO: Hex
        if let transferFee = transferFee {
            _fields["TransferFee"] = transferFee
        }
        
        if let uri = uri {
            _fields["URI"] = uri
        }
        
        super.init(wallet: wallet, fields: _fields)
    }
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
