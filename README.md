<p align="center">
  <a href="https://github.com/Transia-RnD/XRPLSwift">
      <img src="logo.png" width="256" height="256" align="middle">
  </a>
</p>

<p align="center">
  <a href="https://cocoapods.org/pods/XRPLSwift">
    <img src="https://img.shields.io/cocoapods/v/XRPLSwift.svg?style=flat&label=version" alt="Version">
  </a>
  <a href="https://github.com/Transia-RnD/XRPLSwift">
    <img src="https://img.shields.io/cocoapods/l/XRPLSwift.svg?style=flat" alt="License">
  </a>
  <a href="https://github.com/Transia-RnD/XRPLSwift">
    <img src="https://img.shields.io/badge/platforms-macOS%20%7C%20iOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20Linux-lightgrey.svg" alt="Platform">
  </a>
  <a href="https://cocoapods.org/pods/XRPLSwift">
    <img src="https://img.shields.io/badge/supports-CocoaPods%20%7C%20SwiftPM-green.svg" alt="CocoaPods and SPM compatible">
  </a>
   <a href="https://github.com/Transia-RnD/XRPLSwift">
    <img src="https://travis-ci.org/Transia-RnD/XRPLSwift.svg?branch=develop" alt="Travis Build Status">
  </a>
</p>

# XRPLSwift

XRPLSwift is a Swift SDK built for interacting with the XRP Ledger.  XRPLSwift supports offline wallet creation, offline transaction creation/signing, and submitting transactions to the XRP ledger.  XRPLSwift supports both the secp256k1 and ed25519 algorithms.  XRPLSwift is available on iOS, macOS and Linux.  WIP - use at your own risk.

## Author

MitchLang009, mitch.s.lang@gmail.com

## Co-Author

Transia-RnD, dangell@transia.co

## License

XRPLSwift is available under the MIT license. See the LICENSE file for more info.

## Installation

#### CocoaPods

XRPLSwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XRPLSwift'
```
#### Swift Package Manager

You can use [The Swift Package Manager](https://swift.org/package-manager) to
install `XRPLSwift` by adding it to your `Package.swift` file:

```swift
// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
    .package(url: "https://github.com/Transia-RnD/XRPLSwift.git", from: "0.3.0"),
    ]
)
```

## Linux Compatibility

One of the goals of this library is to provide cross-platform support for Linux and support server-side
Swift, however some features may only be available in iOS/macOS due to a lack of Linux supported
libraries (ex. WebSockets).  A test_linux.sh file is included that will run tests in a docker container. All
contributions must compile on Linux.

## Wallets

### Create a new wallet

```swift

import XRPLSwift

// create a completely new, randomly generated wallet
let wallet = SeedWallet() // defaults to secp256k1
let wallet2 = SeedWallet(type: .secp256k1)
let wallet3 = SeedWallet(type: .ed25519)

```

### Derive wallet from a seed

```swift

import XRPLSwift

// generate a wallet from an existing seed
let wallet = try! SeedWallet(seed: "snsTnz4Wj8vFnWirNbp7tnhZyCqx9")

```

### Derive wallet from a mnemonic (BIP32/39/44)

```swift

import XRPLSwift

let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
let walletFromMnemonic = try! MnemonicWallet(mnemonic: mnemonic)

```

### Wallet properties
```swift

import XRPLSwift

let wallet = SeedWallet()

print(wallet.address) // rJk1prBA4hzuK21VDK2vK2ep2PKGuFGnUD
print(wallet.seed) // snsTnz4Wj8vFnWirNbp7tnhZyCqx9
print(wallet.publicKey) // 02514FA7EF3E9F49C5D4C487330CC8882C0B4381BEC7AC61F1C1A81D5A62F1D3CF
print(wallet.privateKey) // 003FC03417669696AB4A406B494E6426092FD9A42C153E169A2B469316EA4E96B7

```

### Validation
```swift

import XRPLSwift

// Address
let btc = "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2"
let xrp = "rPdCDje24q4EckPNMQ2fmUAMDoGCCu3eGK"

SeedWallet.validate(address: btc) // returns false
SeedWallet.validate(address: xrp) // returns true

// Seed
let seed = "shrKftFK3ZkMPkq4xe5wGB8HaNSLf"

SeedWallet.validate(seed: xrp) // returns false
SeedWallet.validate(seed: seed) // returns true

```

## Transactions

### Sending XRP
```swift

import XRPLSwift

let wallet = try! SeedWallet(seed: "shrKftFK3ZkMPkq4xe5wGB8HaNSLf")
let amount = try! Amount(drops: 100000000)
let address = try! Address(rAddress: "rPdCDje24q4EckPNMQ2fmUAMDoGCCu3eGK")

_ = Payment(from: wallet, to: address, amount: amount).send().map { (result) in
    print(result)
}

```

### Sending XRP with custom fields
```swift

import XRPLSwift

let wallet = try! SeedWallet(seed: "shrKftFK3ZkMPkq4xe5wGB8HaNSLf")

