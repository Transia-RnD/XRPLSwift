//
//  Transaction.swift
//  XRPLSwift
//
//  Created by Mitch Lang on 5/10/19.
//

import Foundation
import NIO

public class Transaction: RawTransaction {
    
    var wallet: Wallet
    
    @available(*, unavailable)
    override init(fields: [String:Any]) {
      fatalError()
    }
    
    internal init(wallet: Wallet, fields: [String:Any]) {
        self.wallet = wallet
        var _fields = fields
        _fields["Account"] = wallet.address
        super.init(fields: _fields)
    }
    
    // autofills ledger sequence, fee, and sequence
    func autofill() -> EventLoopFuture<Transaction> {
        
        let promise = eventGroup.next().makePromise(of: Transaction.self)

        // network calls to retrive current account and ledger info
        _ = ledger.currentLedgerInfo().map { (ledgerInfo) in
            _ = self.ledger.getAccountInfo(account: self.wallet.address).map { (accountInfo) in
                // dictionary containing transaction fields
                let filledFields: [String:Any] = [
                    "LastLedgerSequence" : ledgerInfo.index+5,
                    "Fee" : "10", // FIXME: determine fee automatically
                    "Sequence" : accountInfo.sequence,
                ]
                self.fields = self.fields.merging(self.enforceJSONTypes(fields: filledFields)) { (_, new) in new }
                promise.succeed(self)
            }.recover { (error) in
                promise.fail(error)
            }
        }.recover { (error) in
            promise.fail(error)
        }
        return promise.futureResult
    }
    
    public func send() -> EventLoopFuture<NSDictionary> {
        
        let promise = eventGroup.next().makePromise(of: NSDictionary.self)
        
        // autofill missing transaction fields (online)
        _ = self.autofill().map { (tx) in
            // sign the transaction (offline)
            let signedTransaction = try! tx.sign(wallet: tx.wallet)
            
            // submit the transaction (online)
            _ = signedTransaction.submit().map { (dict) in
                promise.succeed(dict)
            }.recover { (error) in
                promise.fail(error)
            }
        }.recover { (error) in
            promise.fail(error)
        }
        
        return promise.futureResult
    }
}
