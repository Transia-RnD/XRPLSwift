//
//  TestConnection.swift
//
//
//  Created by Denis Angell on 7/28/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/connection.ts

import XCTest
@testable import XRPLSwift

final class TestConnection: RippledMockTester {

    override func setUp() async throws {
        try await super.setUp()
    }

    func testValidConnection() {
        let connection: Connection = Connection(url: "url")
        XCTAssertEqual(connection.getUrl(), "url")
        XCTAssert(connection.config.proxy == nil)
        XCTAssert(connection.config.authorization == nil)
    }

    func testMultipleDisconnect() async {
        _ = await self.client.disconnect()
        _ = await self.client.disconnect()
    }

    func testReconnect() async {
        _ = try! await self.client.connection.reconnect()
    }

    func testNotConnected() async {
        let exp = expectation(description: "WSS CALL")
        let connection = Connection(url: "url")
        let request: BaseRequest = try! BaseRequest([
            "command": "ledger",
            "ledger_index": "validated"
        ] as! [String: AnyObject])
        do {
            _ = try await connection.request(request: request)
            XCTFail()
        } catch {
            XCTAssertTrue(error is NotConnectedError)
            exp.fulfill()
        }
        await waitForExpectations(timeout: 1)
    }

    func testDisconnected() async {
        let exp = expectation(description: "WSS CALL")
        let request: BaseRequest = try! BaseRequest([
            "command": "test_command",
            "data": [
                "closeServer": true
            ]
        ] as! [String: AnyObject])
        do {
            let response = try await self.client.request(req: request)
            response?.whenFailure { error in
                XCTAssertTrue(error is DisconnectedError)
                exp.fulfill()
            }
            response?.whenSuccess { _ in
                XCTFail()
            }
        } catch {
            print(error.localizedDescription)
            XCTFail()
        }
        await waitForExpectations(timeout: 5)
    }

//    func testDisconnectedOnOpen() async {
//        let exp = expectation(description: "WSS CALL")
//        let request: BaseRequest = try! BaseRequest(json: [
//            "command": "test_command",
//            "data": [
//                "closeServer": true
//            ],
//        ] as! [String: AnyObject])
//        do {
//            let response = try await self.client.request(req: request)
//            response?.whenFailure { error in
//                XCTAssertTrue(error is DisconnectedError)
//                exp.fulfill()
//            }
//            response?.whenSuccess { error in
//                XCTFail()
//            }
//        } catch {
//            XCTFail()
//        }
//        await waitForExpectations(timeout: 1)
//    }

    func testResponseFormatError() async {
        let exp = expectation(description: "WSS CALL")
        let request: BaseRequest = try! BaseRequest([
            "command": "test_command",
            "data": [
                "unrecognizedResponse": true
            ]
        ] as! [String: AnyObject])
        do {
            let response = try await self.client.request(req: request)
            response?.whenFailure { error in
                XCTAssertTrue(error is ResponseFormatError)
                exp.fulfill()
            }
            response?.whenSuccess { _ in
                XCTFail()
            }
        } catch {
            XCTFail()
        }
        await waitForExpectations(timeout: 1)
    }

    func testReconnectUnecpectedClose() async {
        let exp = expectation(description: "WSS CALL")
        let request: BaseRequest = try! BaseRequest([
            "command": "test_command",
            "data": [
                "unrecognizedResponse": true
            ]
        ] as! [String: AnyObject])
        do {
            let response = try await self.client.request(req: request)
            response?.whenFailure { error in
                XCTAssertTrue(error is ResponseFormatError)
                exp.fulfill()
            }
            response?.whenSuccess { _ in
                XCTFail()
            }
        } catch {
            XCTFail()
        }
        await waitForExpectations(timeout: 1)
    }
}

final class TestTrace: XCTestCase {

    var mockedRequestData: [String: AnyObject] = [:]
    var mockedResponse: String = ""
    var expectedMessages: [[String]] = []
    let originalConsoleLog: String = ""

    override func setUp() async throws {
        self.mockedRequestData = ["mocked": "request"] as! [String: AnyObject]
        self.mockedResponse = jsonToString(["mocked": "response", "id": 0] as! [String: AnyObject])

        self.mockedRequestData["id"] = 0 as AnyObject
        // We add the ID here, since it's not a part of the user-provided request.
        self.expectedMessages = [
            ["send", jsonToString(mockedRequestData)],
            ["receive", mockedResponse]
        ]
    }

    override func tearDown() {
        //        teardownClient()
    }

    func testValidConnection() {
        let connection: Connection = Connection(url: "url")
        XCTAssertEqual(connection.getUrl(), "url")
        XCTAssert(connection.config.proxy == nil)
        XCTAssert(connection.config.authorization == nil)
    }

    func _testAsFalse() async {
        let messages: [[String: AnyObject]] = []
        //        console.log = function (id: number, message: string): void {
        //            messages.push([id, message])
        //        }
        let opts: ConnectionUserOptions = ConnectionUserOptions()
        let connection: Connection = Connection(url: "url", options: opts)
        connection.ws?.send([])

        try! await connection.request(request: try! BaseRequest(mockedRequestData))
        //        connection.onMessage(mockedResponse)
        // TODO: Deep Equal
        //        XCTAssertEqual(messages, [])
    }

    func _testAsTrue() {
        let messages: [[String: AnyObject]] = []
        //        console.log = function (id: number, message: string): void {
        //            messages.push([id, message])
        //        }
        let opts: ConnectionUserOptions = ConnectionUserOptions()
        let connection: Connection = Connection(url: "url", options: opts)
        connection.ws?.send([])

        //        connection.request(request: mockedRequestData)
        //        connection.onMessage(mockedResponse)
        // TODO: Deep Equal
        //        XCTAssertEqual(messages, [])
    }

    func _testAsFunction() {
        let messages: [[String: AnyObject]] = []
        //        console.log = function (id: number, message: string): void {
        //            messages.push([id, message])
        //        }
        let opts: ConnectionUserOptions = ConnectionUserOptions()
        let connection: Connection = Connection(url: "url", options: opts)
        connection.ws?.send([])

        //        connection.request(request: mockedRequestData)
        //        connection.onMessage(mockedResponse)
        // TODO: Deep Equal
        //        XCTAssertEqual(messages, [])
    }
}

func jsonToString(_ json: [String: AnyObject]) -> String {
    do {
        let data1 =  try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        guard let convertedString = String(data: data1, encoding: String.Encoding.utf8) else { return "" }
        return convertedString
    } catch _ {
        return ""
    }
}
