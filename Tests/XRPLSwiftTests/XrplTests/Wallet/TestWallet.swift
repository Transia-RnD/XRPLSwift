//
//  TestWallet.swift
//  
//
//  Created by Denis Angell on 8/13/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/wallet/index.ts

import XCTest
@testable import XRPLSwift

final class TestUWallet: XCTestCase {

    let classicAddressPrefix: String = "r"
    let ed25519KeyPrefix: String = "ED"
    let secp256k1PrivateKeyPrefix: String = "00"

    let seed: String = "ssL9dv2W5RK8L3tuzQxYY6EaZhSxW"
    let publicKey: String = "030E58CDD076E798C84755590AAF6237CA8FAE821070A59F648B517A30DC6F589D"
    let privateKey: String = "00141BA006D3363D2FB2785E8DF4E44D3A49908780CB4FB51F6D217C08C021429F"

    func testWalletConstructor() {
        let masterAddress: String = "rUAi7pipxGpYfPNg3LtPcf2ApiS8aw9A93"
        let regularKeyPair = KeyPair(
            privateKey: "aBRNH5wUurfhZcoyR6nRwDSa95gMBkovBJ8V4cp1C1pM28H7EPL1",
            publicKey: "sh8i92YRnEjJy3fpFkL8txQSCVo79"
        )
        let wallet = Wallet(
            publicKey: regularKeyPair.publicKey,
            privateKey: regularKeyPair.privateKey,
            masterAddress: masterAddress,
            seed: nil
        )
        XCTAssert(wallet.publicKey == regularKeyPair.publicKey)
        XCTAssert(wallet.privateKey == regularKeyPair.privateKey)
        XCTAssert(wallet.classicAddress == masterAddress)
    }

    func testWalletGenerateDefault() {

        let wallet = Wallet.generate()

        //        XCTAssert(wallet.publicKey is String)
        //        XCTAssert(wallet.privateKey is String)
        //        XCTAssert(wallet.classicAddress is String)
        //        XCTAssert(wallet.address() is String)
        XCTAssertTrue(wallet.classicAddress == wallet.address())
        //        XCTAssert(wallet.seed is String)
        XCTAssertTrue(wallet.publicKey.starts(with: ed25519KeyPrefix))
        XCTAssertTrue(wallet.privateKey.starts(with: ed25519KeyPrefix))
        XCTAssertTrue(wallet.classicAddress.starts(with: classicAddressPrefix))
    }

    func testWalletGenerateSECP256() {

        let wallet = Wallet.generate(algorithm: .secp256k1)

        //        XCTAssert(wallet.publicKey is String)
        //        XCTAssert(wallet.privateKey is String)
        //        XCTAssert(wallet.classicAddress is String)
        //        XCTAssert(wallet.address() is String)
        XCTAssertTrue(wallet.classicAddress == wallet.address())
        //        XCTAssert(wallet.seed is String)
        XCTAssertTrue(wallet.privateKey.starts(with: secp256k1PrivateKeyPrefix))
        XCTAssertTrue(wallet.classicAddress.starts(with: classicAddressPrefix))
    }

    func testWalletGenerateED25519() {

        let wallet = Wallet.generate(algorithm: .ed25519)

        //        XCTAssert(wallet.publicKey is String)
        //        XCTAssert(wallet.privateKey is String)
        //        XCTAssert(wallet.classicAddress is String)
        //        XCTAssert(wallet.address() is String)
        XCTAssertTrue(wallet.classicAddress == wallet.address())
        //        XCTAssert(wallet.seed is String)
        XCTAssertTrue(wallet.publicKey.starts(with: ed25519KeyPrefix))
        XCTAssertTrue(wallet.privateKey.starts(with: ed25519KeyPrefix))
        XCTAssertTrue(wallet.classicAddress.starts(with: classicAddressPrefix))
    }

    func testWalletFromSeed() {

        let wallet = Wallet.fromSeed(seed: seed)

        XCTAssertEqual(wallet.publicKey, publicKey)
        XCTAssertEqual(wallet.privateKey, privateKey)
    }

    func testWalletFromSeedSECP256K1() {
        let wallet = Wallet.fromSeed(seed: seed)

        XCTAssertEqual(wallet.publicKey, publicKey)
        XCTAssertEqual(wallet.privateKey, privateKey)
    }

