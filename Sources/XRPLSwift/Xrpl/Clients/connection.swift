//
//  File.swift
//  
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/client/connection.ts

import Foundation
import WebSocketKit

private let SECONDS_PER_MINUTE: Int = 60
private let TIMEOUT: Int = 20
private let CONNECTION_TIMEOUT: Int = 5

/**
 * ConnectionOptions is the configuration for the Connection class.
 */
public class ConnectionOptions {
    //  trace: Bool? | ((id: string, message: string) => void)
    public var trace: Bool?
    public var proxy: String?
    public var proxyAuthorization: String?
    public var authorization: String?
    public var trustedCertificates: [String]?
    public var key: String?
    public var passphrase: String?
    public var certificate: String?
    public var timeout: Timer
    public var connectionTimeout: Int
    public var headers: [String: [String: String]]?
    
    init() {}
}

/**
 * ConnectionUserOptions is the user-provided configuration object. All configuration
 * is optional, so any ConnectionOptions configuration that has a default value is
 * still optional at the point that the user provides it.
 */
public class ConnectionUserOptions: ConnectionOptions {}

/**
 * Represents an intentionally triggered web-socket disconnect code.
 * WebSocket spec allows 4xxx codes for app/library specific codes.
 * See: https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent
 */
//public let INTENTIONAL_DISCONNECT_CODE = 4000

//typealias WebsocketState: Int = 0 | 1 | 2 | 3

//func getAgent(url: String, config: ConnectionOptions) -> Agent? {
//  if config.proxy == nil {
//    return nil
//  }
//
//  let parsedURL = URL(url)
//    let parsedProxyURL = URL(config.proxy)
//
//  let proxyOptions = _.omitBy(
//    {
//      secureEndpoint: parsedURL.protocol === 'wss:',
//      secureProxy: parsedProxyURL.protocol === 'https:',
//      auth: config.proxyAuthorization,
//      ca: config.trustedCertificates,
//      key: config.key,
//      passphrase: config.passphrase,
//      cert: config.certificate,
//      href: parsedProxyURL.href,
//      origin: parsedProxyURL.origin,
//      protocol: parsedProxyURL.protocol,
//      username: parsedProxyURL.username,
//      password: parsedProxyURL.password,
//      host: parsedProxyURL.host,
//      hostname: parsedProxyURL.hostname,
//      port: parsedProxyURL.port,
//      pathname: parsedProxyURL.pathname,
//      search: parsedProxyURL.search,
//      hash: parsedProxyURL.hash,
//    },
//    (value) => value == null,
//  )
//
//  let HttpsProxyAgent: new (opt: typeof proxyOptions) => Agent
//  do {
//    /* eslint-disable @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-require-imports,
//      node/global-require, global-require, -- Necessary for the `require` */
//    HttpsProxyAgent = require('https-proxy-agent')
//    /* eslint-enable @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-require-imports,
//      node/global-require, global-require, */
//  } catch (_error) {
//    throw new Error('"proxy" option is not supported in the browser')
//  }
//  return new HttpsProxyAgent(proxyOptions)
//}

/**
 * Create a new websocket given your URL and optional proxy/certificate
 * configuration.
 *
 * @param url - The URL to connect to.
 * @param config - THe configuration options for the WebSocket.
 * @returns A Websocket that fits the given configuration parameters.
 */
public func createWebSocket(
    url: String,
    config: ConnectionOptions
) -> WebSocket? {
//    let options: WebSocket.ClientOptions = [:]
//    options.agent = getAgent(url, config)
//    if config.headers != nil {
//        options.headers = config.headers
//    }
//    if config.authorization != nil {
//        let base64 = Data(from: config.authorization).base64EncodedString()
//        options.headers = [
//            ...options.headers,
//            "Authorization": "Basic \(base64)"
//        ]
//    }
    let optionsOverrides = [
        "ca": config.trustedCertificates,
        "key": config.key,
        "passphrase": config.passphrase,
        "cert": config.certificate,
    ] as [String : Any]
    let websocketOptions = optionsOverrides
//    let websocket = WebSocket()
    /*
     * we will have a listener for each outstanding request,
     * so we have to raise the limit (the default is 10)
     */
//    if typeof websocket.setMaxListeners == "function" {
//        websocket.setMaxListeners(1000000)
//    }
//    return websocket
    return nil
}

/**
 * Ws.send(), but promisified.
 *
 * @param ws - Websocket to send with.
 * @param message - Message to send.
 * @returns When the message has been sent.
 */
//async func websocketSendAsync(
//  ws: WebSocket,
//  message: string,
//): Promise<void> {
//  return new Promise<void>((resolve, reject) => {
//    ws.send(message, (error) => {
//      if (error) {
//        reject(new DisconnectedError(error.message, error))
//      } else {
//        resolve()
//      }
//    })
//  })
//}

