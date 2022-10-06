//
//  BalancesSugar.swift
//
//
//  Created by Denis Angell on 9/4/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/sugar/balances.ts

import Foundation

/**
 Get the XRP balance for an account.
 - parameters:
    - client: A client.
    - address: Address of the account to retrieve XRP balance.
    - ledgerHash: Retrieve the account balances at the ledger with a given ledgerHash.
    - ledgerIndex: Retrieve the account balances at the ledger with a given ledgerIndex.
 - returns
 The XRP balance of the account (as a string).
 */
func getXrpBalance(
    client: XrplClient,
    address: String,
    ledgerHash: String? = nil,
    ledgerIndex: LedgerIndex? = nil
) async -> String {
    let xrpRequest = AccountInfoRequest(account: address, ledgerHash: ledgerHash, ledgerIndex: ledgerIndex)
    let response = try? await client.request(xrpRequest).wait() as? BaseResponse<AccountInfoResponse>
    return try! dropsToXrp((response?.result?.accountData.balance)!)
}