    func testWalletFromSeedED25519() {
        let wallet = Wallet.fromSeed(seed: seed)

        XCTAssertEqual(wallet.publicKey, publicKey)
        XCTAssertEqual(wallet.privateKey, privateKey)
    }

//    func testWalletFromMnemonicSECP256K1() {
//
//        let mnemonic: String = "CAB BETH HANK BIRD MEND SIGN GILD ANY KERN HYDE CHAT STUB"
//        let expectedSeed = "snVB4iTWYqsWZaj1hkvAy1QzqNbAg"
//        let mnemonicOptions: MnemonicOptions = MnemonicOptions(
//            masterAddress: nil,
//            derivationPath: DerivationPath(),
//            mnemonicEncoding: "rfc1751",
//            algorithm: .secp256k1
//        )
//        let wallet: Wallet = try! Wallet.fromMnemonic(mnemonic: mnemonic, opts: mnemonicOptions)
//        XCTAssertEqual(wallet.seed, expectedSeed)
//    }

//    func testWalletFromMnemonicED25519() {
//
//        let mnemonic: String = "CAB BETH HANK BIRD MEND SIGN GILD ANY KERN HYDE CHAT STUB"
//        let expectedSeed = "snVB4iTWYqsWZaj1hkvAy1QzqNbAg"
//        let mnemonicOptions: MnemonicOptions = MnemonicOptions(
//            masterAddress: nil,
//            derivationPath: DerivationPath(),
//            mnemonicEncoding: "rfc1751",
//            algorithm: .ed25519
//        )
//        let wallet: Wallet = try! Wallet.fromMnemonic(mnemonic: mnemonic, opts: mnemonicOptions)
//        XCTAssertEqual(wallet.seed, expectedSeed)
//    }

//    func testInvalidMnemonicAlgorithmRFC() {
//
//        let mnemonic: String = "CAB BETH HANK BIRD MEND SIGN GILD ANY KERN HYDE CHAT STUB"
//        let expectedSeed = "snVB4iTWYqsWZaj1hkvAy1QzqNbAg"
//        let mnemonicOptions: MnemonicOptions = MnemonicOptions(
//            masterAddress: nil,
//            derivationPath: DerivationPath(),
//            mnemonicEncoding: "bip39",
//            algorithm: .ed25519
//        )
//        let wallet: Wallet = try! Wallet.fromMnemonic(mnemonic: mnemonic, opts: mnemonicOptions)
//        XCTAssertEqual(wallet.seed, expectedSeed)
//    }

//    func testInvalidMnemonicAlgorithmBIP() {
//
//        let mnemonic: String = "draw attack antique swing base employ blur above palace lucky glide clap pen use illegal"
//        let expectedSeed = "snVB4iTWYqsWZaj1hkvAy1QzqNbAg"
//        let mnemonicOptions: MnemonicOptions = MnemonicOptions(
//            masterAddress: nil,
//            derivationPath: DerivationPath(),
//            mnemonicEncoding: "rfc1751",
//            algorithm: .ed25519
//        )
//        let wallet: Wallet = try! Wallet.fromMnemonic(mnemonic: mnemonic, opts: mnemonicOptions)
//        XCTAssertEqual(wallet.seed, expectedSeed)
//    }

//    func testWalletFromMnemonicRFCLower() {
//
//        let mnemonic: String = "cab beth hank bird mend sign gild any kern hyde chat stub"
//        let expectedSeed = "snVB4iTWYqsWZaj1hkvAy1QzqNbAg"
//        let mnemonicOptions: MnemonicOptions = MnemonicOptions(
//            masterAddress: nil,
//            derivationPath: DerivationPath(),
//            mnemonicEncoding: "rfc1751",
//            algorithm: .ed25519
//        )
//        let wallet: Wallet = try! Wallet.fromMnemonic(mnemonic: mnemonic, opts: mnemonicOptions)
//        XCTAssertEqual(wallet.seed, expectedSeed)
//    }

    func testWalletFromKeyPair() {

        let masterAddress: String = "rUAi7pipxGpYfPNg3LtPcf2ApiS8aw9A93"
        let seed: String = "sh8i92YRnEjJy3fpFkL8txQSCVo79"
        let keypair: KeyPair = KeyPair(
            privateKey: "004265A28F3E18340A490421D47B2EB8DBC2C0BF2C24CEFEA971B61CED2CABD233",
            publicKey: "03AEEFE1E8ED4BBC009DE996AC03A8C6B5713B1554794056C66E5B8D1753C7DD0E"
        )
        //        let opts: SeedOptions = SeedOptions(masterAddress: masterAddress, algorithm: .ed25519, seed: nil)
        let wallet: Wallet = Wallet.fromSeed(seed: seed, masterAddress: masterAddress)
        XCTAssertEqual(wallet.publicKey, keypair.publicKey)
        XCTAssertEqual(wallet.privateKey, keypair.privateKey)
        XCTAssertEqual(wallet.classicAddress, masterAddress)
    }
}

//final class TestWalletFromMnemonic: XCTestCase {
//
//    let mnemonic: String = "assault rare scout seed design extend noble drink talk control guitar quote"
//    let publicKey: String = "035953FCD81D001CF634EB44A87940F3F98ADF2483D09C914BAED0539BE50F385D"
//    let privateKey: String = "0013FC461CA5799F1357C8130AF703CBA7E9C28E072C6CA8F7DEF8601CDE98F394"
//
//    func testWalletGenerateDefault() {
//        let opts: MnemonicOptions = MnemonicOptions(
//            masterAddress: nil,
//            derivationPath: DerivationPath(),
//            mnemonicEncoding: nil
//        )
//        let wallet = try! Wallet.fromMnemonic(mnemonic: mnemonic, opts: opts)
//
//        XCTAssertEqual(wallet.publicKey, publicKey)
//        XCTAssertEqual(wallet.privateKey, privateKey)
//    }
//
//    // TODO: This is the same as above. opts should be rewritten imo
//    func testWalletGenerateDefaultWDerivation() {
//        let opts: MnemonicOptions = MnemonicOptions(
//            masterAddress: nil,
//            derivationPath: DerivationPath(),
//            mnemonicEncoding: nil
//        )
//        let wallet = try! Wallet.fromMnemonic(mnemonic: mnemonic, opts: opts)
//
//        XCTAssertEqual(wallet.publicKey, publicKey)
//        XCTAssertEqual(wallet.privateKey, privateKey)
//    }
//
//    func testWalletGenerateDefaultRFC() {
//        let mnemonic: String = "I IRE BOND BOW TRIO LAID SEAT GOAL HEN IBIS IBIS DARE"
//        let masterAddress: String = "rUAi7pipxGpYfPNg3LtPcf2ApiS8aw9A93"
//        let opts: MnemonicOptions = MnemonicOptions(
//            masterAddress: masterAddress,
//            derivationPath: DerivationPath(),
//            mnemonicEncoding: "rfc1751"
//        )
//        let wallet = try! Wallet.fromMnemonic(mnemonic: mnemonic, opts: opts)
//
//        XCTAssertEqual(wallet.publicKey, publicKey)
//        XCTAssertEqual(wallet.privateKey, privateKey)
//        XCTAssertEqual(wallet.classicAddress, masterAddress)
//    }
//}