/**
 * The main Connection class. Responsible for connecting to & managing
 * an active WebSocket connection to a XRPL node.
 */
public class Connection {
    private let url: String?
    private let ws: WebSocket? = nil
    private var reconnectTimeoutID: String = "NodeJS.Timeout"
    private var heartbeatIntervalID: String = "NodeJS.Timeout"
    private let retryConnectionBackoff = ExponentialBackoff(
        opts: ExponentialBackoffOptions(min: 100, max: SECONDS_PER_MINUTE * 1000)
    )
    
    private let config: ConnectionOptions
    private let requestManager = RequestManager()
    private let connectionManager = ConnectionManager()
    
    private var state: String = "open"
    
    /**
     * Creates a new Connection object.
     *
     * @param url - URL to connect to.
     * @param options - Options for the Connection object.
     */
    public init(url: String?, options: ConnectionUserOptions? = nil) {
        //    super()
//        ws.setMaxListeners(1000000)
        self.url = url
//        self.config = {
//            self.timeout: TIMEOUT * 1000,
//        connectionTimeout: CONNECTION_TIMEOUT * 1000,
//            ...options,
//        }
//        if (typeof options.trace === "function") {
//            self.trace = options.trace
//        } else if (options.trace) {
//            // eslint-disable-next-line no-console -- Used for tracing only
//            self.trace = console.log
//        }
    }
    
    /**
     * Returns whether the websocket is connected.
     *
     * @returns Whether the websocket connection is open.
     */
    public func isConnected() -> Bool {
        return self.ws?.isClosed == false
    }
    
    /**
     * Connects the websocket to the provided URL.
     *
     * @returns When the websocket is connected.
     * @throws ConnectionError if there is a connection error, RippleError if there is already a WebSocket in existence.
     */
    public func connect() async -> EventLoopPromise<Any> {
        print("HERE CONNECTED")
//        if (self.isConnected()) {
//            return EventLoopFuture.
//        }
//        if (self.state == WebSocket.CONNECTING) {
//            return self.connectionManager.awaitConnection()
//        }
//        if (!self.url) {
//            return Promise.reject(
//                new ConnectionError('Cannot connect because no server was specified'),
//            )
//        }
//        if (self.ws != null) {
//            return Promise.reject(
//                new XrplError('Websocket connection never cleaned up.', {
//                state: this.state,
//                }),
//            )
//        }

//        // Create the connection timeout, in case the connection hangs longer than expected.
//        let connectionTimeoutID = setTimeout(() => {
//            self.onConnectionFailed(
//                new ConnectionError(
//                    `Error: connect() timed out after ${this.config.connectionTimeout} ms. If your internet connection is working, the ` +
//                     `rippled server may be blocked or inaccessible. You can also try setting the 'connectionTimeout' option in the Client constructor.`,
//                ),
//            )
//        }, self.config.connectionTimeout)
//        // Connection listeners: these stay attached only until a connection is done/open.
//        self.ws = createWebSocket(self.url, self.config)
//
//        if self.ws == null {
//            throw new XrplError('Connect: created null websocket')
//        }

//        self.ws.on('error', (error) => this.onConnectionFailed(error))
//        self.ws.on('error', () => clearTimeout(connectionTimeoutID))
//        self.ws.on('close', (reason) => this.onConnectionFailed(reason))
//        self.ws.on('close', () => clearTimeout(connectionTimeoutID))
//        self.ws.once('open', () => {
//            void this.onceOpen(connectionTimeoutID)
//        })
        return self.connectionManager.awaitConnection()
    }

