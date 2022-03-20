import XCTest
@testable import XRPKit

final class ReusableValues: XCTestCase {
    public static var wallet: XRPSeedWallet = try! XRPSeedWallet(seed: "sEdVLSxBzx6Xi9XTqYj6a88epDSETKR")
    public static var destination: XRPAddress = try! XRPAddress(rAddress: "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn")
}