let fields: [String:Any] = [
    "TransactionType" : "Payment",
    "Account" : wallet.address,
    "Destination" : "rPdCDje24q4EckPNMQ2fmUAMDoGCCu3eGK",
    "Amount" : "10000000",
    "Flags" : 2147483648,
    "LastLedgerSequence" : 951547,
    "Fee" : "40",
    "Sequence" : 11,
]

// create the transaction (offline)
let transaction = RawTransaction(fields: fields)

// sign the transaction (offline)
let signedTransaction = try! transaction.sign(wallet: wallet)

// submit the transaction (online)
_ = signedTransaction.submit().map { (result) in
    print(result)
}

```


### Sending XRP with autofilled fields

```swift

import XRPLSwift

let wallet = try! SeedWallet(seed: "shrKftFK3ZkMPkq4xe5wGB8HaNSLf")

// dictionary containing partial transaction fields
let partialFields: [String:Any] = [
    "TransactionType" : "Payment",
    "Destination" : "rPdCDje24q4EckPNMQ2fmUAMDoGCCu3eGK",
    "Amount" : "100000000",
    "Flags" : 2147483648,
]

// create the transaction from dictionary
let partialTransaction = Transaction(wallet: wallet, fields: partialFields)

// autofills missing transaction fields (online)
// signs transaction (offline)
// submits transaction (online)
_ = partialTransaction.send().map { (txResult) in
    print(txResult)
}

```

### Transaction Result 

```swift

//    SUCCESS: {
//        result =     {
//            "engine_result" = tesSUCCESS;
//            "engine_result_code" = 0;
//            "engine_result_message" = "The transaction was applied. Only final in a validated ledger.";
//            status = success;
//            "tx_blob" = 12000022800000002400000008201B000E83A6614000000005F5E100684000000000000028732102890EDF51199AEB1815324BA985C192D369B324AF6ABC1EBAD450E07EFBF5997E7446304402203765F06FB1D1D9FE942680A39C0925E95DC0AE18893268FDB5AF3CAFC5F6A87802201EFCE19E9C7ABBDD7C73F651A9AF6A323DDB4CE060A4CB63866512365830BEED81142B2DFB7FF7A2E9D8022144727A06141E4B3907248314F841A55DBAB1296D9A95F4CA8C05B721C1B0585C;
//            "tx_json" =         {
//                Account = rhAK9w7X64AaZqSWEhajcq5vhGtxEcaUS7;
//                Amount = 100000000;
//                Destination = rPdCDje24q4EckPNMQ2fmUAMDoGCCu3eGK;
//                Fee = 40;
//                Flags = 2147483648;
//                LastLedgerSequence = 951206;
//                Sequence = 8;
//                SigningPubKey = 02890EDF51199AEB1815324BA985C192D369B324AF6ABC1EBAD450E07EFBF5997E;
//                TransactionType = Payment;
//                TxnSignature = 304402203765F06FB1D1D9FE942680A39C0925E95DC0AE18893268FDB5AF3CAFC5F6A87802201EFCE19E9C7ABBDD7C73F651A9AF6A323DDB4CE060A4CB63866512365830BEED;
//                hash = 4B709C7DFA8F8F396E4BB2CEACAFD61CA07000940736971AA788754267EE69AD;
//            };
//        };
//    }

```

## Ledger Info

### Check balance
```swift

import XRPLSwift

_ = Ledger.getBalance(address: "rPdCDje24q4EckPNMQ2fmUAMDoGCCu3eGK").map { (amount) in
    print(amount.prettyPrinted()) // 1,800.000000
}

```

## WebSocket Support

WebSockets are only supported on Apple platforms through URLSessionWebSocketTask.  On Linux Ledger.ws is unavailable.  Support for Linux
will be possible with the availability of a WebSocket client library.

More functionality to come.

### Example Command
```swift

import XRPLSwift

Ledger.ws.delegate = self // WebSocketDelegate
Ledger.ws.connect(url: .xrpl_ws_Devnet)
let parameters: [String: Any] = [
    "id" : "test",
    "method" : "fee"
]
let data = try! JSONSerialization.data(withJSONObject: parameters, options: [])
Ledger.ws.send(data: data)

```

### Transaction Stream Request
```swift

import XRPLSwift

Ledger.ws.delegate = self // WebSocketDelegate
Ledger.ws.connect(url: .xrpl_ws_Devnet)
Ledger.ws.subscribe(account: "r34XnDB2zS11NZ1wKJzpU1mjWExGVugTaQ")

```

### Responses/Streams and WebSocketDelegate

```swift

import XRPLSwift

class MyClass: WebSocketDelegate {

    func onConnected(connection: WebSocket) {
        
    }
    
    func onDisconnected(connection: WebSocket, error: Error?) {
        
    }
    
    func onError(connection: WebSocket, error: Error) {
        
    }
    
    func onResponse(connection: WebSocket, response: WebSocketResponse) {
        
    }
    
    func onStream(connection: WebSocket, object: NSDictionary) {
        
    }
    
}

```


https://github.com/LF/xrpl-py/tree/master/xrpl/models/transactions
https://github.com/LF/xrpl-py/tree/master/tests/integration/transactions
https://github.com/xpring-eng/XpringKit/blob/8c71a0c21fba4a112fae47a3cec888bfc40bab98/XpringKit/XRP/ReliableSubmissionClient.swift#L87