    /**
     * Disconnect the websocket connection.
     * We never expect this method to reject. Even on "bad" disconnects, the websocket
     * should still successfully close with the relevant error code returned.
     * See https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent for the full list.
     * If no open websocket connection exists, resolve with no code (`undefined`).
     *
     * @returns A promise containing either `undefined` or a disconnected code, that resolves when the connection is destroyed.
     */
//    public async func disconnect() -> Promise<number | undefined> {
//        self.clearHeartbeatInterval()
//        if self.reconnectTimeoutID != nil {
//            clearTimeout(this.reconnectTimeoutID)
//            self.reconnectTimeoutID = null
//        }
//        if (self.state === WebSocket.CLOSED) {
//            return Promise.resolve(undefined)
//        }
//        if (self.ws == null) {
//            return Promise.resolve(undefined)
//        }
//
//        return new Promise((resolve) => {
//            if (self.ws == null) {
//                resolve(undefined)
//            }
//            if (self.ws != null) {
//                this.ws.once('close', (code) => resolve(code))
//            }
//            /*
//             * Connection already has a disconnect handler for the disconnect logic.
//             * Just close the websocket manually (with our "intentional" code) to
//             * trigger that.
//             */
//            if (self.ws != null && self.state !== WebSocket.CLOSING) {
//                self.ws.close(INTENTIONAL_DISCONNECT_CODE)
//            }
//        })
//    }
//
//    /**
//     * Disconnect the websocket, then connect again.
//     */
//    public async reconnect() -> Promise<void> {
//        /*
//         * NOTE: We currently have a "reconnecting" event, but that only triggers
//         * through an unexpected connection retry logic.
//         * See: https://github.com/XRPLF/xrpl.js/pull/1101#issuecomment-565360423
//         */
//        self.emit('reconnect')
//        await self.disconnect()
//        await self.connect()
//    }
//
//    /**
//     * Sends a request to the rippled server.
//     *
//     * @param request - The request to send to the server.
//     * @param timeout - How long the Connection instance should wait before assuming that there will not be a response.
//     * @returns The response from the rippled server.
//     * @throws NotConnectedError if the Connection isn't connected to a server.
//     */
//    public async request<T extends BaseRequest>(
//        request: T,
//        timeout?: number,
//    ): Promise<unknown> {
//        if (!this.shouldBeConnected || this.ws == null) {
//            throw new NotConnectedError()
//        }
//        const [id, message, responsePromise] = this.requestManager.createRequest(
//            request,
//            timeout ?? this.config.timeout,
//        )
//        this.trace('send', message)
//        websocketSendAsync(this.ws, message).catch((error) => {
//            this.requestManager.reject(id, error)
//        })
//
//                                                    return responsePromise
//    }

