//
//  IUtils.swift
//  
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/utils.ts

import Foundation
@testable import NIO
@testable import XRPLSwift

let masterAccount = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
let masterSecret = "snoPBrXtMeMyMHUVTgbuqAfg1SUTb"

public func ledgerAccept(client: XrplClient) async {
    let request = [ "command": "ledger_accept" ] as [String: AnyObject]
    _ = try! await client.connection.request(request: BaseRequest(request))
}

//public func subscribeDone(client: Client, done: Mocha.Done): void {
//  client.removeAllListeners()
//  done()
//}

public func fundAccount(
    client: XrplClient,
    wallet: Wallet
) async {
    let json = [
        "TransactionType": "Payment",
        "Account": masterAccount,
        "Destination": wallet.classicAddress,
        // 2 times the amount needed for a new account (20 XRP)
        "Amount": "400000000",
    ] as [String: AnyObject]
    let payment: Transaction = try! Transaction(json)!
    let opts: SubmitOptions = SubmitOptions(autofill: nil, failHard: nil, wallet: Wallet.fromSeed(seed: masterSecret))
    let response = try! await client.submit(transaction: payment, opts: opts).wait() as? BaseResponse<SubmitResponse>
    guard let result = response?.result, result.engineResult == "tesSUCCESS" else {
        assertionFailure("Response not successful, \(response?.result?.engineResult)")
        return
    }
    await ledgerAccept(client: client)
    print(response)
    var signedTx: [String: AnyObject] = try! result.txJson.toJson()
    signedTx["hash"] = nil
    //    await verifySubmittedTransaction(client: client, tx: try! Transaction(signedTx)!)
}

public func generateFundedWallet(client: XrplClient) async -> Wallet {
    let wallet = Wallet.generate()
    await fundAccount(client: client, wallet: wallet)
    return wallet
}

public func verifySubmittedTransaction(
    client: XrplClient,
    //  tx: Transaction | string,
    tx: Transaction,
    hashTx: String? = nil
) async {
    print("verifySubmittedTransaction")
    //    let hash = hashTx ?? try! hashSignedTx(tx: tx)
    //    let response = await client.request(TxRequest([
    //        "command": "tx",
    //        "transaction": hash,
    //    ] as [String: AnyObject])
    
    //  assert(data.result)
    //  assert.deepEqual(
    //    _.omit(data.result, [
    //      "date",
    //      "hash",
    //      "inLedger",
    //      "ledger_index",
    //      "meta",
    //      "validated",
    //    ]),
    //    typeof tx === "string" ? decode(tx) : tx,
    //  )
    //  if (typeof data.result.meta === "object") {
    //    assert.strictEqual(data.result.meta.TransactionResult, "tesSUCCESS")
    //  } else {
    //    assert.strictEqual(data.result.meta, "tesSUCCESS")
    //  }
}
//
//export function testTransaction(
//  client: Client,
//  transaction: Transaction,
//  wallet: Wallet,
//) -> async Promise<void> {
//  // Accept any un-validated changes.
//  await ledgerAccept(client)
//
//  // sign/submit the transaction
//  const response = await client.submit(transaction, { wallet })
//
//  // check that the transaction was successful
//  assert.equal(response.type, "response")
//  assert.equal(
//    response.result.engine_result,
//    "tesSUCCESS",
//    response.result.engine_result_message,
//  )
//
//  // check that the transaction is on the ledger
//  const signedTx = _.omit(response.result.tx_json, "hash")
//  await ledgerAccept(client)
//  await verifySubmittedTransaction(client, signedTx as Transaction)
//}
//
//public func getXRPBalance(
//  client: XrplClient,
//  wallet: Wallet,
//) -> async Promise<string> {
//  let request: AccountInfoRequest = {
//    command: "account_info",
//    account: wallet.classicAddress,
//  }
//  return (await client.request(request)).result.account_data.Balance
//}
