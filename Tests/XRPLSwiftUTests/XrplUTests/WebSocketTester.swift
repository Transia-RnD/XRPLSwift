//
//  WebSocketTester.swift
//
//
//  Created by Mitch Lang on 2/3/20.
//
import Foundation
import XRPLSwift

class WebSocketTester: XRPLWebSocketDelegate {
    func onResponse(connection: XRPLWebSocket, response: BaseResponse<Any>) {
        print("onResponse")
        //        self.completion(response)
    }

    var completion: (XRPLWebSocketResponse) -> Void

    init(completion: @escaping (XRPLWebSocketResponse) -> Void) {
        self.completion = completion
    }

    func onConnected(connection: XRPLWebSocket) {
        print("onConnected")
    }

    func onDisconnected(connection: XRPLWebSocket, error: Error?) {
        print("onDisconnected")
    }

    func onError(connection: XRPLWebSocket, error: Error) {
        print("onError")
    }

    func onResponse(connection: XRPLWebSocket, response: XRPLWebSocketResponse) {
        print("onResponse")
        self.completion(response)
    }

    func onStream(connection: XRPLWebSocket, object: NSDictionary) {
        print("onStream")
    }
}