    /**
     * Get the Websocket connection URL.
     *
     * @returns The Websocket connection URL.
     */
    public func getUrl() -> String {
        return self.url ?? ""
    }
//
//    // eslint-disable-next-line @typescript-eslint/no-empty-function -- Does nothing on default
//    public let trace: (id: String, message: String) => void = () => {}
//
//    /**
//     * Handler for when messages are received from the server.
//     *
//     * @param message - The message received from the server.
//     */
//    private func onMessage(message) {
//        self.trace('receive', message)
//        let data: Record<string, unknown>
//        try {
//            // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment -- Must be a JSON dictionary
//            data = JSON.parse(message)
//        } catch (error) {
//            if (error instanceof Error) {
//                self.emit('error', 'badMessage', error.message, message)
//            }
//            return
//        }
//        if (data.type == null && data.error) {
//            // e.g. slowDown
//            self.emit('error', data.error, data.error_message, data)
//            return
//        }
//        if (data.type) {
//            // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Should be true
//            self.emit(data.type as string, data)
//        }
//        if (data.type === 'response') {
//            try {
//                self.requestManager.handleResponse(data)
//            } catch (error) {
//                // eslint-disable-next-line max-depth -- okay here
//                if (error instanceof Error) {
//                    self.emit('error', 'badMessage', error.message, message)
//                } else {
//                    self.emit('error', 'badMessage', error, error)
//                }
//            }
//        }
//    }
//
//    /**
//     * Gets the state of the websocket.
//     *
//     * @returns The Websocket's ready state.
//     */
//    private func state() -> WebsocketState {
//        return self.ws ? self.ws.readyState : WebSocket.CLOSED
//    }
//
//    /**
//     * Returns whether the server should be connected.
//     *
//     * @returns Whether the server should be connected.
//     */
//    private func shouldBeConnected() -> Bool {
//        return self.ws !== null
//    }
//
//    /**
//     * Handler for what to do once the connection to the server is open.
//     *
//     * @param connectionTimeoutID - Timeout in case the connection hangs longer than expected.
//     * @returns A promise that resolves to void when the connection is fully established.
//     * @throws Error if the websocket initialized is somehow null.
//     */
//    // eslint-disable-next-line max-lines-per-function -- Many error code conditionals to check.
//    private async func onceOpen(connectionTimeoutID: Timer) -> Promise<void> {
//        if (self.ws == null) {
//            throw new XrplError('onceOpen: ws is null')
//        }
//
//        // Once the connection completes successfully, remove all old listeners
//        self.ws.removeAllListeners()
//        clearTimeout(connectionTimeoutID)
//        // Add new, long-term connected listeners for messages and errors
//        self.ws.on('message', (message: string) => this.onMessage(message))
//        self.ws.on('error', (error) =>
//                   self.emit('error', 'websocket', error.message, error),
//        )
//        // Handle a closed connection: reconnect if it was unexpected
//        self.ws.once('close', (code?: number, reason?: Buffer) => {
//            if (self.ws == null) {
//                throw new XrplError('onceClose: ws is null')
//            }
//
//            self.clearHeartbeatInterval()
//            self.requestManager.rejectAll(
//                new DisconnectedError(
//                    `websocket was closed, ${new TextDecoder('utf-8').decode(reason)}`,
//                ),
//            )
//            self.ws.removeAllListeners()
//            self.ws = null
//
//            if (code == undefined) {
//                let reasonText = reason ? reason.toString() : 'undefined'
//                // eslint-disable-next-line no-console -- The error is helpful for debugging.
//                console.error(
//                    `Disconnected but the disconnect code was undefined (The given reason was ${reasonText}).` +
//                     `This could be caused by an exception being thrown during a 'connect' callback. ` +
//                     `Disconnecting with code 1011 to indicate an internal error has occurred.`,
//                )
//
//                /*
//                 * Error code 1011 represents an Internal Error according to
//                 * https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent/code
//                 */
//                let internalErrorCode = 1011
//                self.emit('disconnected', internalErrorCode)
//            } else {
//                self.emit('disconnected', code)
//            }
//
//            /*
//             * If this wasn't a manual disconnect, then lets reconnect ASAP.
//             * Code can be undefined if there's an exception while connecting.
//             */
//            if (code !== INTENTIONAL_DISCONNECT_CODE && code !== undefined) {
//                self.intentionalDisconnect()
//            }
//        })
//        // Finalize the connection and resolve all awaiting connect() requests
//        try {
//            this.retryConnectionBackoff.reset()
//            this.startHeartbeatInterval()
//            this.connectionManager.resolveAllAwaiting()
//            this.emit('connected')
//        } catch (error) {
//            if (error instanceof Error) {
//                this.connectionManager.rejectAllAwaiting(error)
//                // Ignore this error, propagate the root cause.
//                // eslint-disable-next-line @typescript-eslint/no-empty-function -- Need empty catch
//                await this.disconnect().catch(() => {})
//            }
//        }
//    }
//
//    private intentionalDisconnect(): void {
//        const retryTimeout = this.retryConnectionBackoff.duration()
//        this.trace('reconnect', `Retrying connection in ${retryTimeout}ms.`)
//        this.emit('reconnecting', this.retryConnectionBackoff.attempts)
//        /*
//         * Start the reconnect timeout, but set it to `this.reconnectTimeoutID`
//         * so that we can cancel one in-progress on disconnect.
//         */
//        this.reconnectTimeoutID = setTimeout(() => {
//            this.reconnect().catch((error: Error) => {
//                this.emit('error', 'reconnect', error.message, error)
//            })
//        }, retryTimeout)
//    }
//
//    /**
//     * Clears the heartbeat connection interval.
//     */
//    private clearHeartbeatInterval(): void {
//        if (this.heartbeatIntervalID) {
//            clearInterval(this.heartbeatIntervalID)
//        }
//    }
//
//    /**
//     * Starts a heartbeat to check the connection with the server.
//     */
//    private startHeartbeatInterval(): void {
//        this.clearHeartbeatInterval()
//        this.heartbeatIntervalID = setInterval(() => {
//            void this.heartbeat()
//        }, this.config.timeout)
//    }
//
//    /**
//     * A heartbeat is just a "ping" command, sent on an interval.
//     * If this succeeds, we're good. If it fails, disconnect so that the consumer can reconnect, if desired.
//     *
//     * @returns A Promise that resolves to void when the heartbeat returns successfully.
//     */
//    private async heartbeat(): Promise<void> {
//        this.request({ command: 'ping' }).catch(async () => {
//            return this.reconnect().catch((error: Error) => {
//                this.emit('error', 'reconnect', error.message, error)
//            })
//        })
//    }
//
//    /**
//     * Process a failed connection.
//     *
//     * @param errorOrCode - (Optional) Error or code for connection failure.
//     */
//    private onConnectionFailed(errorOrCode: Error | number | null) {
//        if (this.ws) {
//            this.ws.removeAllListeners()
//            this.ws.on('error', () => {
//                /*
//                 * Correctly listen for -- but ignore -- any future errors: If you
//                 * don't have a listener on "error" node would log a warning on error.
//                 */
//            })
//            this.ws.close()
//            this.ws = null
//        }
//        if (typeof errorOrCode === 'number') {
//            this.connectionManager.rejectAllAwaiting(
//                new NotConnectedError(`Connection failed with code ${errorOrCode}.`, {
//                code: errorOrCode,
//                }),
//            )
//        } else if (errorOrCode?.message) {
//            this.connectionManager.rejectAllAwaiting(
//                new NotConnectedError(errorOrCode.message, errorOrCode),
//            )
//        } else {
//            this.connectionManager.rejectAllAwaiting(
//                new NotConnectedError('Connection failed.'),
//            )
//        }
//    }
}
