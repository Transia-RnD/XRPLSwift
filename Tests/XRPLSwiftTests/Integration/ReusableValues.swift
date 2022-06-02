import XCTest
@testable import XRPLSwift

final class ReusableValues: XCTestCase {
    public static var wallet: SeedWallet = try! SeedWallet(seed: "sEdVLSxBzx6Xi9XTqYj6a88epDSETKR")
    public static var destWallet: SeedWallet = try! SeedWallet(seed: "sEdVWZmeUDgQdMEFKTK9kYVX71FKB7o")
    public static var destination: Address = try! Address(rAddress: destWallet.address)
    public static var channelHex: String = "931E6B6C278DB7AC0A61CD92AEA5373E8DF59E5836E6D0D1ECAA53D38C3C4E1E"
    public static var channelPubkey: String = "EDA9E05E0C81D9EB1D346F8FD44D973BE3956757614731610CB6D8EC774C8D2A09"
    public static var channelDataHex: String = "434C4D00931E6B6C278DB7AC0A61CD92AEA5373E8DF59E5836E6D0D1ECAA53D38C3C4E1E00000000000F4240"
    public static var channelDataBytes: [UInt8] = [67, 76, 77, 0, 147, 30, 107, 108, 39, 141, 183, 172, 10, 97, 205, 146, 174, 165, 55, 62, 141, 245, 158, 88, 54, 230, 208, 209, 236, 170, 83, 211, 140, 60, 78, 30, 0, 0, 0, 0, 0, 15, 66, 64]
    public static var channelSigHex: String = "BE32A4C68D6BA4787264EEE760DEFFB4F05ADAC999BAF3AC63F4E9F542DF07FAE783FD707071879774A022E87A6A8849B666B6DDAA22361785224D36B7CBC406"
    public static var channelSigBytes: [UInt8] = [190, 50, 164, 198, 141, 107, 164, 120, 114, 100, 238, 231, 96, 222, 255, 180, 240, 90, 218, 201, 153, 186, 243, 172, 99, 244, 233, 245, 66, 223, 7, 250, 231, 131, 253, 112, 112, 113, 135, 151, 116, 160, 34, 232, 122, 106, 136, 73, 182, 102, 182, 221, 170, 34, 54, 23, 133, 34, 77, 54, 183, 203, 196, 6]
    public static var drops: UInt64 = 1000000
    public static var amount = try! Amount(drops: 1000000) // 1.0 XRP
}
