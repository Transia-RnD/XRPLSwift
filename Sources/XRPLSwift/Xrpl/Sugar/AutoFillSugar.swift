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
    ) async -> EventLoopFuture<T> {
        let tx = transaction

        //      setValidAddresses(tx)

        //      setTransactionFlagsToNumber(tx)

        var promises: [Void] = []
        if tx.sequence == nil {
            await promises.append(self.setNextValidSequenceNumber(client: client, tx: tx))
        }
//        if (tx.fee == nil) {
//            promises.append(calculateFeePeTransactionType(client, tx, signersCount))
//        }
//        if (tx.lastLedgerSequence == nil) {
//            promises.append(setLatestValidatedLedgerSequence(client, tx))
//        }
//        if (tx.transactionType == "AccountDelete") {
//            promises.append(checkAccountDeleteBlockers(client, tx))
//        }

        let promise = autofillEventGroup.next().makePromise(of: T.self)
        _ = promises.compactMap({ $0 })
        promise.succeed(tx)
        return promise.futureResult
        //        return promise
        //        return Promise.all(promises).then(() => tx)
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
        let request: AccountInfoRequest = AccountInfoRequest(account: tx.account, ledgerIndex: .string("current"))
        let response = try! await client.request(req: request)?.wait() as? BaseResponse<AccountInfoResponse>
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

    //    async func calculateFeePeTransactionType(
    //      client: XrplClient,
    //      tx: Transaction,
    //      signersCount = 0,
    //    ): Promise<Void> {
    //      // netFee is usually 0.00001 XRP (10 drops)
    //      let netFeeXRP = await getFeeXrp(client)
    //        let netFeeDrops = xrpToDrops(netFeeXRP)
    //      let baseFee = new BigNumber(netFeeDrops)
    //
    //      // EscrowFinish Transaction with Fulfillment
    //      if (tx.TransactionType == "EscrowFinish" && tx.Fulfillment != nil) {
    //        const fulfillmentBytesSize: number = Math.ceil(tx.Fulfillment.length / 2)
    //        // 10 drops × (33 + (Fulfillment size in bytes / 16))
    //        const product = new BigNumber(
    //          // eslint-disable-next-line @typescript-eslint/no-magic-numbers -- expected use of magic numbers
    //          scaleValue(netFeeDrops, 33 + fulfillmentBytesSize / 16),
    //        )
    //        baseFee = product.dp(0, Int.ROUND_CEIL)
    //      }
    //
    //      // AccountDelete Transaction
    //      if (tx.TransactionType === "AccountDelete") {
    //        baseFee = await fetchAccountDeleteFee(client)
    //      }
    //
    //      /*
    //       * Multi-signed Transaction
    //       * 10 drops × (1 + Number of Signatures Provided)
    //       */
    //      if (signersCount > 0) {
    //        baseFee = BigNumber.sum(baseFee, scaleValue(netFeeDrops, 1 + signersCount))
    //      }
    //
    //      const maxFeeDrops = xrpToDrops(client.maxFeeXRP)
    //      const totalFee =
    //        tx.TransactionType === "AccountDelete"
    //          ? baseFee
    //          : BigNumber.min(baseFee, maxFeeDrops)
    //
    //      // Round up baseFee and return it as a string
    //      // eslint-disable-next-line no-param-reassign, @typescript-eslint/no-magic-numbers -- param reassign is safe, base 10 magic num
    //      tx.Fee = totalFee.dp(0, Int.ROUND_CEIL).toString(10)
    //    }
    //
    //    func scaleValue(value, multiplier): string {
    //      return new Int(value).times(multiplier).toString()
    //    }
    //
    //    async func setLatestValidatedLedgerSequence(
    //      client: XrplClient,
    //      tx: Transaction,
    //    ): Promise<void> {
    //      const ledgerSequence = await client.getLedgerIndex()
    //      // eslint-disable-next-line no-param-reassign -- param reassign is safe
    //      tx.LastLedgerSequence = ledgerSequence + LEDGER_OFFSET
    //    }
    //
    //    async func checkAccountDeleteBlockers(
    //      client: XrplClient,
    //      tx: Transaction,
    //    ): Promise<void> {
    //      const request: AccountObjectsRequest = {
    //        command: "account_objects",
    //        account: tx.Account,
    //        ledger_index: "validated",
    //        deletion_blockers_only: true,
    //      }
    //      const response = await client.request(request)
    //      return new Promise((resolve, reject) => {
    //        if (response.result.account_objects.length > 0) {
    //          reject(
    //            new XrplError(
    //              `Account ${tx.Account} cannot be deleted; there are Escrows, PayChannels, RippleStates, or Checks associated with the account.`,
    //              response.result.account_objects,
    //            ),
    //          )
    //        }
    //        resolve()
    //      })
    //    }
}
