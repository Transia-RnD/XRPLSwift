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

// public func subscribeDone(client: Client, done: Mocha.Done): void {
//  client.removeAllListeners()
//  done()
// }

public func fundAccount(
    client: XrplClient,
    wallet: Wallet
) async {
    let json = [
        "TransactionType": "Payment",
        "Account": masterAccount,
        "Destination": wallet.classicAddress,
        // 2 times the amount needed for a new account (20 XRP)
        "Amount": "400000000"
    ] as [String: AnyObject]
    let payment: Transaction = try! Transaction(json)!
    let opts: SubmitOptions = SubmitOptions(autofill: nil, failHard: nil, wallet: Wallet.fromSeed(seed: masterSecret))
    let response = try! await client.submit(transaction: payment, opts: opts).wait() as? BaseResponse<SubmitResponse>
    guard let result = response?.result, result.engineResult == "tesSUCCESS" else {
        assertionFailure("Response not successful, \(response?.result?.engineResult)")
        return
    }
    await ledgerAccept(client: client)
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

public func testTransaction(
    client: XrplClient,
    transaction: Transaction,
    wallet: Wallet
) async {
    // Accept any un-validated changes.
    await ledgerAccept(client: client)

    // sign/submit the transaction
    let response = try! await client.submit(
        transaction: transaction,
        opts: SubmitOptions(
            autofill: false,
            failHard: false,
            wallet: wallet
        )
    ).wait() as! BaseResponse<SubmitResponse>

    //  // check that the transaction was successful
    //  assert.equal(response.type, "response")
    //  assert.equal(
    //    response.result.engine_result,
    //    "tesSUCCESS",
    //    response.result.engine_result_message,
    //  )

    // check that the transaction is on the ledger
    // TODO: SubmitResponse needs to inherit from Base Response and include the type.
    var signedTx = try! response.result?.txJson.toJson()
    signedTx?["hash"] = nil
    await ledgerAccept(client: client)
    let fTx = try! Transaction(signedTx!)
    await verifySubmittedTransaction(client: client, tx: fTx!)
}

public func getXRPBalance(
    client: XrplClient,
    wallet: Wallet
) async -> String {
    let request = AccountInfoRequest(account: wallet.classicAddress)
    return ( try! await client.request(request).wait() as! BaseResponse<AccountInfoResponse>).result!.accountData.balance
}
