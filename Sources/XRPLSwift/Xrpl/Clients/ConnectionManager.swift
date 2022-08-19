//
//  ConnectionManager.swift
//  
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/client/ConnectionManager.ts

import Foundation
import NIOCore
import NIO

let eventGroup = MultiThreadedEventLoopGroup(numberOfThreads: 4)

//struct PromiseResolveMap {
//    var resolve: (value?: void | PromiseLike<void>) => void
//    var reject: (value?: Error) => void
//}

/**
 * Manage all the requests made to the websocket, and their async responses
 * that come in from the WebSocket. Because they come in over the WS connection
 * after-the-fact.
 */
public class ConnectionManager {
    private var promisesAwaitingConnection: [EventLoopPromise<Any>] = []
    
    /**
     * Resolves all awaiting connections.
     */
    public func resolveAllAwaiting() -> Void {
        _ = self.promisesAwaitingConnection.map { resolve in
            resolve.succeed("")
        }
        self.promisesAwaitingConnection = []
    }
    
    /**
     * Rejects all awaiting connections.
     *
     * @param error - Error to throw in the rejection.
     */
    public func rejectAllAwaiting(error: Error) -> Void {
        _ = self.promisesAwaitingConnection.map { resolve in
            resolve.fail(error)
        }
        self.promisesAwaitingConnection = []
    }
    
    /**
     * Await a new connection.
     *
     * @returns A promise for resolving the connection.
     */
    public func awaitConnection() async -> EventLoopFuture<Any> {
        let promise = eventGroup.next().makePromise(of: Any.self)
        self.promisesAwaitingConnection.append(promise)
        return promise.futureResult
    }
}
