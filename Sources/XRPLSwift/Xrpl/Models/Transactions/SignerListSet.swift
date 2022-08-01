//
//  SignerListSet.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/10/20.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/signerListSet.ts

//public struct SignerEntry {
//    var Account: String
//    var SignerWeight: Int
//}

public class SignerListSet: BaseTransaction {
    /*
    Represents a `SignerListSet <https://xrpl.org/signerlistset.html>`_
    transaction, which creates, replaces, or removes a list of signers that
    can be used to `multi-sign a transaction
    <https://xrpl.org/multi-signing.html>`_.
    */

    public var signerQuorum: Int
    /*
    This field is required.
    :meta hide-value:
    */
    public var signerEntries: [SignerEntry] = []
    
    public init(
        signerQuorum: Int,
        signerEntries: [SignerEntry]
    ) {
        self.signerQuorum = signerQuorum
        self.signerEntries = signerEntries
        super.init(account: "", transactionType: "SignerListSet")
    }
    
    enum CodingKeys: String, CodingKey {
        case signerQuorum = "SignerQuorum"
        case signerEntries = "SignerEntries"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        signerQuorum = try values.decode(Int.self, forKey: .signerQuorum)
        signerEntries = try values.decode([SignerEntry].self, forKey: .signerEntries)
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(signerQuorum, forKey: .signerQuorum)
        try values.encode(signerEntries, forKey: .signerEntries)
    }

}
