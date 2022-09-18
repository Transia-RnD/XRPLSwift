//
//  File.swift
//  
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/NegativeUNL.ts

import Foundation

class DisabledValidator: Codable {
    let firstLedgerSequence: Int
    let publicKey: String

    enum CodingKeys: String, CodingKey {
        case firstLedgerSequence = "FirstLedgerSequence"
        case publicKey = "PublicKey"
    }
}

/**
 The NegativeUNL object type contains the current status of the Negative UNL,
 a list of trusted validators currently believed to be offline.
 */
open class NegativeUNL: BaseLedgerEntry {
    var ledgerEntryType: String = "NegativeUNL"
    /**
     A list of trusted validators that are currently disabled.
     */
    let disabledValidators: [DisabledValidator]?
    /**
     The public key of a trusted validator that is scheduled to be disabled in
     the next flag ledger.
     */
    let validatorToDisable: String?
    /**
     The public key of a trusted validator in the Negative UNL that is
     scheduled to be re-enabled in the next flag ledger.
     */
    let validatorToReEnable: String?

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        disabledValidators = try values.decode([DisabledValidator].self, forKey: .disabledValidators)
        validatorToDisable = try values.decode(String.self, forKey: .validatorToDisable)
        validatorToReEnable = try values.decode(String.self, forKey: .validatorToReEnable)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case disabledValidators = "DisabledValidators"
        case validatorToDisable = "ValidatorToDisable"
        case validatorToReEnable = "ValidatorToReEnable"
    }
}
