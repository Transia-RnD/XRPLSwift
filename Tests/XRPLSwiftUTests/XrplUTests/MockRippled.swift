//
//  MockRippled.swift
//  
//
//  Created by Denis Angell on 8/18/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/createMockRippled.ts

import Foundation
import Network
import OSLog

@testable import XRPLSwift

func createResponse(
    request: [String: AnyObject],
    response: [String: AnyObject]
) throws -> String {
    var cloneResp: [String: AnyObject] = response
    if response["type"] == nil && response["error"] == nil {
        throw XrplError("Bad response format. Must contain `type` or `error`. \(response)")
    }
    cloneResp["id"] = (request["id"] as! Int) as AnyObject
    return jsonToString(cloneResp)
}

public struct MockError: Error {
    var message: String?
    var data: Data?

    init(_ message: String?, _ data: Data? = nil) {
        if let message = message {
            self.message = message
        }
        self.data = data
    }
}

public class PortResponse: BaseResponse<Any> {}

class MockRippledSocket {

    var logger = Logger()

    var listener: NWListener
    var connectedClients: [NWConnection] = []

    var timer: Timer?
    var responses: [String: AnyObject] = [:]
    var suppressOutput: Bool = false

    init(port: Int) {

        let parameters = NWParameters(tls: nil)
        parameters.allowLocalEndpointReuse = true
        parameters.includePeerToPeer = true

        let wsOptions = NWProtocolWebSocket.Options()
        wsOptions.autoReplyPing = true

        parameters.defaultProtocolStack.applicationProtocols.insert(wsOptions, at: 0)

        do {
            if let port = NWEndpoint.Port(rawValue: UInt16(port)) {
                listener = try NWListener(using: parameters, on: port)
            } else {
                fatalError("Unable to start WebSocket server on port \(port)")
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func start() {
        let serverQueue = DispatchQueue(label: "ServerQueue")
        listener.newConnectionHandler = { newConnection in
            self.logger.info("New connection connecting")

            newConnection.stateUpdateHandler = { state in
                switch state {
                    case .ready:
                        self.logger.info("Client ready")
                        self.receive(conn: newConnection)
                    case .failed(let error):
                        self.logger.info("Client connection failed \(error.localizedDescription)")
                    case .waiting(let error):
                        self.logger.info("Waiting for long time \(error.localizedDescription)")
                    default:
                        self.logger.info("LISTENER UNKNOWN STATE")
                        break
                }
            }
            newConnection.start(queue: serverQueue)
        }

        listener.stateUpdateHandler = { state in
            switch state {
                case .ready:
                    self.logger.info("Server Ready")
                case .failed(let error):
                    self.logger.info("Server failed with \(error.localizedDescription)")
                default:
                    self.logger.info("LISTENER UNKNOWN STATE")
                    break
            }
        }

        listener.start(queue: serverQueue)
        startTimer()
    }

    func receive(conn: NWConnection) {
        conn.receiveMessage { (data, context, _, error) in
            self.logger.info("[MOCK] receive")
            var request: [String: AnyObject] = [:]
            print(request)
            guard let data = data, let context = context else {
                return
            }
            do {
                self.logger.info("[MOCK] NEW MESSAGE")
                request = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: AnyObject]
                self.logger.info("\(jsonToString(request))")

                if request["id"] == nil {
                    throw XrplError("Request has no id: \(jsonToString(request))")
                }
                if request["command"] == nil {
                    throw XrplError("Request has no id: \(jsonToString(request))")
                }
                if request["command"] as! String == "ping" {
                    try self.ping(conn: conn, request: request)
                } else if request["command"] as! String == "test_command" {
                    try self.testCommand(conn: conn, request: request)
                } else if self.responses[request["command"] as! String] != nil {
                    try self.send(
                        conn: conn,
                        string: try createResponse(
                            request: request,
                            response: try self.getResponse(request: request)
                        )
                    )
                } else {
                    throw XrplError("No event handler registered in mock rippled for \(request["command"])")
                }
            } catch let error as XrplError {
                if !self.suppressOutput {
                    // eslint-disable-next-line no-console -- only logger.infoed out on error
//                    console.error(error.message)
                    self.logger.error("\(error.localizedDescription)")
                }
                if !request.isEmpty {
                    let errorResponse = [
                        "type": "response",
                        "status": "error",
                        "error": error.message,
                    ] as [String: AnyObject]
                    try! self.send(conn: conn, string: try createResponse(request: request, response: errorResponse))
                }
            } catch {
                fatalError(error.localizedDescription)
            }
            self.receive(conn: conn)
        }
    }

    func startTimer() {
        self.timer?.fire()
    }

    func ping(
        conn: NWConnection,
        request: [String: AnyObject]
    ) throws {
        let response: [String: AnyObject] = [
            "result": [:],
            "status": "Success",
            "type": "response"
        ] as! [String: AnyObject]
        let responseString: String = try createResponse(request: request, response: response)
        let data: Data = responseString.data(using: .utf8)!
        let metadata = NWProtocolWebSocket.Metadata(opcode: .binary)
        let context = NWConnection.ContentContext(identifier: "context", metadata: [metadata])
        conn.send(content: data, contentContext: context, isComplete: true, completion: .contentProcessed({ error in
            if let error = error {
                self.logger.info("\(error.localizedDescription)")
            } else {
                // no-op
            }
        }))
    }

    //    func send(data: Data, client: NWConnection) throws {
    //        //        let data = try JSONSerialization.data(withJSONObject: request, options: .prettyPrinted)
    //        let metadata = NWProtocolWebSocket.Metadata(opcode: .binary)
    //        let context = NWConnection.ContentContext(identifier: "context", metadata: [metadata])
    //
    //        client.send(content: data, contentContext: context, isComplete: true, completion: .contentProcessed({ error in
    //            if let error = error {
    //                logger.info(error.localizedDescription)
    //            } else {
    //                // no-op
    //            }
    //        }))
    //    }

    func send(conn: NWConnection, string: String) throws {
        let data: Data = string.data(using: .utf8)!
        let metadata = NWProtocolWebSocket.Metadata(opcode: .binary)
        let context = NWConnection.ContentContext(identifier: "context", metadata: [metadata])
        conn.send(content: data, contentContext: context, isComplete: true, completion: .contentProcessed({ error in
            if let error = error {
                self.logger.info("\(error.localizedDescription)")
            } else {
                // no-op
            }
        }))
    }

    /**
     * Adds a mocked response
     * If an object is passed in for `response`, then the response is static for the command
     * If a function is passed in for `response`, then the response can be determined by the exact request shape
     */
    func addResponse(command: String, response: [String: AnyObject]) throws {
        if response["type"] == nil && response["error"] == nil {
            throw XrplError("Bad response format. Must contain `type` or `error`. \(jsonToString(response))")
        }
        self.responses[command] = response as AnyObject
    }

    func getResponse(request: [String: AnyObject]) throws -> [String: AnyObject] {
        let command = request["command"] as! String
        if self.responses[command] == nil {
            throw XrplError("No handler for \(command)")
        }
        let functionOrObject = self.responses[command]
        //        if (typeof functionOrObject == "function") {
        //          return functionOrObject(request) as Record<string, unknown>
        //        }
        return functionOrObject as! [String: AnyObject]
    }

    func testCommand(conn: NWConnection, request: [String: AnyObject]) throws {
        let data: [String: AnyObject] = request["data"] as! [String: AnyObject]
        if let disconnectIn = data["disconnectIn"] as? Int {
            logger.info("disconnectIn")
            logger.info("\(disconnectIn)")
            //          setTimeout(conn.terminate.bind(conn), request.data.disconnectIn)
            let response: [String: AnyObject] = [
                "result": [:],
                "status": "Success",
                "type": "response"
            ] as! [String: AnyObject]
            let responseString: String = try createResponse(request: request, response: response)
            try self.send(
                conn: conn,
                string: responseString
            )
        } else if let openOnOtherPort = data["openOnOtherPort"] as? Int {
            logger.info("openOnOtherPort")
            logger.info("\(openOnOtherPort)")
            //          getFreePort().then((newPort) => {
            //            createMockRippled(newPort)
            //            conn.send(
            //              createResponse(request, {
            //                status: 'success',
            //                type: 'response',
            //                result: { port: newPort },
            //              }),
            //            )
            //          })
        } else if let closeServerAndReopen = data["closeServerAndReopen"] as? Int {
            logger.info("closeServerAndReopen")
            logger.info("\(closeServerAndReopen)")
            //            conn.terminate()
            //            mock.close(() => {
            //                createMockRippled(port)
            //            })
        } else if let unrecognizedResponse = data["unrecognizedResponse"] as? Int {
            logger.info("unrecognizedResponse")
            logger.info("\(unrecognizedResponse)")
            let response: [String: AnyObject] = [
                "result": [:],
                "status": "unrecognized",
                "type": "response"
            ] as! [String: AnyObject]
            let responseString: String = try createResponse(request: request, response: response)
            try self.send(conn: conn, string: responseString)
        } else if let closeServer = data["closeServer"] as? Int {
            logger.info("closeServer")
            logger.info("\(closeServer)")
            conn.forceCancel()
            listener.cancel()
//            logger.info("\(conn.state)")
        } else if let delayedResponseIn = data["delayedResponseIn"] as? Int {
            logger.info("delayedResponseIn")
            logger.info("\(delayedResponseIn)")
            let response: [String: AnyObject] = [
                "result": [:],
                "status": "Success",
                "type": "response"
            ] as! [String: AnyObject]
            let responseString: String = try createResponse(request: request, response: response)
            try self.send(conn: conn, string: responseString)
        }
    }
}