final class TestWalletFromEntropy: XCTestCase {
    var entropy: Entropy = Entropy()
    let publicKey: String = "0390A196799EE412284A5D80BF78C3E84CBB80E1437A0AECD9ADF94D7FEAAFA284"
    let privateKey: String = "002512BBDFDBB77510883B7DCCBEF270B86DEAC8B64AC762873D75A1BEE6298665"
    let publicKeyED: String = "ED1A7C082846CFF58FF9A892BA4BA2593151CCF1DBA59F37714CC9ED39824AF85F"
    let privateKeyED: String = "ED0B6CBAC838DFE7F47EA1BD0DF00EC282FDF45510C92161072CCFB84035390C4D"

    override func setUp() async throws {
        entropy = Entropy(bytes: [UInt8].init(repeating: 0, count: 16))
    }

    func testWalletGenerateDefault() {
        let opts: SeedOptions = SeedOptions(
            masterAddress: nil,
            algorithm: .ed25519,
            seed: nil
        )
        let wallet = Wallet.fromEntropy(entropy: entropy, opts: opts)

        XCTAssertEqual(wallet.publicKey, publicKeyED)
        XCTAssertEqual(wallet.privateKey, privateKeyED)
    }

    func testWalletGenerateSECP256K1() {
        let opts: SeedOptions = SeedOptions(
            masterAddress: nil,
            algorithm: .secp256k1,
            seed: nil
        )
        let wallet = Wallet.fromEntropy(entropy: entropy, opts: opts)

        XCTAssertEqual(wallet.publicKey, publicKey)
        XCTAssertEqual(wallet.privateKey, privateKey)
    }

    func testWalletGenerateED25519() {
        let opts: SeedOptions = SeedOptions(
            masterAddress: nil,
            algorithm: .ed25519,
            seed: nil
        )
        let wallet = Wallet.fromEntropy(entropy: entropy, opts: opts)

        XCTAssertEqual(wallet.publicKey, publicKeyED)
        XCTAssertEqual(wallet.privateKey, privateKeyED)
    }

    func testWalletGenerateKeyPair() {
        let masterAddress = "rUAi7pipxGpYfPNg3LtPcf2ApiS8aw9A93"
        let opts: SeedOptions = SeedOptions(
            masterAddress: masterAddress,
            algorithm: .ed25519,
            seed: nil
        )
        let wallet = Wallet.fromEntropy(entropy: entropy, opts: opts)

        XCTAssertEqual(wallet.publicKey, publicKeyED)
        XCTAssertEqual(wallet.privateKey, privateKeyED)
        XCTAssertEqual(wallet.classicAddress, masterAddress)
    }
}

final class TestWalletSign: XCTestCase {
    var wallet: Wallet = Wallet.fromSeed(seed: "ss1x3KLrSvfg7irFc1D929WXZ7z9H")

    func testSign() {
        let dict = RequestFixtures.sign()
        let tx: Transaction = try! Transaction(dict)!
        let result = try! wallet.sign(transaction: tx, multisign: false)
        XCTAssertEqual(result.txBlob, ResponseFixtures.sign()["signedTransaction"] as! String)
        XCTAssertEqual(result.hash, "93F6C6CE73C092AA005103223F3A1F557F4C097A2943D96760F6490F04379917")
    }

    func testSignCaseInsensitive() {
        let seed = "shd2nxpFD6iBRKWsRss2P4tKMWyy9"
        let lowercaseMemoTx: [String: AnyObject] = [
            "TransactionType": "Payment",
            "Flags": 2147483648,
            "Account": "rwiZ3q3D3QuG4Ga2HyGdq3kPKJRGctVG8a",
            "Amount": "10000000",
            "LastLedgerSequence": 14000999,
            "Destination": "rUeEBYXHo8vF86Rqir3zWGRQ84W9efdAQd",
            "Fee": "12",
            "Sequence": 12,
            "SourceTag": 8888,
            "DestinationTag": 9999,
            "Memos": [
                [
                    "Memo": [
                        "MemoType":
                            "687474703a2f2f6578616d706c652e636f6d2f6d656d6f2f67656e65726963",
                        "MemoData": "72656e74"
                    ]
                ]
            ]
        ] as [String: AnyObject]
        let tx: Transaction = try! Transaction(lowercaseMemoTx)!
        let result = try! Wallet.fromSeed(seed: seed).sign(transaction: tx)
        XCTAssertEqual(result.txBlob, "120000228000000023000022B8240000000C2E0000270F201B00D5A36761400000000098968068400000000000000C73210305E09ED602D40AB1AF65646A4007C2DAC17CB6CDACDE301E74FB2D728EA057CF744730450221009C00E8439E017CA622A5A1EE7643E26B4DE9C808DE2ABE45D33479D49A4CEC66022062175BE8733442FA2A4D9A35F85A57D58252AE7B19A66401FE238B36FA28E5A081146C1856D0E36019EA75C56D7E8CBA6E35F9B3F71583147FB49CD110A1C46838788CD12764E3B0F837E0DDF9EA7C1F687474703A2F2F6578616D706C652E636F6D2F6D656D6F2F67656E657269637D0472656E74E1F1")
        XCTAssertEqual(result.hash, "41B9CB78D8E18A796CDD4B0BC6FB0EA19F64C4F25FDE23049197852CAB71D10D")
    }

