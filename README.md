> THIS REPOSITORY IS NOT FINISHED. README IS NOT UP TO DATE. EXPECT DRAGONS. SEE TESTS FOR CURRENT IMPLEMENTATIONS.

# XRPLSwift

A pure Swift implementation for interacting with the XRP Ledger, the `XRPLSwift` library simplifies the hardest parts of XRP Ledger interaction, like serialization and transaction signing, by providing native Swift methods and models for [XRP Ledger transactions](https://xrpl.org/transaction-formats.html) and core server [API](https://xrpl.org/api-conventions.html) ([`rippled`](https://github.com/ripple/rippled)) objects.



```swift
// create a network client
let client = try XrplClient(server: "https://s.altnet.rippletest.net:51234/")

// create a wallet on the testnet
let testWallet: Wallet = client.fundWallet()
print(testWallet)
// publicKey: ED3CC1BBD0952A60088E89FA502921895FC81FBD79CAE9109A8FE2D23659AD5D56
// privateKey: -HIDDEN-
// classicAddress: rBtXmAdEYcno9LWRnAGfT9qBxCeDvuVRZo

// look up account info
let acctInfo: AccountInfo = AccountInfo(
    account: "rBtXmAdEYcno9LWRnAGfT9qBxCeDvuVRZo",
    ledgerIndex: "current",
    queue: true,
    strict: true,
)
let response: BaseResponse<AccountInfoResponse> = client.request(req: acctInfo)
let result = response.result
print(result)
// {
//     "Account": "rBtXmAdEYcno9LWRnAGfT9qBxCeDvuVRZo",
//     "Balance": "1000000000",
//     "Flags": 0,
//     "LedgerEntryType": "AccountRoot",
//     "OwnerCount": 0,
//     "PreviousTxnID": "73CD4A37537A992270AAC8472F6681F44E400CBDE04EC8983C34B519F56AB107",
//     "PreviousTxnLgrSeq": 16233962,
//     "Sequence": 16233962,
//     "index": "FD66EC588B52712DCE74831DCB08B24157DC3198C29A0116AA64D310A58512D7"
// }
```

[![Contributors](https://img.shields.io/github/contributors/Transia-RnD/XRPLSwift.svg)](https://github.com/Transia-RnD/XRPLSwift/graphs/contributors)

## Installation and supported versions

### Cocoapods

The `XRPLSwift` library is available on [CocoaPods](https://cocoapods.org/). Install by adding a line to your `Podfile`:


```
pod 'XRPLSwift'
```

### Swift Package Manager

You can use [The Swift Package Manager](https://swift.org/package-manager) to
install `XRPLSwift` by adding it to your `Package.swift` file:

```swift
// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
    .package(url: "https://github.com/Transia-RnD/XRPLSwift.git", from: "5.6.0"),
    ]
)
```

### Linux Compatibility

One of the goals of this library is to provide cross-platform support for Linux and support server-side
Swift, however some features may only be available in iOS/macOS due to a lack of Linux supported
libraries (ex. WebSockets).  A test_linux.sh file is included that will run tests in a docker container. All
contributions must compile on Linux.

The library supports [Swift 5.6](https://www.swift.org/download/) and later.

[![Supported Versions](https://img.shields.io/cocoapods/v/XRPLSwift.svg)](https://cocoapods.org/pods/XRPLSwift)
[![Platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20iOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20Linux-lightgrey.svg)](https://cocoapods.org/pods/XRPLSwift)
[![Compatible](https://img.shields.io/badge/supports-CocoaPods%20%7C%20SwiftPM-green.svg)](https://cocoapods.org/pods/XRPLSwift)

## Features

Use `XRPLSwift` to build Swift applications that leverage the [XRP Ledger](https://xrpl.org/). The library helps with all aspects of interacting with the XRP Ledger, including:

* Key and wallet management
* Serialization
* Transaction Signing

`XRPLSwift` also provides:

* A network client — See [`XrplClient`](https://XRPLSwift.readthedocs.io/en/stable/source/xrpl.clients.html) for more information.
* Methods for inspecting accounts — See [XRPL Account Methods](https://XRPLSwift.readthedocs.io/en/stable/source/xrpl.account.html) for more information.
* Codecs for encoding and decoding addresses and other objects — See [Core Codecs](https://XRPLSwift.readthedocs.io/en/stable/source/xrpl.core.html) for more information.

## [➡️ Reference Documentation](https://transia-rnd.github.io/XRPLSwift)

See the complete [`XRPLSwift` reference documentation on Read the Docs](https://XRPLSwift.readthedocs.io/en/stable/index.html).


## Usage

The following sections describe some of the most commonly used modules in the `XRPLSwift` library and provide sample code.

### Network client

Use the `XrplClient` library to create a network client for connecting to the XRP Ledger.

```swift
let WSS_URL: String = "wss://s1.ripple.com"
let client: XrplClient = try XrplClient(server: WSS_URL)
```

### Manage keys and wallets

#### `Wallet`

Use the [`Wallet`](https://XRPLSwift.readthedocs.io/en/stable/source/xrpl.wallet.html) module to create a wallet from a given seed or or via a [Testnet faucet](https://xrpl.org/xrp-testnet-faucet.html).

To create a wallet from a seed (in this case, the value generated using [`Keypairs`](#xrpl-keypairs)):

```swift
let walletFromSeed: Wallet = Wallet.Wallet(seed: seed)
print(walletFromSeed)
// publicKey: ED46949E414A3D6D758D347BAEC9340DC78F7397FEE893132AAF5D56E4D7DE77B0
// privateKey: -HIDDEN-
// classicAddress: rG5ZvYsK5BPi9f1Nb8mhFGDTNMJhEhufn6
```

To create a wallet from a Testnet faucet:

```swift
let testWallet: Wallet = fundWallet(client: client)
let testAccount: String = testWallet.classicAddress
print("Classic address: \(testAccount)")
// Classic address: rEQB2hhp3rg7sHj6L8YyR4GG47Cb7pfcuw
```

#### `Keypairs`

Use the [`Keypairs`](https://XRPLSwift.readthedocs.io/en/stable/source/xrpl.core.keypairs.html#module-xrpl.core.keypairs) module to generate seeds and derive keypairs and addresses from those seed values.

Here's an example of how to generate a `seed` value and derive an [XRP Ledger "classic" address](https://xrpl.org/cryptographic-keys.html#account-id-and-address) from that seed.


```swift
let seed: String = keypairs.generateSeed()
let (public, private) = Keypairs.deriveKeypair(seed: seed)
let testAccount: String = Keypairs.deriveClassicAddress(publicKey: public)
print("Here's the public key: \(public)")
print("Here's the private key: \(private)")
print("Store this in a secure place!")
// Here's the public key: ED3CC1BBD0952A60088E89FA502921895FC81FBD79CAE9109A8FE2D23659AD5D56
// Here's the private key: EDE65EE7882847EF5345A43BFB8E6F5EEC60F45461696C384639B99B26AAA7A5CD
// Store this in a secure place!
```

**Note:** You can use `Keypairs.sign` to sign transactions but `XRPLSwift` also provides explicit methods for safely signing and submitting transactions. See [Transaction Signing](#transaction-signing) and [XRPL Transaction Methods](https://XRPLSwift.readthedocs.io/en/stable/source/xrpl.transaction.html#module-xrpl.transaction) for more information.


### Serialize and sign transactions

To securely submit transactions to the XRP Ledger, you need to first serialize data from JSON and other formats into the [XRP Ledger's canonical format](https://xrpl.org/serialization.html), then to [authorize the transaction](https://xrpl.org/transaction-basics.html#authorizing-transactions) by digitally [signing it](https://XRPLSwift.readthedocs.io/en/stable/source/xrpl.core.keypairs.html?highlight=sign#xrpl.core.keypairs.sign) with the account's private key. The `XRPLSwift` library provides several methods to simplify this process.


Use the [`Transaction`](https://XRPLSwift.readthedocs.io/en/stable/source/xrpl.transaction.html) module to sign and submit transactions. The module offers three ways to do this:

* [`safeSignAndSubmitTransaction`](https://XRPLSwift.readthedocs.io/en/stable/source/xrpl.transaction.html#xrpl.transaction.safe_sign_and_submit_transaction) — Signs a transaction locally, then submits it to the XRP Ledger. This method does not implement [reliable transaction submission](https://xrpl.org/reliable-transaction-submission.html#reliable-transaction-submission) best practices, so only use it for development or testing purposes.

* [`safeSignTransaction`](https://XRPLSwift.readthedocs.io/en/stable/source/xrpl.transaction.html#xrpl.transaction.safe_sign_transaction) — Signs a transaction locally. This method **does  not** submit the transaction to the XRP Ledger.

* [`sendReliableSubmission`](https://XRPLSwift.readthedocs.io/en/stable/source/xrpl.transaction.html#xrpl.transaction.send_reliable_submission) — An implementation of the [reliable transaction submission guidelines](https://xrpl.org/reliable-transaction-submission.html#reliable-transaction-submission), this method submits a signed transaction to the XRP Ledger and then verifies that it has been included in a validated ledger (or has failed to do so). Use this method to submit transactions for production purposes.


```swift

let currentValidatedLedger: Int = getLatestValidatedLedgerSequence(client: client)
let testWallet.sequence: Int = getNextValidSeqNumber(classicAddress: testWallet.classicAddress, client: client)

// prepare the transaction
// the amount is expressed in drops, not XRP
// see https://xrpl.org/basic-data-types.html#specifying-currency-amounts
let myTxPayment = Payment(
    account=testWallet.classicAddress,
    amount="2200000",
    destination="rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe",
    lastLedgerSequence=currentValidatedLedger + 20,
    sequence=testWallet.sequence,
    fee="10",
)
// sign the transaction
let myTxPaymentSigned: Transaction = safeSignTransaction(tx: myTxPayment, wallet: testWallet)

// submit the transaction
let txResponse = sendReliableSubmission(tx: myTxPaymentSigned, client: client)
```

#### Get fee from the XRP Ledger


In most cases, you can specify the minimum [transaction cost](https://xrpl.org/transaction-cost.html#current-transaction-cost) of `"10"` for the `fee` field unless you have a strong reason not to. But if you want to get the [current load-balanced transaction cost](https://xrpl.org/transaction-cost.html#current-transaction-cost) from the network, you can use the `get_fee` function:

```swift
fee = getFee(client: client)
print(fee)
// 10
```

#### Auto-filled fields

The `XRPLSwift` library automatically populates the `fee`, `sequence` and `lastLedgerSequence` fields when you create transactions. In the example above, you could omit those fields and let the library fill them in for you.

```swift
// prepare the transaction
// the amount is expressed in drops, not XRP
// see https://xrpl.org/basic-data-types.html#specifying-currency-amounts
let myTxPayment: Payment = Payment(
    account=testWallet.classicAddress,
    amount="2200000",
    destination="rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe"
)

// sign the transaction with the autofill method
// (this will auto-populate the fee, sequence, and last_ledger_sequence)
let myTxPaymentSigned: Transaction = safeSignAndAutofillTransaction(tx: myTxPayment, wallet: testWallet, client: client)
print(myTxPaymentSigned)
// Payment(
//     account='rMPUKmzmDWEX1tQhzQ8oGFNfAEhnWNFwz',
//     transaction_type=<TransactionType.PAYMENT: 'Payment'>,
//     fee='10',
//     sequence=16034065,
//     account_txn_id=None,
//     flags=0,
//     last_ledger_sequence=10268600,
//     memos=None,
//     signers=None,
//     source_tag=None,
//     signing_pub_key='EDD9540FA398915F0BCBD6E65579C03BE5424836CB68B7EB1D6573F2382156B444',
//     txn_signature='938FB22AE7FE76CF26FD11F8F97668E175DFAABD2977BCA397233117E7E1C4A1E39681091CC4D6DF21403682803AB54CC21DC4FA2F6848811DEE10FFEF74D809',
//     amount='2200000',
//     destination='rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe',
//     destination_tag=None,
//     invoice_id=None,
//     paths=None,
//     send_max=None,
//     deliver_min=None
// )

// submit the transaction
let txResponse: BaseResponse<Payment> = sendReliableSubmission(tx: myTxPaymentSigned, client: client)
```


### Subscribe to ledger updates

You can send `subscribe` and `unsubscribe` requests only using the WebSocket network client. These request methods allow you to be alerted of certain situations as they occur, such as when a new ledger is declared.

```swift
url = "wss://s.altnet.rippletest.net/"
req = Subscribe(streams=[StreamParameter.LEDGER])
// NOTE: this code will run forever without a timeout, until the process is killed
with WebsocketClient(url) as client:
    client.send(req)
    for message in client:
        print(message)
// {'result': {'fee_base': 10, 'fee_ref': 10, 'ledger_hash': '7CD50477F23FF158B430772D8E82A961376A7B40E13C695AA849811EDF66C5C0', 'ledger_index': 18183504, 'ledger_time': 676412962, 'reserve_base': 20000000, 'reserve_inc': 5000000, 'validated_ledgers': '17469391-18183504'}, 'status': 'success', 'type': 'response'}
// {'fee_base': 10, 'fee_ref': 10, 'ledger_hash': 'BAA743DABD168BD434804416C8087B7BDEF7E6D7EAD412B9102281DD83B10D00', 'ledger_index': 18183505, 'ledger_time': 676412970, 'reserve_base': 20000000, 'reserve_inc': 5000000, 'txn_count': 0, 'type': 'ledgerClosed', 'validated_ledgers': '17469391-18183505'}
// {'fee_base': 10, 'fee_ref': 10, 'ledger_hash': 'D8227DAF8F745AE3F907B251D40B4081E019D013ABC23B68C0B1431DBADA1A46', 'ledger_index': 18183506, 'ledger_time': 676412971, 'reserve_base': 20000000, 'reserve_inc': 5000000, 'txn_count': 0, 'type': 'ledgerClosed', 'validated_ledgers': '17469391-18183506'}
// {'fee_base': 10, 'fee_ref': 10, 'ledger_hash': 'CFC412B6DDB9A402662832A781C23F0F2E842EAE6CFC539FEEB287318092C0DE', 'ledger_index': 18183507, 'ledger_time': 676412972, 'reserve_base': 20000000, 'reserve_inc': 5000000, 'txn_count': 0, 'type': 'ledgerClosed', 'validated_ledgers': '17469391-18183507'}
```


### Asynchronous Code

This library supports Swift's [`Async`](https://docs.swift.org/3/library/asyncio.html) package, which is used to run asynchronous code. All the async code is in [`Async`](https://XRPLSwift.readthedocs.io/en/stable/source/xrpl.asyncio.html) If you are writing asynchronous code, please note that you will not be able to use any synchronous sugar functions, due to how event loops are handled. However, every synchronous method has a corresponding asynchronous method that you can use.

This sample code is the asynchronous equivalent of the above section on submitting a transaction.

```swift
asyncClient: AsyncClient = AsyncWssClient(WSS_URL)

func submitSampleTransaction() async {
    let currentValidatedLedger: Int = await getLatestValidatedLedgerSequence(client: asyncClient)
    testWallet.sequence = await getNextValidSeqNumber(testWallet.classicAddress, asyncClient)

    // prepare the transaction
    // the amount is expressed in drops, not XRP
    // see https://xrpl.org/basic-data-types.html#specifying-currency-amounts
    let myTxPayment: Payment = Payment(
        account=testWallet.classicAddress,
        amount="2200000",
        destination="rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe",
        last_ledger_sequence=currentValidatedLedger + 20,
        sequence=testWallet.sequence,
        fee="10",
    )
    // sign the transaction
    let myTxPaymentSigned: Transaction = await safeSignTransaction(tx: myTxPayment, wallet: testWallet)

    // submit the transaction
    let txResponse: BaseResponse<Payment> = await sendReliableSubmission(tx: myTxPaymentSigned, client: asyncClient)
}
```

### Encode addresses

Use [`AddressCodec`](https://XRPLSwift.readthedocs.io/en/stable/source/xrpl.core.addresscodec.html) to encode and decode addresses into and from the ["classic" and X-address formats](https://xrpl.org/accounts.html#addresses).

```swift
// convert classic address to x-address
testnetXAddress = try AddressCodec.classicAddressToXaddress(
    classicAddress: "rMPUKmzmDWEX1tQhzQ8oGFNfAEhnWNFwz",
    tag: 0,
    isTest: true
)
print(testnetXAddress)
// T7QDemmxnuN7a52A62nx2fxGPWcRahLCf3qaswfrsNW9Lps
```


## Contributing

If you want to contribute to this project, see [CONTRIBUTING.md].

### Mailing Lists

We have a low-traffic mailing list for announcements of new `XRPLSwift` releases. (About 1 email per week)

+ [Subscribe to xrpl-announce](https://groups.google.com/g/xrpl-announce)

If you're using the XRP Ledger in production, you should run a [rippled server](https://github.com/ripple/rippled) and subscribe to the ripple-server mailing list as well.

+ [Subscribe to ripple-server](https://groups.google.com/g/ripple-server)

### Report an issue

Experienced an issue? Report it [here](https://github.com/XRPLF/XRPLSwift/issues/new).

## License

The `XRPLSwift` library is licensed under the ISC License. See [LICENSE] for more information.



[CONTRIBUTING.md]: CONTRIBUTING.md
[LICENSE]: LICENSE
