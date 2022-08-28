//
//  AutoFill.swift
//
//
//  Created by Denis Angell on 7/31/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/sugar/autofill.ts

import Foundation
import NIO

private let autofillEventGroup = MultiThreadedEventLoopGroup(numberOfThreads: 4)

/**
 * Autofills fields in a transaction. This will set `Sequence`, `Fee`,
 * `lastLedgerSequence` according to the current state of the server this Client
 * is connected to. It also converts all X-Addresses to classic addresses and
 * flags interfaces into numbers.
 *
 * @param this - A client.
 * @param transaction - A {@link Transaction} in JSON format
 * @param signersCount - The expected number of signers for this transaction.
 * Only used for multisigned transactions.
 * @returns The autofilled transaction.
 */
public class AutoFillSugar {
    // Expire unconfirmed transactions after 20 ledger versions, approximately 1 minute, by default
    // swiftlint:disable:next identifier_name
    let LEDGER_OFFSET = 20
    struct ClassicAccountAndTag {
        private let classicAccount: String
        private let tag: Int? // JM: Int | Bool only false?
    }

    func autofill<T: BaseTransaction>(
        client: XrplClient,
        transaction: T,
        signersCount: Int?
    ) async throws -> EventLoopFuture<T> {
        let tx = transaction

        //      setValidAddresses(tx)

        //      setTransactionFlagsToNumber(tx)

        var promises: [Void] = []
        if tx.sequence == nil {
            await promises.append(self.setNextValidSequenceNumber(client: client, tx: tx))
        }
        if tx.fee == nil {
            await promises.append(try self.calculateFeePeTransactionType(client: client, tx: tx, signersCount: signersCount))
        }
        if tx.lastLedgerSequence == nil {
            await promises.append(try self.setLatestValidatedLedgerSequence(client: client, tx: tx))
        }
        if tx.transactionType == "AccountDelete" {
            await promises.append(try self.checkAccountDeleteBlockers(client: client, tx: tx))
        }
        let promise = autofillEventGroup.next().makePromise(of: T.self)
        _ = promises.compactMap({ $0 })
        promise.succeed(tx)
        return promise.futureResult
    }
    //    func setValidAddresses(tx: Transaction) -> Void {
    //      validateAccountAddress(tx, "Account", "SourceTag")
    //      // eslint-disable-next-line @typescript-eslint/dot-notation -- Destination can exist on Transaction
    //      if (tx["Destination"] != nil) {
    //        validateAccountAddress(tx, "Destination", "DestinationTag")
    //      }
    //
    //      // DepositPreauth:
    //      convertToClassicAddress(tx, "Authorize")
    //      convertToClassicAddress(tx, "Unauthorize")
    //      // EscrowCancel, EscrowFinish:
    //      convertToClassicAddress(tx, "Owner")
    //      // SetRegularKey:
    //      convertToClassicAddress(tx, "RegularKey")
    //    }
    //
    //    func validateAccountAddress(
    //      tx: Transaction,
    //      accountField: String,
    //      tagField: String,
    //    ) -> Void {
    //      // if X-address is given, convert it to classic address
    //      let { classicAccount, tag } = getClassicAccountAndTag(tx[accountField])
    //      // eslint-disable-next-line no-param-reassign -- param reassign is safe
    //      tx[accountField] = classicAccount
    //
    //      if (tag != nil && tag !== false) {
    //        if (tx[tagField] && tx[tagField] !== tag) {
    //          throw new ValidationError(
    //            `The ${tagField}, if present, must match the tag of the ${accountField} X-address`,
    //          )
    //        }
    //        // eslint-disable-next-line no-param-reassign -- param reassign is safe
    //        tx[tagField] = tag
    //      }
    //    }
    //
    //    func getClassicAccountAndTag(
    //      Account: string,
    //      expectedTag?: number,
    //    ): ClassicAccountAndTag {
    //      if (isValidXAddress(Account)) {
    //        const classic = xAddressToClassicAddress(Account)
    //        if (expectedTag != nil && classic.tag !== expectedTag) {
    //          throw new ValidationError(
    //            "address includes a tag that does not match the tag specified in the transaction",
    //          )
    //        }
    //        return {
    //          classicAccount: classic.classicAddress,
    //          tag: classic.tag,
    //        }
    //      }
    //      return {
    //        classicAccount: Account,
    //        tag: expectedTag,
    //      }
    //    }
    //
    //    func convertToClassicAddress(tx: Transaction, fieldName: String) -> {
    //      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment -- assignment is safe
    //      let account = tx[fieldName]
    //      if (typeof account == "string") {
    //        const { classicAccount } = getClassicAccountAndTag(account)
    //        // eslint-disable-next-line no-param-reassign -- param reassign is safe
    //        tx[fieldName] = classicAccount
    //      }
    //    }
    //
    func setNextValidSequenceNumber(
        client: XrplClient,
        tx: BaseTransaction
    ) async {
        let request = AccountInfoRequest(account: tx.account, ledgerIndex: .string("current"))
        let response = try! await client.request(r: request).wait() as? BaseResponse<AccountInfoResponse>
        print(response)
        print(response!.result)
        print(response!.result?.accountData.sequence)
        tx.sequence = response!.result?.accountData.sequence
    }
    