    func testSignEscrow() {
        let dict = RequestFixtures.signEscrow()
        let tx: Transaction = try! Transaction(dict)!
        let result = try! wallet.sign(transaction: tx)
        XCTAssertEqual(result.txBlob, ResponseFixtures.signEscrow()["signedTransaction"] as! String)
        XCTAssertEqual(result.hash, "645B7676DF057E4F5E83F970A18B3751B6813807F1030A8D2F482D02DC885106")
    }

    func testSignAsMultisign() {
        let dict = RequestFixtures.signAs()
        let tx: Transaction = try! Transaction(dict)!
        let result = try! wallet.sign(transaction: tx, multisign: true)
        XCTAssertEqual(result.txBlob, ResponseFixtures.signAs()["signedTransaction"] as! String)
        XCTAssertEqual(result.hash, "D8CF5FC93CFE5E131A34599AFB7CE186A5B8D1B9F069E35F4634AD3B27837E35")
    }

    //    func testSignAsMultisignXAddressNoTag() {
    //        let dict = RequestFixtures.signAs()
    //        let tx: Transaction = try! Transaction(dict)!
    //        let result = try! wallet.sign(transaction: tx, multisign: wallet.getXAddress())
    //        XCTAssertEqual(result.txBlob, ResponseFixtures.signAs()["signedTransaction"] as! String)
    //        XCTAssertEqual(result.hash, "D8CF5FC93CFE5E131A34599AFB7CE186A5B8D1B9F069E35F4634AD3B27837E35")
    //    }
    //
    //    func testSignAsMultisignXAddress() {
    //        let dict = RequestFixtures.signAs()
    //        let tx: Transaction = try! Transaction(dict)!
    //        let result = try! wallet.sign(transaction: tx, multisign: wallet.getXAddress(0))
    //        XCTAssertEqual(result.txBlob, ResponseFixtures.signAs()["signedTransaction"] as! String)
    //        XCTAssertEqual(result.hash, "D8CF5FC93CFE5E131A34599AFB7CE186A5B8D1B9F069E35F4634AD3B27837E35")
    //    }

    func testInvalidAlreadySigned() {
        let tx: Transaction = try! Transaction(RequestFixtures.sign())!
        let result = try! wallet.sign(transaction: tx, multisign: false)
        let cloneTx: [String: AnyObject] = BinaryCodec.decode(buffer: result.txBlob)
        let nextTx = try! Transaction(cloneTx)
        XCTAssertThrowsError(try wallet.sign(transaction: nextTx!))
    }

    func testSignEscrowExecuted() {
        let dict = RequestFixtures.signEscrow()
        let tx: Transaction = try! Transaction(dict)!
        let result = try! wallet.sign(transaction: tx)
        XCTAssertEqual(result.txBlob, ResponseFixtures.signEscrow()["signedTransaction"] as! String)
        XCTAssertEqual(result.hash, "645B7676DF057E4F5E83F970A18B3751B6813807F1030A8D2F482D02DC885106")
    }

