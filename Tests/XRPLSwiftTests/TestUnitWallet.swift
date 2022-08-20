////
////  TestUnitWallet.swift
////
////
////  Created by Denis Angell on 3/20/22.
////
//
// import XCTest
// @testable import XRPLSwift
//
// final class TestUnitWallet: XCTestCase {
//
//    func testEncodeChannel() {
//        let params: [String: Any] = [
//            "amount": ReusableValues.amount,
//            "channel": ReusableValues.channelHex,
//        ]
//        guard let encode = try? ReusableValues.wallet.encodeClaim(dict: params) else {
//            XCTFail("Should generate encode")
//            return
//        }
//        XCTAssert(encode.toHexString().uppercased() == "434C4D00931E6B6C278DB7AC0A61CD92AEA5373E8DF59E5836E6D0D1ECAA53D38C3C4E1E00000000000F4240")
//        let signature = ReusableValues.wallet.sign(message: encode)
//        XCTAssert(signature.toHexString().uppercased() == "BE32A4C68D6BA4787264EEE760DEFFB4F05ADAC999BAF3AC63F4E9F542DF07FAE783FD707071879774A022E87A6A8849B666B6DDAA22361785224D36B7CBC406")
//    }
//
//    func testDecodeChannelHash() {
//        let channelHashBytes: [UInt8] = SeedWallet.getBytes(
//            bytes: ReusableValues.channelSigBytes,
//            start: 0,
//            end: 3
//        )
//        XCTAssert(channelHashBytes == [0x43, 0x4C, 0x4D, 0x00])
//    }
//
//    func testDecodeChannelHex() {
//        let channelAmountBytes: [UInt8] = SeedWallet.getBytes(
//            bytes: ReusableValues.channelSigBytes,
//            start: 4,
//            end: 35
//        )
//        XCTAssert(channelAmountBytes == [147, 30, 107, 108, 39, 141, 183, 172, 10, 97, 205, 146, 174, 165, 55, 62, 141, 245, 158, 88, 54, 230, 208, 209, 236, 170, 83, 211, 140, 60, 78, 30])
//    }
//
//    func testDecodeChannelAmount() {
//        let channelAmountBytes: [UInt8] = SeedWallet.getBytes(
//            bytes: ReusableValues.channelSigBytes,
//            start: 36,
//            end: ReusableValues.channelSigBytes.count - 1
//        )
//        XCTAssert(channelAmountBytes == [0, 0, 0, 0, 0, 15, 66, 64])
//    }
//
//    func testSigBytes() {
//        let channelSig = ChannelSignature(
//            pubKey: "",
//            sigHex: ReusableValues.channelSigHex,
//            dataHex: ReusableValues.channelDataHex
//        )
//        XCTAssert(channelSig.sigHex == ReusableValues.channelSigHex)
//        XCTAssert(channelSig.sigBytes == ReusableValues.channelSigBytes)
//        XCTAssert(channelSig.dataHex == ReusableValues.channelDataHex)
//        XCTAssert(channelSig.dataBytes == ReusableValues.channelDataBytes)
//    }
//
//    func testSigAmount() {
//        let amountBytes: [UInt8] = [0, 0, 0, 0, 0, 15, 66, 64]
//        let amountInt: Int64 = amountBytes.reversed().withUnsafeBytes { $0.load(as: Int64.self) }
//        XCTAssert(amountInt == ReusableValues.drops)
//    }
//
//    func testDecodeChannel() {
//        let channelSig = ChannelSignature(
//            pubKey: "",
//            sigHex: ReusableValues.channelSigHex,
//            dataHex: ReusableValues.channelDataHex
//        )
//        guard let channelClaim = try? ReusableValues.wallet.decodeClaim(data: channelSig.dataBytes) else {
//            XCTFail("Should generate decode")
//            return
//        }
//        XCTAssert(channelClaim.amount == 1000000)
//        XCTAssert(channelClaim.channel == "931E6B6C278DB7AC0A61CD92AEA5373E8DF59E5836E6D0D1ECAA53D38C3C4E1E")
//    }
//
//    func testValidateChannelSig() {
//        let channelSig = ChannelSignature(
//            pubKey: ReusableValues.channelPubkey,
//            sigHex: ReusableValues.channelSigHex,
//            dataHex: ReusableValues.channelDataHex
//        )
//        let verified = SeedWallet.verifyClaim(channelSig: channelSig)
//        XCTAssert(verified == true)
//    }
//
//    func testSome() {
////        let string: String = "ipfs://ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz09876543210987654321ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0987654321"
////        let hex: String = "697066733A2F2F4142434445464748494A4B4C4D4E4F505152535455565758595A6162636465666768696A6B6C6D6E6F707172737475767778797A4142434445464748494A4B4C4D4E4F505152535455565758595A6162636465666768696A6B6C6D6E6F707172737475767778797A30393837363534333231303938373635343332314142434445464748494A4B4C4D4E4F505152535455565758595A6162636465666768696A6B6C6D6E6F707172737475767778797A30393837363534333231"
////        let data: [UInt8] = try! hex.asHexArray()
////        print(data)
////        let bytes: [UInt8] = [0x69, 0x70, 0x66, 0x73, 0x3A, 0x2F, 0x2F]
////        print(bytes)
////        let verified = SeedWallet.verifyClaim(channelSig: channelSig)
////        XCTAssert(verified == true)
//
//        let hex1: String = "00090000E3E2649FB84DFB055036605B49DE305618BA72972DCBAB9D00000002"
//        let data1: [UInt8] = try! hex1.asHexArray()
//        print(data1)
//    }
// }
