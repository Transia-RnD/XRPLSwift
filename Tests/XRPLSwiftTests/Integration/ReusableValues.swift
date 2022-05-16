import XCTest
@testable import XRPLSwift

final class ReusableValues: XCTestCase {
    public static var wallet: SeedWallet = try! SeedWallet(seed: "sEdVLSxBzx6Xi9XTqYj6a88epDSETKR")
    public static var destWallet: SeedWallet = try! SeedWallet(seed: "sEdVWZmeUDgQdMEFKTK9kYVX71FKB7o")
    public static var destination: Address = try! Address(rAddress: destWallet.address)
    public static var channelHex: String = "931E6B6C278DB7AC0A61CD92AEA5373E8DF59E5836E6D0D1ECAA53D38C3C4E1E"
    public static var channelPubkey: String = "EDA9E05E0C81D9EB1D346F8FD44D973BE3956757614731610CB6D8EC774C8D2A09"
    public static var channelSig: String = "BE32A4C68D6BA4787264EEE760DEFFB4F05ADAC999BAF3AC63F4E9F542DF07FAE783FD707071879774A022E87A6A8849B666B6DDAA22361785224D36B7CBC406"
    public static var amount = try! Amount(drops: 1000000) // 1.0 XRP
}
