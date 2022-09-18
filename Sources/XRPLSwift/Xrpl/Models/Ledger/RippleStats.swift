//
//  File.swift
//  
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/RippleState.ts

import Foundation

/**
 The RippleState object type connects two accounts in a single currency.
 */
open class RippleState: BaseLedgerEntry {
    var ledgerEntryType: String = "RippleState"
    /// A bit-map of boolean options enabled for this object.
    var flags: Int
    /**
     The balance of the trust line, from the perspective of the low account. A
     negative balance indicates that the low account has issued currency to the
     high account. The issuer is always the neutral value ACCOUNT_ONE.
     */
    let balance: IssuedCurrencyAmount
    /**
     The limit that the low account has set on the trust line. The issuer is
     the address of the low account that set this limit.
     */
    let lowLimit: IssuedCurrencyAmount
    /**
     The limit that the high account has set on the trust line. The issuer is
     the address of the high account that set this limit.
     */
    let highLimit: IssuedCurrencyAmount
    /**
     The identifying hash of the transaction that most recently modified this
     object.
     */
    let previousTxnId: String
    /**
     The index of the ledger that contains the transaction that most recently
     modified this object.
     */
    let previousTxnLgrSeq: Int
    /**
     A hint indicating which page of the low account's owner directory links to
     this object, in case the directory consists of multiple pages.
     */
    let lowNode: String?
    /**
     A hint indicating which page of the high account's owner directory links
     to this object, in case the directory consists of multiple pages.
     */
    let highNode: String?
    /**
     The inbound quality set by the low account, as an integer in the implied
     ratio LowQualityIn:1,000,000,000. As a special case, the value 0 is
     equivalent to 1 billion, or face value.
     */
    let lowQualityIn: Int?
    /**
     The outbound quality set by the low account, as an integer in the implied
     ratio LowQualityOut:1,000,000,000. As a special case, the value 0 is
     equivalent to 1 billion, or face value.
     */
    let lowQualityOut: Int?
    /**
     The inbound quality set by the high account, as an integer in the implied
     ratio HighQualityIn:1,000,000,000. As a special case, the value 0 is
     equivalent to 1 billion, or face value.
     */
    let highQualityIn: Int?
    /**
     The outbound quality set by the high account, as an integer in the implied
     ratio HighQualityOut:1,000,000,000. As a special case, the value 0 is
     equivalent to 1 billion, or face value.
     */
    let highQualityOut: Int?

    enum CodingKeys: String, CodingKey {
        case flags = "Flags"
        case balance = "Balance"
        case lowLimit = "LowLimit"
        case highLimit = "HighLimit"
        case previousTxnId = "PreviousTxnID"
        case previousTxnLgrSeq = "PreviousTxnLgrSeq"
        case lowNode = "LowNode"
        case highNode = "HighNode"
        case lowQualityIn = "LowQualityIn"
        case lowQualityOut = "LowQualityOut"
        case highQualityIn = "HighQualityIn"
        case highQualityOut = "HighQualityOut"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flags = try values.decode(Int.self, forKey: .flags)
        balance = try values.decode(IssuedCurrencyAmount.self, forKey: .balance)
        lowLimit = try values.decode(IssuedCurrencyAmount.self, forKey: .lowLimit)
        highLimit = try values.decode(IssuedCurrencyAmount.self, forKey: .highLimit)
        previousTxnId = try values.decode(String.self, forKey: .previousTxnId)
        previousTxnLgrSeq = try values.decode(Int.self, forKey: .previousTxnLgrSeq)
        lowNode = try? values.decode(String.self, forKey: .lowNode)
        highNode = try? values.decode(String.self, forKey: .highNode)
        lowQualityIn = try? values.decode(Int.self, forKey: .lowQualityIn)
        lowQualityOut = try? values.decode(Int.self, forKey: .lowQualityOut)
        highQualityIn = try? values.decode(Int.self, forKey: .highQualityIn)
        highQualityOut = try? values.decode(Int.self, forKey: .highQualityOut)
        try super.init(from: decoder)
    }
}

enum RippleStateFlags: Int {
    // True, if entry counts toward reserve.
    case lsfLowReserve = 0x00010000
    case lsfHighReserve = 0x00020000
    case lsfLowAuth = 0x00040000
    case lsfHighAuth = 0x00080000
    case lsfLowNoRipple = 0x00100000
    case lsfHighNoRipple = 0x00200000
    // True, low side has set freeze flag
    case lsfLowFreeze = 0x00400000
    // True, high side has set freeze flag
    case lsfHighFreeze = 0x00800
}