    func testSignNoFlags() {
        let tx: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r45Rev1EXGxy2hAUmJPCne97KUE7qyrD3j",
            "Destination": "rQ3PTWGLCbPz8ZCicV5tCX3xuymojTng5r",
            "Amount": "20000000",
            "Sequence": 1,
            "Fee": "12"
        ] as! [String: AnyObject])!
        let result = try! wallet.sign(transaction: tx)
        let decoded: [String: Any] = BinaryCodec.decode(buffer: result.txBlob)
        XCTAssert(decoded["Flags"] == nil)
        XCTAssertEqual(result.txBlob, "1200002400000001614000000001312D0068400000000000000C732102A8A44DB3D4C73EEEE11DFE54D2029103B776AA8A8D293A91D645977C9DF5F5447446304402201C0A74EE8ECF5ED83734D7171FB65C01D90D67040DEDCC66414BD546CE302B5802205356843841BFFF60D15F5F5F9FB0AB9D66591778140AB2D137FF576D9DEC44BC8114EE3046A5DDF8422C40DDB93F1D522BB4FE6419158314FDB08D07AAA0EB711793A3027304D688E10C3648")
        XCTAssertEqual(result.hash, "E22186AE9FE477821BF361358174C2B0AC2D3289AA6F7E8C1102B3D270C41204")
    }

    func testSignSourceDestMinAmount() {
        let tx: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Destination": "rEX4LtGJubaUcMWCJULcy4NVxGT9ZEMVRq",
            "Amount": [
                "currency": "USD",
                "issuer": "rMaa8VLBTjwTJWA2kSme4Sqgphhr6Lr6FH",
                "value":
                    "999999999999999900000000000000000000000000000000000000000000000000000000000000000000000000000000"
            ],
            "Flags": 2147614720,
            "SendMax": [
                "currency": "GBP",
                "issuer": "rpat5TmYjDsnFSStmgTumFgXCM9eqsWPro",
                "value": "0.1"
            ],
            "DeliverMin": [
                "currency": "USD",
                "issuer": "rMaa8VLBTjwTJWA2kSme4Sqgphhr6Lr6FH",
                "value": "0.1248548562296331"
            ],
            "Sequence": 23,
            "LastLedgerSequence": 8820051,
            "Fee": "12"
        ] as! [String: AnyObject])!
        let result = try! wallet.sign(transaction: tx)
        let decoded: [String: Any] = BinaryCodec.decode(buffer: result.txBlob)
        let flags = (decoded["Flags"] as! xUInt32).str()
        // TODO: Notice how you have to go str -> Int w/ radix
        // Need to review what exactly is supposed to be returned is it the hex, or the value or the object
        XCTAssert(Int(flags, radix: 16) == 2147614720)
        XCTAssertEqual(result.txBlob, "12000022800200002400000017201B0086955361EC6386F26FC0FFFF0000000000000000000000005553440000000000DC596C88BCDE4E818D416FCDEEBF2C8656BADC9A68400000000000000C69D4438D7EA4C6800000000000000000000000000047425000000000000C155FFE99C8C91F67083CEFFDB69EBFE76348CA6AD4446F8C5D8A5E0B0000000000000000000000005553440000000000DC596C88BCDE4E818D416FCDEEBF2C8656BADC9A732102A8A44DB3D4C73EEEE11DFE54D2029103B776AA8A8D293A91D645977C9DF5F544744630440220297E0C7670C7DA491E0D649E62C123D988BA93FD7EA1B9141F1D376CDDF902F502205AF1936B22B18BBA7793A88ABEEABADB4CE0E4C3BE583066480F2F476B5ED08E81145E7B112523F68D2F5E879DB4EAC51C6698A6930483149F500E50C2F016CA01945E5A1E5846B61EF2D376")
        XCTAssertEqual(result.hash, "FB2813E9E673EF56609070A4BA9640FAD0508DA567320AE9D92FB5A356A03D84")
    }

    func testSignInvalidSmallFee() {
        let tx: Transaction = try! Transaction([
            "Flags": 2147483648,
            "TransactionType": "AccountSet",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Domain": "6578616D706C652E636F6D",
            "LastLedgerSequence": 8820051,
            "Fee": "1.2",
            "Sequence": 23,
            "SigningPubKey": "02F89EAEC7667B30F33D0687BBA86C3FE2A08CCA40A9186C5BDE2DAA6FA97A37D8"
        ] as! [String: AnyObject])!
        XCTAssertThrowsError(try wallet.sign(transaction: tx))
    }

    func testSignInvalidHighFee() {
        let tx: Transaction = try! Transaction([
            "Flags": 2147483648,
            "TransactionType": "AccountSet",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Domain": "6578616D706C652E636F6D",
            "LastLedgerSequence": 8820051,
            "Fee": "1123456.7",
            "Sequence": 23,
            "SigningPubKey": "02F89EAEC7667B30F33D0687BBA86C3FE2A08CCA40A9186C5BDE2DAA6FA97A37D8"
        ] as! [String: AnyObject])!
        XCTAssertThrowsError(try wallet.sign(transaction: tx))
    }

    func testSignTicket() {
        let dict = RequestFixtures.signTicket()
        let tx: Transaction = try! Transaction(dict)!
        let result = try! wallet.sign(transaction: tx)
        XCTAssertEqual(result.txBlob, ResponseFixtures.signTicket()["signedTransaction"] as! String)
        XCTAssertEqual(result.hash, "0AC60B1E1F063904D9D9D0E9D03F2E9C8D41BC6FC872D5B8BF87E15BBF9669BB")
    }

    func testSignWPaths() {
        let tx: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Destination": "rKT4JX4cCof6LcDYRz8o3rGRu7qxzZ2Zwj",
            "Amount": [
                "currency": "USD",
                "issuer": "rVnYNK9yuxBz4uP8zC8LEFokM2nqH3poc",
                "value":
                    "999999999999999900000000000000000000000000000000000000000000000000000000000000000000000000000000"
            ],
            "Flags": 2147614720,
            "SendMax": "100",
            "DeliverMin": [
                "currency": "USD",
                "issuer": "rVnYNK9yuxBz4uP8zC8LEFokM2nqH3poc",
                "value": "0.00004579644712312366"
            ],
            "Paths": [
                [[ "currency": "USD", "issuer": "rVnYNK9yuxBz4uP8zC8LEFokM2nqH3poc" ]]
            ],
            "LastLedgerSequence": 15696358,
            "Sequence": 1,
            "Fee": "12"
        ] as! [String: AnyObject])!
        let result = try! wallet.sign(transaction: tx)
        XCTAssertEqual(result.txBlob, "12000022800200002400000001201B00EF81E661EC6386F26FC0FFFF0000000000000000000000005553440000000000054F6F784A58F9EFB0A9EB90B83464F9D166461968400000000000000C6940000000000000646AD3504529A0465E2E0000000000000000000000005553440000000000054F6F784A58F9EFB0A9EB90B83464F9D1664619732102A8A44DB3D4C73EEEE11DFE54D2029103B776AA8A8D293A91D645977C9DF5F54474463044022049AD75980A5088EBCD768547E06427736BD8C4396B9BD3762CA8C1341BD7A4F9022060C94071C3BDF99FAB4BEB7C0578D6EBEE083157B470699645CCE4738A41D61081145E7B112523F68D2F5E879DB4EAC51C6698A693048314CA6EDC7A28252DAEA6F2045B24F4D7C333E146170112300000000000000000000000005553440000000000054F6F784A58F9EFB0A9EB90B83464F9D166461900")
        XCTAssertEqual(result.hash, "71D0B4AA13277B32E2C2E751566BB0106764881B0CAA049905A0EDAC73257745")
    }

    func testSignPreparedPayment() {
        let tx: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Destination": "rQ3PTWGLCbPz8ZCicV5tCX3xuymojTng5r",
            "Amount": "1",
            "Flags": 2147483648,
            "Sequence": 23,
            "LastLedgerSequence": 8819954,
            "Fee": "12"
        ] as! [String: AnyObject])!
        let result = try! wallet.sign(transaction: tx)
        XCTAssertEqual(result.txBlob, "12000022800000002400000017201B008694F261400000000000000168400000000000000C732102A8A44DB3D4C73EEEE11DFE54D2029103B776AA8A8D293A91D645977C9DF5F54474473045022100E8929B68B137AB2AAB1AD3A4BB253883B0C8C318DC8BB39579375751B8E54AC502206893B2D61244AFE777DAC9FA3D9DDAC7780A9810AF4B322D629784FD626B8CE481145E7B112523F68D2F5E879DB4EAC51C6698A693048314FDB08D07AAA0EB711793A3027304D688E10C3648")
        XCTAssertEqual(result.hash, "AA1D2BDC59E504AA6C2416E864C615FB18042C1AB4457BEB883F7194D8C452B5")
    }

    func testSignInvalidAmount() {
        let tx: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Destination": "rQ3PTWGLCbPz8ZCicV5tCX3xuymojTng5r",
            "Amount": "1.1234567",
            "Flags": 2147483648,
            "Sequence": 23,
            "LastLedgerSequence": 8819954,
            "Fee": "12"
        ] as! [String: AnyObject])!
        XCTAssertThrowsError(try wallet.sign(transaction: tx))
    }

    func testSignICLowercase() {
        let icTx: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Destination": "rQ3PTWGLCbPz8ZCicV5tCX3xuymojTng5r",
            "Amount": [
                "currency": "foo",
                "issuer": "rnURbz5HLbvqEq69b1B4TX6cUTNMmcrBqi",
                "value": "123.40"
            ],
            "Flags": 2147483648,
            "Sequence": 23,
            "LastLedgerSequence": 8819954,
            "Fee": "12"
        ] as! [String: AnyObject])!
        let result = try! wallet.sign(transaction: icTx)
        XCTAssertEqual(result.txBlob, "12000022800000002400000017201B008694F261D504625103A72000000000000000000000000000666F6F00000000002E099DD75FDD96EB4A603037844F964832FED86B68400000000000000C732102A8A44DB3D4C73EEEE11DFE54D2029103B776AA8A8D293A91D645977C9DF5F54474473045022100D32EBD44F86FB6D0BE239A410B62A73A8B0C26CE3767321913D6FB7BE6FAC2410220430C011C25091DA9CD75E7C99BE406572FBB57B92132E39B4BF873863E744E2E81145E7B112523F68D2F5E879DB4EAC51C6698A693048314FDB08D07AAA0EB711793A3027304D688E10C3648")
        XCTAssertEqual(result.hash, "F822EA1D7B2A3026E4654A9152896652C3843B5690F8A56C4217CB4690C5C95A")
    }

    func testSignOrHex() {
        let icTx: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Destination": "rQ3PTWGLCbPz8ZCicV5tCX3xuymojTng5r",
            "Amount": [
                "currency": "***",
                "issuer": "rnURbz5HLbvqEq69b1B4TX6cUTNMmcrBqi",
                "value": "123.40"
            ],
            "Flags": 2147483648,
            "Sequence": 23,
            "LastLedgerSequence": 8819954,
            "Fee": "12"
        ] as! [String: AnyObject])!
        let result = try! wallet.sign(transaction: icTx)

        let icTx2: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Destination": "rQ3PTWGLCbPz8ZCicV5tCX3xuymojTng5r",
            "Amount": [
                "currency": "0000000000000000000000002A2A2A0000000000",
                "issuer": "rnURbz5HLbvqEq69b1B4TX6cUTNMmcrBqi",
                "value": "123.40"
            ],
            "Flags": 2147483648,
            "Sequence": 23,
            "LastLedgerSequence": 8819954,
            "Fee": "12"
        ] as! [String: AnyObject])!
        let result2 = try! wallet.sign(transaction: icTx2)
        XCTAssertEqual(result.txBlob, result2.txBlob)
        XCTAssertEqual(result.hash, result2.hash)
    }

    func testSignInvalidISOXRP() {
        let tx: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Destination": "rQ3PTWGLCbPz8ZCicV5tCX3xuymojTng5r",
            "Amount": [
                "currency": "XRP",
                "issuer": "rnURbz5HLbvqEq69b1B4TX6cUTNMmcrBqi",
                "value": "123.40"
            ],
            "Flags": 2147483648,
            "Sequence": 23,
            "LastLedgerSequence": 8819954,
            "Fee": "12"
        ] as! [String: AnyObject])!
        XCTAssertThrowsError(try wallet.sign(transaction: tx))
    }

    func testSignValidISOXRPHex() {
        let tx: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Destination": "rQ3PTWGLCbPz8ZCicV5tCX3xuymojTng5r",
            "Amount": [
                "currency": "0000000000000000000000007872700000000000",
                "issuer": "rnURbz5HLbvqEq69b1B4TX6cUTNMmcrBqi",
                "value": "123.40"
            ],
            "Flags": 2147483648,
            "Sequence": 23,
            "LastLedgerSequence": 8819954,
            "Fee": "12"
        ] as! [String: AnyObject])!
        let result = try! wallet.sign(transaction: tx)
        XCTAssertEqual(result.txBlob, "12000022800000002400000017201B008694F261D504625103A7200000000000000000000000000078727000000000002E099DD75FDD96EB4A603037844F964832FED86B68400000000000000C732102A8A44DB3D4C73EEEE11DFE54D2029103B776AA8A8D293A91D645977C9DF5F5447446304402202CD2BE27480860765B1B8DB6C499D299734C533F4FFA66317E46D1ADE5181EB7022066D2C65B975A6A9FEE56AB55211D5F2F65D6F988C8280019211874D11771A05D81145E7B112523F68D2F5E879DB4EAC51C6698A693048314FDB08D07AAA0EB711793A3027304D688E10C3648")
        XCTAssertEqual(result.hash, "1FEAA7894E507E36D73F60DED89852CE28994366879BC7D3D806E4C50D10B1EE")
    }

    func testSignValidISOSymbols() {
        let tx: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Destination": "rQ3PTWGLCbPz8ZCicV5tCX3xuymojTng5r",
            "Amount": [
                "currency": "***",
                "issuer": "rnURbz5HLbvqEq69b1B4TX6cUTNMmcrBqi",
                "value": "123.40"
            ],
            "Flags": 2147483648,
            "Sequence": 23,
            "LastLedgerSequence": 8819954,
            "Fee": "12"
        ] as! [String: AnyObject])!
        let result = try! wallet.sign(transaction: tx)
        XCTAssertEqual(result.txBlob, "12000022800000002400000017201B008694F261D504625103A720000000000000000000000000002A2A2A00000000002E099DD75FDD96EB4A603037844F964832FED86B68400000000000000C732102A8A44DB3D4C73EEEE11DFE54D2029103B776AA8A8D293A91D645977C9DF5F54474463044022073E71588750C3D47D7D9A541F00FB897823DA67ED198D0A74404B6FE6D5E4AB5022021BE798D4159F375EBE13D0545F50EE864DF834D5A9F9A31504212156A57934C81145E7B112523F68D2F5E879DB4EAC51C6698A693048314FDB08D07AAA0EB711793A3027304D688E10C3648")
        XCTAssertEqual(result.hash, "95BF9931C1EA164960FE13A504D5FBAEB1E072C1D291D75B85BA3F22A50346DF")
    }

    func testSignValidISONonStandard() {
        let tx: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Destination": "rQ3PTWGLCbPz8ZCicV5tCX3xuymojTng5r",
            "Amount": [
                "currency": ":::",
                "issuer": "rnURbz5HLbvqEq69b1B4TX6cUTNMmcrBqi",
                "value": "123.40"
            ],
            "Flags": 2147483648,
            "Sequence": 23,
            "LastLedgerSequence": 8819954,
            "Fee": "12"
        ] as! [String: AnyObject])!
        let result = try! wallet.sign(transaction: tx)
        XCTAssertEqual(result.txBlob, "12000022800000002400000017201B008694F261D504625103A720000000000000000000000000002A2A2A00000000002E099DD75FDD96EB4A603037844F964832FED86B68400000000000000C732102A8A44DB3D4C73EEEE11DFE54D2029103B776AA8A8D293A91D645977C9DF5F54474463044022073E71588750C3D47D7D9A541F00FB897823DA67ED198D0A74404B6FE6D5E4AB5022021BE798D4159F375EBE13D0545F50EE864DF834D5A9F9A31504212156A57934C81145E7B112523F68D2F5E879DB4EAC51C6698A693048314FDB08D07AAA0EB711793A3027304D688E10C3648")
        XCTAssertEqual(result.hash, "95BF9931C1EA164960FE13A504D5FBAEB1E072C1D291D75B85BA3F22A50346DF")
    }

    func testSignValidXRPTrailingZero() {
        let tx: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Destination": "rQ3PTWGLCbPz8ZCicV5tCX3xuymojTng5r",
            "Amount": [
                "currency": "FOO",
                "issuer": "rnURbz5HLbvqEq69b1B4TX6cUTNMmcrBqi",
                "value": "123.40"
            ],
            "Flags": 2147483648,
            "Sequence": 23,
            "LastLedgerSequence": 8819954,
            "Fee": "12"
        ] as! [String: AnyObject])!
        let result = try! wallet.sign(transaction: tx)
        XCTAssertEqual(result.txBlob, "12000022800000002400000017201B008694F261D504625103A72000000000000000000000000000464F4F00000000002E099DD75FDD96EB4A603037844F964832FED86B68400000000000000C732102A8A44DB3D4C73EEEE11DFE54D2029103B776AA8A8D293A91D645977C9DF5F5447446304402206EBFC9B8061C3F82D521506CE62B6BBA99995B2175BFE0E1BC516775932AECEB0220172B9CE9C0EFB3F4870E19B79B4E817DD376E5785F034AB792708F92282C65F781145E7B112523F68D2F5E879DB4EAC51C6698A693048314FDB08D07AAA0EB711793A3027304D688E10C3648")
        XCTAssertEqual(result.hash, "6235E5A3CC14DB97F75CAE2A4B5AA9B4134B7AD48D7DD8C15473D81631435FE4")
    }

    func testSignValidXRPTrailingZeros() {
        let tx: Transaction = try! Transaction([
            "TransactionType": "Payment",
            "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
            "Destination": "rQ3PTWGLCbPz8ZCicV5tCX3xuymojTng5r",
            "Amount": [
                "currency": "FOO",
                "issuer": "rnURbz5HLbvqEq69b1B4TX6cUTNMmcrBqi",
                "value": "123.000"
            ],
            "Flags": 2147483648,
            "Sequence": 23,
            "LastLedgerSequence": 8819954,
            "Fee": "12"
        ] as! [String: AnyObject])!
        let result = try! wallet.sign(transaction: tx)
        XCTAssertEqual(result.txBlob, "12000022800000002400000017201B008694F261D5045EADB112E000000000000000000000000000464F4F00000000002E099DD75FDD96EB4A603037844F964832FED86B68400000000000000C732102A8A44DB3D4C73EEEE11DFE54D2029103B776AA8A8D293A91D645977C9DF5F54474473045022100C0C77D7D6D6453F0C5EDFF61DE60B5D3D6952C8F30D51543560936D72FA103B00220258CBFCEAC4D2DB5CC2B9417EB46225943E9F4B92944B303ADB810002530BFFB81145E7B112523F68D2F5E879DB4EAC51C6698A693048314FDB08D07AAA0EB711793A3027304D688E10C3648")
        XCTAssertEqual(result.hash, "FADCD5EE33C01103AA129FCF0923637D543DB56250CD57A1A308EC386A211CBB")
    }

    func testSignValidLowerHexURI() {
        let tx: Transaction = try! Transaction([
            "TransactionType": "NFTokenMint",
            "Account": wallet.address(),
            "TransferFee": 314,
            "NFTokenTaxon": 0,
            "Flags": 8,
            "Fee": "10",
            "URI": "697066733a2f2f62616679626569676479727a74357366703775646d37687537367568377932366e6634646675796c71616266336f636c67747179353566627a6469",
            "Memos": [
              [
                "Memo": [
                  "MemoType":
                    "687474703a2f2f6578616d706c652e636f6d2f6d656d6f2f67656e65726963",
                  "MemoData": "72656e74"
                ]
              ]
            ]
        ] as! [String: AnyObject])!
        let result = try! wallet.sign(transaction: tx)
        XCTAssertEqual(result.txBlob, "12001914013A2200000008202A0000000068400000000000000A732102A8A44DB3D4C73EEEE11DFE54D2029103B776AA8A8D293A91D645977C9DF5F5447446304402203795B6E9D6D0086FB26E2C6B7A8C02D50B8560D45C9D5C80DF271D3349515E5302203B0898A7D8C06243D7C2116D2011ACB68DF3123BB7336D6C27269FD388C12CC07542697066733A2F2F62616679626569676479727A74357366703775646D37687537367568377932366E6634646675796C71616266336F636C67747179353566627A64698114B3263BD0A9BF9DFDBBBBD07F536355FF477BF0E9F9EA7C1F687474703A2F2F6578616D706C652E636F6D2F6D656D6F2F67656E657269637D0472656E74E1F1")
        XCTAssertEqual(result.hash, "2F359B3CFD1CE6D7BFB672F8ADCE98FE964B1FD04CFC337177FB3D8FBE889788")
    }

    func testSignInvalidURI() {
        let tx: Transaction = try! Transaction([
            "TransactionType": "NFTokenMint",
            "Account": wallet.address(),
            "TransferFee": 314,
            "NFTokenTaxon": 0,
            "Flags": 8,
            "Fee": "10",
            "URI": "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf4dfuylqabf3oclgtqy55fbzdi",
            "Memos": [
              [
                "Memo": [
                  "MemoType":
                    "687474703a2f2f6578616d706c652e636f6d2f6d656d6f2f67656e65726963",
                  "MemoData": "72656e74"
                ]
              ]
            ]
        ] as! [String: AnyObject])!
        XCTAssertThrowsError(try wallet.sign(transaction: tx))
    }
}

