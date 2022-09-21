//
//  BalancesSugar.swift
//  
//
//  Created by Denis Angell on 9/4/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/sugar/balances.ts

import Foundation

/**
 * Get the XRP balance for an account.
 *
 * @example
 * ```ts
 * const client = new Client(wss://s.altnet.rippletest.net:51233)
 * const balance = await client.getXrpBalance('rG1QQv2nh2gr7RCZ1P8YYcBUKCCN633jCn')
 * console.log(balance)
 * /// '200'
 * ```
 *
 * @param this - Client.
 * @param address - Address of the account to retrieve XRP balance.
 * @param options - Options to include for getting the XRP balance.
 * @param options.ledger_index - Retrieve the account balances at a given
 * ledger_index.
 * @param options.ledger_hash - Retrieve the account balances at the ledger with
 * a given ledger_hash.
 * @returns The XRP balance of the account (as a string).
 */
func getXrpBalance(
    this: XrplClient,
    address: String,
    ledgerHash: String? = nil,
    ledgerIndex: LedgerIndex? = nil
) async -> String {
    let xrpRequest = AccountInfoRequest(account: address, ledgerHash: ledgerHash, ledgerIndex: ledgerIndex)
    let response = try? await this.request(xrpRequest).wait() as? BaseResponse<AccountInfoResponse>
    return try! dropsToXrp((response?.result?.accountData.balance)!)
}
