//
//  NFTokenMint.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/NFTokenMint.ts

// Transaction Flags for an NFTokenMint Transaction.
public enum NFTokenMintFlags: Int {
    case tfBurnable = 0x00000001
    /**
     If set, indicates that the minted token may be burned by the issuer even
     if the issuer does not currently hold the token. The current holder of
     the token may always burn it.
     */

    case tfOnlyXrp = 0x00000002
    /**
     If set, indicates that the token may only be offered or sold for XRP.
     */

    case tfTrustline = 0x00000004
    /**
     If set, indicates that the issuer wants a trustline to be automatically
     created.
     */

    case tfTransferable = 0x00000008
    /**
     If set, indicates that this NFT can be transferred. This flag has no
     effect if the token is being transferred from the issuer or to the
     issuer.
     */
}

/**
 The NFTokenMint transaction creates an NFToken object and adds it to the
 relevant NFTokenPage object of the minter. If the transaction is
 successful, the newly minted token will be owned by the minter account
 specified by the transaction.
 */
public class NFTokenMint: BaseTransaction {
    public let nftokenTaxon: Int
    /**
     Indicates the taxon associated with this token. The taxon is generally a
     value chosen by the minter of the token and a given taxon may be used for
     multiple tokens. The implementation reserves taxon identifiers greater
     than or equal to 2147483648 (0x80000000). If you have no use for this
     field, set it to 0.
     :meta hide-value:
     */

    public let issuer: String?
    /**
     Indicates the account that should be the issuer of this token. This value
     is optional and should only be specified if the account executing the
     transaction is not the `Issuer` of the `NFToken` object. If it is
     present, the `MintAccount` field in the `AccountRoot` of the `Issuer`
     field must match the `Account`, otherwise the transaction will fail.
     */

    public let transferFee: Int?
    /**
     Specifies the fee charged by the issuer for secondary sales of the Token,
     if such sales are allowed. Valid values for this field are between 0 and
     50000 inclusive, allowing transfer rates between 0.000% and 50.000% in
     increments of 0.001%. This field must NOT be present if the
     `tfTransferable` flag is not set.
     */

    public let uri: String?
    /**
     URI that points to the data and/or metadata associated with the NFT.
     This field need not be an HTTP or HTTPS URL; it could be an IPFS URI, a
     magnet link, immediate data encoded as an RFC2379 "data" URL, or even an
     opaque issuer-specific encoding. The URI is not checked for validity.
     This field must be hex-encoded. You can use `xrpl.utils.str_to_hex` to
     convert a UTF-8 string to hex.
     */

    enum CodingKeys: String, CodingKey {
        case nftokenTaxon = "NFTokenTaxon"
        case issuer = "Issuer"
        case transferFee = "TransferFee"
        case uri = "URI"
    }

    public init(
        nftokenTaxon: Int,
        issuer: String? = nil,
        transferFee: Int? = nil,
        uri: String? = nil
    ) {

        self.nftokenTaxon = nftokenTaxon
        self.issuer = issuer
        self.transferFee = transferFee
        self.uri = uri
        super.init(account: "", transactionType: "NFTokenMint")
    }

    public override init(json: [String: AnyObject]) throws {
        let decoder: JSONDecoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(NFTokenMint.self, from: data)
        self.nftokenTaxon = decoded.nftokenTaxon
        self.issuer = decoded.issuer
        self.transferFee = decoded.transferFee
        self.uri = decoded.uri
        try super.init(json: json)
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nftokenTaxon = try values.decode(Int.self, forKey: .nftokenTaxon)
        issuer = try values.decodeIfPresent(String.self, forKey: .issuer)
        transferFee = try values.decodeIfPresent(Int.self, forKey: .transferFee)
        uri = try values.decodeIfPresent(String.self, forKey: .uri)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(nftokenTaxon, forKey: .nftokenTaxon)
        if let issuer = issuer { try values.encode(issuer, forKey: .issuer) }
        if let transferFee = transferFee { try values.encode(transferFee, forKey: .transferFee) }
        if let uri = uri { try values.encode(uri, forKey: .uri) }
    }
}

/**
 Verify the form and type of an NFTokenMint at runtime.
 - parameters:
    - tx: An NFTokenMint Transaction.
 - throws:
 When the NFTokenMint is Malformed.
 */
public func validateNFTokenMint(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["Account"] as? String == tx["Issuer"] as? String {
        throw ValidationError("NFTokenMint: Issuer must not be equal to Account")
    }

    if tx["URI"] is String && !isHex(str: tx["URI"] as! String) {
        throw ValidationError("NFTokenMint: URI must be in hex format")
    }

    if tx["NFTokenTaxon"] == nil {
        throw ValidationError("NFTokenMint: missing field NFTokenTaxon")
    }
}
