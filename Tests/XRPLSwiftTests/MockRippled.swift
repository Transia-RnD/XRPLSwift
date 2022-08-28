//
//  MockRippled.swift
//  
//
//  Created by Denis Angell on 8/18/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/createMockRippled.ts

import Foundation
import Network
@testable import XRPLSwift

func createResponse(
    request: [String: AnyObject],
    response: [String: AnyObject]
) throws -> String {
    var cloneResp: [String: AnyObject] = response
    if response["type"] == nil && response["error"] == nil {
        throw XrplError.unknown("Bad response format. Must contain `type` or `error`. \(response)")
    }
    cloneResp["id"] = (request["id"] as! Int) as AnyObject
    return jsonToString(cloneResp)
}

public class PortResponse: BaseResponse<Any> {}

class MockRippledSocket {
    var listener: NWListener
    var connectedClients: [NWConnection] = []

    var timer: Timer?
    var responses: [String: AnyObject] = [:]

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
            print("New connection connecting")
            func receive() {
                newConnection.receiveMessage { (data, context, _, error) in
                    var request: [String: AnyObject] = [:]
                    guard let data = data, let context = context else {
                        receive()
                        return
                    }

                    print(self.responses)
                    do {
                        print("Received a new message from client")
                        request = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: AnyObject]
                        print(request)
                        print(context)

                        if request["id"] == nil {
                            fatalError("Request has no id: \(jsonToString(request))")
                        }
                        if request["command"] == nil {
                            fatalError("Request has no id: \(jsonToString(request))")
                        }
                        if request["command"] as! String == "ping" {
                            try self.ping(conn: newConnection, request: request)
                        } else if request["command"] as! String == "test_command" {
                            try self.testCommand(conn: newConnection, request: request)
                        } else if self.responses[request["command"] as! String] != nil {
                            print(self.responses[request["command"] as! String])
                            print("HERE")
                            //                        newConnection.send(createResponse(request, mock.getResponse(request)))
                        } else {
                            fatalError("No event handler registered in mock rippled for \(request["command"])")
                        }
                    } catch {
                        print(error.localizedDescription)
//                        if (!(err instanceof Error)) {
//                          throw err
//                        }
//
//                        if (!mock.suppressOutput) {
//                          // eslint-disable-next-line no-console -- only printed out on error
//                          console.error(err.message)
//                        }
//                        if (request != null) {
//                          conn.send(
//                            createResponse(request, {
//                              type: 'response',
//                              status: 'error',
//                              error: err.message,
//                            }),
//                          )
//                        }
                    }

                }
            }
            receive()

            newConnection.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    print("Client ready")
                    //                    try! self.sendMessageToClient(data: JSONEncoder().encode(["t": "connect.connected"]), client: newConnection)
                case .failed(let error):
                    print("Client connection failed \(error.localizedDescription)")
                case .waiting(let error):
                    print("Waiting for long time \(error.localizedDescription)")
                default:
                    break
                }
            }

            newConnection.start(queue: serverQueue)
        }

        listener.stateUpdateHandler = { state in
            print(state)
            switch state {
            case .ready:
                print("Server Ready")
            case .failed(let error):
                print("Server failed with \(error.localizedDescription)")
            default:
                break
            }
        }

        listener.start(queue: serverQueue)
        startTimer()
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
                print(error.localizedDescription)
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
    //                print(error.localizedDescription)
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
                print(error.localizedDescription)
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
    func addResponses(command: String, response: [String: AnyObject]) throws {
        if response["type"] != nil && response["error"] != nil {
            throw XrplError.unknown("Bad response format. Must contain `type` or `error`. \(jsonToString(response))")
        }
        self.responses[command] = response as AnyObject
    }

    func getResponse(request: BaseRequest) throws -> [String: AnyObject] {
        if self.responses[request.command!] == nil {
            throw XrplError.unknown("No handler for \(request.command ?? "")")
        }
        let functionOrObject = self.responses[request.command!]
        //        if (typeof functionOrObject == "function") {
        //          return functionOrObject(request) as Record<string, unknown>
        //        }
        return functionOrObject as! [String: AnyObject]
    }

    func testCommand(conn: NWConnection, request: [String: AnyObject]) throws {
        let data: [String: AnyObject] = request["data"] as! [String: AnyObject]
        if let disconnectIn = data["disconnectIn"] as? Int {
            print("disconnectIn")
            print(disconnectIn)
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
            print("openOnOtherPort")
            print(openOnOtherPort)
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
            print("closeServerAndReopen")
            print(closeServerAndReopen)
//            conn.terminate()
//            mock.close(() => {
//                createMockRippled(port)
//            })
        } else if let unrecognizedResponse = data["unrecognizedResponse"] as? Int {
            print("unrecognizedResponse")
            print(unrecognizedResponse)
            let response: [String: AnyObject] = [
                "result": [:],
                "status": "unrecognized",
                "type": "response"
            ] as! [String: AnyObject]
            let responseString: String = try createResponse(request: request, response: response)
            try self.send(conn: conn, string: responseString)
        } else if let closeServer = data["closeServer"] as? Int {
            print("closeServer")
            print(closeServer)
            conn.forceCancel()
            listener.cancel()
            print(conn.state)
        } else if let delayedResponseIn = data["delayedResponseIn"] as? Int {
            print("delayedResponseIn")
            print(delayedResponseIn)
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
