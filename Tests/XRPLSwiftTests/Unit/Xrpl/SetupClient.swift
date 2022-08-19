//
//  SetupClient.swift
//  
//
//  Created by Denis Angell on 8/18/22.
//

import XCTest
@testable import XRPLSwift


public class RippledMockTester: XCTestCase {
    internal var mockRippled: MockRippledSocket!
    public var _mockedServerPort: Int = 0
    public var client: XrplClient!
    
    public override func setUp() async throws {
        self.mockRippled = MockRippledSocket(port: 9999)
        self.mockRippled.start()
        self._mockedServerPort = 9999
//        self.client = try! XrplClient(server: "ws://localhost:\(9999)")
        self.client = try! XrplClient(server: "localhost")
        try! await self.client.connect().whenSuccess { result in
            print(result)
        }
    }
}