final class TestWalletVerify: XCTestCase {
    let publicKey: String =
          "030E58CDD076E798C84755590AAF6237CA8FAE821070A59F648B517A30DC6F589D"
    let privateKey: String =
          "00141BA006D3363D2FB2785E8DF4E44D3A49908780CB4FB51F6D217C08C021429F"
    let preparedSigned: String = "1200002400000001614000000001312D0068400000000000000C7321030E58CDD076E798C84755590AAF6237CA8FAE821070A59F648B517A30DC6F589D74473045022100CAF99A63B241F5F62B456C68A593D2835397101533BB5D0C4DC17362AC22046F022016A2CA2CF56E777B10E43B56541A4C2FB553E7E298CDD39F7A8A844DA491E51D81142AF1861DEC1316AEEC995C94FF9E2165B1B784608314FDB08D07AAA0EB711793A3027304D688E10C3648"
    let preparedID: String = "30D9ECA2A7FB568C5A8607E5850D9567572A9E7C6094C26BEFD4DC4C2CF2657A"

    func testVerifyTrue() {
        let wallet = Wallet(publicKey: publicKey, privateKey: privateKey)
        let isVerified: Bool = wallet.verifyTransaction(
            signedTransaction: preparedSigned
        )
        XCTAssertEqual(isVerified, true)
    }