    //    async func fetchAccountDeleteFee(client: Client): EventLoopFuture<Int> {
    //        let response = await client.request({ command: "server_state" })
    //      let fee = response.result.state.validated_ledger?.reserve_inc
    //
    //      if fee == nil {
    //        return Promise.reject(new Error("Could not fetch Owner Reserve."))
    //      }
    //
    //      return new BigNumber(fee)
    //    }
    
    func calculateFeePeTransactionType(
        client: XrplClient,
        tx: BaseTransaction,
        signersCount: Int? = 0
    ) async throws {
        // netFee is usually 0.00001 XRP (10 drops)
//        let netFeeXRP = await getFeeXrp(client)
//        let netFeeDrops = xrpToDrops(netFeeXRP)
//        let baseFee = new BigNumber(netFeeDrops)
        
//        // EscrowFinish Transaction with Fulfillment
//        if tx.TransactionType == "EscrowFinish" && tx.Fulfillment != nil {
//            let fulfillmentBytesSize: Int = Math.ceil(tx.Fulfillment.length / 2)
//            // 10 drops × (33 + (Fulfillment size in bytes / 16))
//            let product = new BigNumber(scaleValue(netFeeDrops, 33 + fulfillmentBytesSize / 16))
//            baseFee = product.dp(0, Int.ROUND_CEIL)
//        }
        
//        // AccountDelete Transaction
//        if tx.TransactionType == "AccountDelete" {
//            baseFee = await fetchAccountDeleteFee(client)
//        }
        
        /*
         * Multi-signed Transaction
         * 10 drops × (1 + Number of Signatures Provided)
         */
//        if (signersCount > 0) {
//            baseFee = BigNumber.sum(baseFee, scaleValue(netFeeDrops, 1 + signersCount))
//        }
        
//        let maxFeeDrops = xrpToDrops(client.maxFeeXRP)
//        let totalFee = tx.TransactionType === "AccountDelete"
//        ? baseFee
//        : BigNumber.min(baseFee, maxFeeDrops)
        
        // Round up baseFee and return it as a string
        // eslint-disable-next-line no-param-reassign, @typescript-eslint/no-magic-numbers -- param reassign is safe, base 10 magic num
//        tx.Fee = totalFee.dp(0, Int.ROUND_CEIL).toString(10)
        tx.fee = "100"
    }
    
    func scaleValue(value: String, multiplier: Int) -> String {
        return String(Int(value)! * multiplier)
    }
    
    func setLatestValidatedLedgerSequence(
        client: XrplClient,
        tx: BaseTransaction
    ) async throws {
        let ledgerSequence = try await client.getLedgerIndex()
        tx.lastLedgerSequence = ledgerSequence + LEDGER_OFFSET
    }
    
    func checkAccountDeleteBlockers(
        client: XrplClient,
        tx: BaseTransaction
    ) async throws {
        let request = try AccountObjectsRequest([
            "command": "account_objects",
            "account": tx.account,
            "ledger_index": "validated",
            "deletion_blockers_only": true
        ] as [String: AnyObject])
        let response = try await client.request(request).wait() as? BaseResponse<AccountObjectsResponse>
        if let result = response?.result, result.accountObjects.count > 0 {
            throw XrplError.unknown(
                "Account \(tx.account) cannot be deleted; there are Escrows, PayChannels, RippleStates, or Checks associated with the account."
            )
        }
    }
}
