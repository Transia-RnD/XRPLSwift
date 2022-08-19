//
//  WSWrapper.swift
//
//
//  Created by Mitch Lang on 1/31/20.
//  Updated by Denis Angell on 7/26/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/client/WSWrapper.ts

import Foundation
import NIO

let socketGroup = MultiThreadedEventLoopGroup(numberOfThreads: 4)

public protocol XRPLWebSocketDelegate {
    func onConnected(connection: XRPLWebSocket)
    func onDisconnected(connection: XRPLWebSocket, error: Error?)
    func onError(connection: XRPLWebSocket, error: Error)
    func onResponse(connection: XRPLWebSocket, response: BaseResponse<Any>)
    func onStream(connection: XRPLWebSocket, object: NSDictionary)
}

public protocol XRPLWebSocket {
    func send(text: String)
    func send(data: Data)
    func connect(host: String, path: String)
    func disconnect()
    var delegate: XRPLWebSocketDelegate? {
        get
        set
    }
    
    // convenience methods
    func subscribe(account: String)
}

class _WebSocket: NSObject  {
    var delegate: XRPLWebSocketDelegate?
    internal override init() {}
    fileprivate func handleResponse(connection: XRPLWebSocket, data: Data) {
//        if let response = try? JSONDecoder().decode(BaseResponse<Any>.self, from: data) {
//            self.delegate?.onResponse(connection: connection, response: response)
//        } else if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//            self.delegate?.onStream(connection: connection, object: json)
//        }
    }
}

#if canImport(WebSocketKit)

import WebSocketKit

class LinuxWebSocket: _WebSocket, XRPLWebSocket {
    func subscribe(account: String) {
        print()
    }
    
    
    var ws: WebSocket!
    
    func send(text: String) {
        if ws != nil && !ws.isClosed {
            ws.send(text)
        }
    }
    
    func send(data: Data) {
        if ws != nil && !ws.isClosed {
            ws.send([UInt8](data))
        }
    }
    
    func connect(host: String) {
        let client = WebSocketClient(eventLoopGroupProvider: .shared(socketGroup))
        try! client.connect(scheme: "wss", host: host, port: 443, onUpgrade: { (_ws) -> () in
            self.ws = _ws
        }).wait()
        self.delegate?.onConnected(connection: self)
        self.ws.onText { (ws, text) in
            let data = text.data(using: .utf8)!
            self.handleResponse(connection: self, data: data)
        }
        self.ws.onBinary { (ws, byteBuffer) in
            fatalError()
        }
        _ = self.ws.onClose.map {
            self.delegate?.onDisconnected(connection: self, error: nil)
        }
        
    }
    
    func connect(host: String, path: String) {
        let client = WebSocketClient(eventLoopGroupProvider: .shared(socketGroup))
        try! client.connect(scheme: "wss", host: host, port: 443, path: path, onUpgrade: { (_ws) -> () in
            self.ws = _ws
            self.ws.onText { ws, text in
                let data = text.data(using: .utf8)!
                self.handleResponse(connection: self, data: data)
            }
        }).wait()
        self.delegate?.onConnected(connection: self)
        self.ws.onText { (ws, text) in
            let data = text.data(using: .utf8)!
            self.handleResponse(connection: self, data: data)
        }
        self.ws.onBinary { (ws, byteBuffer) in
            fatalError()
        }
        _ = self.ws.onClose.map {
            self.delegate?.onDisconnected(connection: self, error: nil)
        }
        
    }
    
    func disconnect() {
        _ = ws.close()
    }
    
    
    
}

#elseif !os(Linux)


import Foundation

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
class AppleWebSocket: _WebSocket, XRPLWebSocket, URLSessionWebSocketDelegate {
    
    var webSocketTask: URLSessionWebSocketTask!
    var urlSession: URLSession!
    let delegateQueue = OperationQueue()
    var connected: Bool = false
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.connected = true
        self.delegate?.onConnected(connection: self)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.delegate?.onDisconnected(connection: self, error: nil)
        self.connected = false
    }
    
    func connect(host: String, path: String) {
        let url = URL(string: "wss://" + host + "/" + path)!
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: delegateQueue)
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask.resume()
        self.connected = true
        listen()
    }
    
    func disconnect() {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }
    
    func listen()  {
        webSocketTask.receive { result in
            switch result {
            case .failure(let error):
                self.delegate?.onError(connection: self, error: error)
            case .success(let message):
                switch message {
                case .string(let text):
                    let data = text.data(using: .utf8)!
                    self.handleResponse(connection: self, data: data)
                case .data(let data):
                    self.handleResponse(connection: self, data: data)
                @unknown default:
                    fatalError()
                }
                
                self.listen()
            }
        }
    }
    
    func send(request: String) {
        if self.connected {
            webSocketTask.send(URLSessionWebSocketTask.Message.string(text)) { error in
                if let error = error {
                    self.delegate?.onError(connection: self, error: error)
                }
            }
        }
    }
    
    func send(text: String) {
        if self.connected {
            webSocketTask.send(URLSessionWebSocketTask.Message.string(text)) { error in
                if let error = error {
                    self.delegate?.onError(connection: self, error: error)
                }
            }
        }
    }
    
    func send(data: Data) {
        if self.connected {
            webSocketTask.send(URLSessionWebSocketTask.Message.data(data)) { error in
                if let error = error {
                    self.delegate?.onError(connection: self, error: error)
                }
            }
        }
    }
}

#endif
