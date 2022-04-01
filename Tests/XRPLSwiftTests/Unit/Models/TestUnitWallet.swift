//
//  TestUnitWallet.swift
//
//
//  Created by Denis Angell on 3/20/22.
//

import XCTest
@testable import XRPLSwift

final class TestUnitWallet: XCTestCase {
    
    func testEncodeChannel() {
        let params: [String: Any] = [
            "amount": ReusableValues.amount,
            "channel": ReusableValues.channelHex,
        ]
        guard let encode = try? ReusableValues.wallet.encodeClaim(dict: params) else {
            XCTFail("Should generate encode")
            return
        }
        XCTAssert(encode.toHexString().uppercased() == "434C4D00931E6B6C278DB7AC0A61CD92AEA5373E8DF59E5836E6D0D1ECAA53D38C3C4E1E00000000000F4240")
        let signature = ReusableValues.wallet.sign(message: encode)
        XCTAssert(signature.toHexString().uppercased() == "BE32A4C68D6BA4787264EEE760DEFFB4F05ADAC999BAF3AC63F4E9F542DF07FAE783FD707071879774A022E87A6A8849B666B6DDAA22361785224D36B7CBC406")
    }
}
