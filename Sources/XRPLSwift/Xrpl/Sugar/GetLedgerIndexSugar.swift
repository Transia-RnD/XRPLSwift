//
//  GetLedgerIndexSugar.swift
//
//
//  Created by Denis Angell on 8/21/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/sugar/getLedgerIndex.ts

/**
 Returns the index of the most recently validated ledger.
 - parameters:
    - client: The Client used to connect to the ledger.
 - returns
 The most recently validated ledger index.
 */
public func getLedgerIndex(client: XrplClient) async throws -> Int {
    let dict: [String: AnyObject] = [
        "command": "ledger",
        "ledger_index": "validated"
    ] as [String: AnyObject]
    let ledgerResponse = try await client.request(LedgerRequest(dict)).wait() as? BaseResponse<LedgerResponse>
    return (ledgerResponse?.result!.ledgerIndex)!
}