    func testVerifyFalse() {
        let diffPublicKey: String =
              "030E58CDD076E798C84755590AAF6237CA8FAE821070A59F648B517A30DC6F589D"
        let diffPrivateKey: String =
              "00141BA006D3363D2FB2785E8DF4E44D3A49908780CB4FB51F6D217C08C021429F"
        let wallet = Wallet(publicKey: diffPublicKey, privateKey: diffPrivateKey)
        let isVerified: Bool = wallet.verifyTransaction(
            signedTransaction: preparedSigned
        )
        XCTAssertEqual(isVerified, true)
    }
}

// final class TestWalletGetXAddress: XCTestCase {
//    let publicKey: String = "030E58CDD076E798C84755590AAF6237CA8FAE821070A59F648B517A30DC6F589D"
//    let privateKey: String = "00141BA006D3363D2FB2785E8DF4E44D3A49908780CB4FB51F6D217C08C021429F"
//    let tag: Int = 1337
//    let mainnetXAddress: String = "X7gJ5YK8abHf2eTPWPFHAAot8Knck11QGqmQ7a6a3Z8PJvk"
//    let testnetXAddress: String = "T7bq3e7kxYq9pwDz8UZhqAZoEkcRGTXSNr5immvcj3DYRaV"
//    
//    func testTestTrue() {
//        let wallet: Wallet = Wallet(publicKey: publicKey, privateKey: privateKey)
//        let result = wallet.getXAddress(tag, true)
//        XCTAssertEqual(result, testnetXAddress)
//    }
//    
//    func testTestFalse() {
//        let wallet: Wallet = Wallet(publicKey: publicKey, privateKey: privateKey)
//        let result = wallet.getXAddress(tag, false)
//        XCTAssertEqual(result, mainnetXAddress)
//    }
//    
//    func testTestNA() {
//        let wallet: Wallet = Wallet(publicKey: publicKey, privateKey: privateKey)
//        let result = wallet.getXAddress(tag)
//        XCTAssertEqual(result, mainnetXAddress)
//    }
// }
