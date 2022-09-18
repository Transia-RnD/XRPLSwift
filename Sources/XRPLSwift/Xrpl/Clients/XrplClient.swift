//
//  XrplClient.swift
//  
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/client/index.ts

import AnyCodable
import Foundation
import NIO

public class ClientOptions: ConnectionUserOptions {
    public var feeCushion: Int?
    public var maxFeeXRP: String?

    init(
        timeout: Timer,
        proxy: String? = nil,
        feeCushion: Int? = nil,
        maxFeeXRP: String? = nil
    ) {
        super.init()
        // SUPER
        self.timeout = timeout
        self.proxy = proxy
        self.feeCushion = feeCushion
        self.maxFeeXRP = maxFeeXRP
    }
}

/**
 * Get the response key / property name that contains the listed data for a
 * command. This varies from command to command, but we need to know it to
 * properly count across many requests.
 *
 * @param command - The rippled request command.
 * @returns The property key corresponding to the command.
 */
private func getCollectKeyFromCommand(command: String) -> String? {
    switch command {
    case "account_channels":
        return "channels"
    case "account_lines":
        return "lines"
    case "account_objects":
        return "account_objects"
    case "account_tx":
        return "transactions"
    case "account_offers":
        return "offers"
    case "book_offers":
        return "offers"
    case "ledger_data":
        return "state"
    default:
        return nil
    }
}

func clamp(value: Int, min: Int, max: Int) -> Int {
    //  assert.ok(min <= max, "Illegal clamp bounds")
    //    return min(max(value, min), max)
    return 0
}

class MarkerRequest: BaseRequest {
    var limit: Int?
    var marker: String?
}

// struct MarkerResult {
//    private var marker: String?
// }

class MarkerResponse: BaseResponse<Any> {}

// swiftlint:disable:next identifier_name
private let DEFAULT_FEE_CUSHION: Double = 1.2
// swiftlint:disable:next identifier_name
private let DEFAULT_MAX_FEE_XRP: String = "2"
// swiftlint:disable:next identifier_name
private let MIN_LIMIT: Int = 10
// swiftlint:disable:next identifier_name
private let MAX_LIMIT: Int = 400
// swiftlint:disable:next identifier_name
private let NORMAL_DISCONNECT_CODE: Int = 1_000

// public typealias T = Any
// public typealias R = Any

public class EventEmitter {}

public protocol XrplClientDelegate {
    func submit(connection: XRPLWebSocket)
}

/**
 * Client for interacting with rippled servers.
 *
 * @category Clients
 */
public class XrplClient: ConnectionDelegate {
    public func error(code: Int, message: Any, data: Data) {
//        self.emit("error", errorCode, errorMessage, data)
    }

    public func connected() {
//        self.emit("connected")
    }

    public func disconnected(code: Int) {
//        let finalCode = code
//                    /*
//                     * 4000: Connection uses a 4000 code internally to indicate a manual disconnect/close
//                     * Since 4000 is a normal disconnect reason, we convert this to the standard exit code 1000
//                     */
//                    if (finalCode === INTENTIONAL_DISCONNECT_CODE) {
//                        finalCode = NORMAL_DISCONNECT_CODE
//                    }
//                    self.emit("disconnected", finalCode)
    }

    public func ledgerClosed(ledger: Any) {
//        self.emit("ledgerClosed", ledger)
    }

    public func transaction(tx: Any) {
        // mutates `tx` to add warnings
        //            handleStreamPartialPayment(tx, self.connection.trace)
        //            self.emit("transaction", tx)
    }

    public func validationReceived(validation: Any) {
//        self.emit("validationReceived", validation)
    }

    public func manifestReceived(manifest: Any) {
//        self.emit("manifestReceived", manifest)
    }

    public func peerStatusChange(status: Any) {
//        self.emit("peerStatusChange", status)
    }

    public func consensusPhase(consensus: Any) {
//        self.emit("consensusPhase", consensus)
    }

    public func pathFind(path: Any) {
//        self.emit("path_find", path)
    }

    /*
     * Underlying connection to rippled.
     */
    public var connection: Connection

    /**
     * Factor to multiply estimated fee by to provide a cushion in case the
     * required fee rises during submission of a transaction. Defaults to 1.2.
     *
     * @category Fee
     */
    public let feeCushion: Int

    /**
     * Maximum transaction cost to allow, in decimal XRP. Must be a string-encoded
     * number. Defaults to "2".
     *
     * @category Fee
     */
    public let maxFeeXRP: String

    /**
     * Creates a new Client with a websocket connection to a rippled server.
     *
     * @param server - URL of the server to connect to.
     * @param options - Options for client settings.
     * @category Constructor
     */
    // eslint-disable-next-line max-lines-per-function -- okay because we have to set up all the connection handlers
    public init(server: String, options: ClientOptions? = nil) throws {
        if server.isValidWss {
            throw ValidationError("server URI must start with `wss://`, `ws://`, `wss+unix://`, or `ws+unix://`.")
        }
        self.feeCushion = options?.feeCushion ?? Int(DEFAULT_FEE_CUSHION)
        self.maxFeeXRP = options?.maxFeeXRP ?? DEFAULT_MAX_FEE_XRP
        self.connection = Connection(url: server, options: options)
    }

    /**
     * Get the url that the client is connected to.
     *
     * @returns The URL of the server this client is connected to.
     * @category Network
     */
    func url() -> String {
        return self.connection.getUrl()
    }

    /**
     * @category Network
     */
    // swiftlint:disable:next identifier_name
    func request(_ r: AccountChannelsRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: AccountCurrenciesRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: AccountInfoRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: AccountLinesRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: AccountNFTsRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: AccountObjectsRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: AccountOffersRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: AccountTxRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: BookOffersRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: ChannelVerifyRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: DepositAuthorizedRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: FeeRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: GatewayBalancesRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: LedgerRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: LedgerClosedRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: LedgerCurrentRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: LedgerDataRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
//    // swiftlint:disable:next identifier_name
//    func request(_ r: LedgerEntryRequest) async -> EventLoopFuture<Any> {
//        return await request(r: r)
//    }
//    // swiftlint:disable:next identifier_name
//    func request(_ r: ManifestRequest) async -> EventLoopFuture<Any> {
//        return await request(r: r)
//    }
//    // swiftlint:disable:next identifier_name
    func request(_ r: NFTBuyOffersRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: NFTSellOffersRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
//    // swiftlint:disable:next identifier_name
//    func request(_ r: NoRippleCheckRequest) async -> EventLoopFuture<Any> {
//        return await request(r: r)
//    }
//    // swiftlint:disable:next identifier_name
//    func request(_ r: PathFindRequest) async -> EventLoopFuture<Any> {
//        return await request(r: r)
//    }
    // swiftlint:disable:next identifier_name
    func request(_ r: PingRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: RandomRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: RipplePathFindRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: ServerInfoRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
//    // swiftlint:disable:next identifier_name
//    func request(_ r: ServerStateRequest) async -> EventLoopFuture<Any> {
//        return await request(r: r)
//    }
    // swiftlint:disable:next identifier_name
    func request(_ r: SubmitRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: SubmitMultisignedRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
//    // swiftlint:disable:next identifier_name
//    func request(_ r: SubscribeRequest) async -> EventLoopFuture<Any> {
//        return await request(r: r)
//    }
//    // swiftlint:disable:next identifier_name
//    func request(_ r: UnsubscribeRequest) async -> EventLoopFuture<Any> {
//        return await request(r: r)
//    }
    // swiftlint:disable:next identifier_name
    func request(_ r: TransactionEntryRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    func request(_ r: TxRequest) async -> EventLoopFuture<Any> {
        return await request(r: r)
    }
    // swiftlint:disable:next identifier_name
    public func request<R: BaseRequest>(r: R) async -> EventLoopFuture<Any> {
        //        if let account: String = requestDict["account"] as? String {
        //            requestDict["account"] = ensureClassicAddress(account) as AnyObject
        //        } else {
        //            requestDict["account"] = nil
        //        }
        let response = try! await self.connection.request(request: r)

        // mutates `response` to add warnings
        //        handlePartialPayment(req.command, response)

        return response
    }

    public func request<R: BaseRequest>(_ rdict: R) async throws -> EventLoopFuture<Any> {
        print(try rdict.jsonString())
        let data = try JSONSerialization.data(withJSONObject: rdict, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let base = try decoder.decode(R.self, from: data)
        return try await request(req: base)!
    }

    /**
     * Makes a request to the client with the given command and
     * additional request body parameters.
     *
     * @param req - Request to send to the server.
     * @returns The response from the server.
     * @category Network
     */
    func ensureClassicAddress(_ account: String) -> String {
        return account
    }

    public func request<R: BaseRequest>(req: R) async throws -> EventLoopFuture<Any>? {
        // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Necessary for overloading
        //        print(req)
        //        guard var requestDict = req as? [String: AnyObject] else {
        //            print("DAMN")
        //            print("SO")
        //            return nil
        //        }
        //        if let account: String = requestDict["account"] as? String {
        //            requestDict["account"] = ensureClassicAddress(account) as AnyObject
        //        } else {
        //            requestDict["account"] = nil
        //        }
        let response = try await self.connection.request(request: req)

        //        // mutates `response` to add warnings
        //        handlePartialPayment(req.command, response)

        return response
    }

    //  /**
    //   * @category Network
    //   */
    //  public async requestNextPage(
    //    req: AccountChannelsRequest,
    //    resp: AccountChannelsResponse,
    //  ): Promise<AccountChannelsResponse>
    //  public async requestNextPage(
    //    req: AccountLinesRequest,
    //    resp: AccountLinesResponse,
    //  ): Promise<AccountLinesResponse>
    //  public async requestNextPage(
    //    req: AccountObjectsRequest,
    //    resp: AccountObjectsResponse,
    //  ): Promise<AccountObjectsResponse>
    //  public async requestNextPage(
    //    req: AccountOffersRequest,
    //    resp: AccountOffersResponse,
    //  ): Promise<AccountOffersResponse>
    //  public async requestNextPage(
    //    req: AccountTxRequest,
    //    resp: AccountTxResponse,
    //  ): Promise<AccountTxResponse>
    //  public async requestNextPage(
    //    req: LedgerDataRequest,
    //    resp: LedgerDataResponse,
    //  ): Promise<LedgerDataResponse>
    //  /**
    //   * Requests the next page of data.
    //   *
    //   * @param req - Request to send.
    //   * @param resp - Response with the marker to use in the request.
    //   * @returns The response with the next page of data.
    //   */
    //  public async requestNextPage<
    //    T extends MarkerRequest,
    //    U extends MarkerResponse,
    //  >(req: T, resp: U): Promise<U> {
    //    if (!resp.result.marker) {
    //      return Promise.reject(
    //        new NotFoundError("response does not have a next page"),
    //      )
    //    }
    //    const nextPageRequest = { ...req, marker: resp.result.marker }
    //    // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Necessary for overloading
    //    return this.request(nextPageRequest) as unknown as U
    //  }
    //
    //  /**
    //   * Event handler for subscription streams.
    //   *
    //   * @example
    //   * ```ts
    //   * const api = new Client("wss://s.altnet.rippletest.net:51233")
    //   *
    //   * api.on("transactions", (tx: TransactionStream) => {
    //   *  console.log("Received Transaction")
    //   *  console.log(tx)
    //   * })
    //   *
    //   * await api.connect()
    //   * const response = await api.request({
    //   *     command: "subscribe",
    //   *     streams: ["transactions_proposed"]
    //   * })
    //   * ```
    //   *
    //   * @category Network
    //   */
    //  public on(event: "connected", listener: () => void): this
    //  public on(event: "disconnected", listener: (code: number) => void): this
    //  public on(
    //    event: "ledgerClosed",
    //    listener: (ledger: LedgerStream) => void,
    //  ): this
    //  public on(
    //    event: "validationReceived",
    //    listener: (validation: ValidationStream) => void,
    //  ): this
    //  public on(
    //    event: "transaction",
    //    listener: (tx: TransactionStream) => void,
    //  ): this
    //  public on(
    //    event: "peerStatusChange",
    //    listener: (status: PeerStatusStream) => void,
    //  ): this
    //  public on(
    //    event: "consensusPhase",
    //    listener: (phase: ConsensusStream) => void,
    //  ): this
    //  public on(event: "path_find", listener: (path: PathFindStream) => void): this
    //  // eslint-disable-next-line @typescript-eslint/no-explicit-any -- needs to be any for overload
    //  public on(event: "error", listener: (...err: any[]) => void): this
    //  /**
    //   * Event handler for subscription streams.
    //   *
    //   * @param eventName - Name of the event. Only forwards streams.
    //   * @param listener - Function to run on event.
    //   * @returns This, because it inherits from EventEmitter.
    //   */
    //  // eslint-disable-next-line @typescript-eslint/no-explicit-any -- needs to be any for overload
    //  public on(eventName: string, listener: (...args: any[]) => void): this {
    //    return super.on(eventName, listener)
    //  }
    //
    //  /**
    //   * @category Network
    //   */
    //  public async requestAll(
    //    req: AccountChannelsRequest,
    //  ): Promise<AccountChannelsResponse[]>
    //  public async requestAll(
    //    req: AccountLinesRequest,
    //  ): Promise<AccountLinesResponse[]>
    //  public async requestAll(
    //    req: AccountObjectsRequest,
    //  ): Promise<AccountObjectsResponse[]>
    //  public async requestAll(
    //    req: AccountOffersRequest,
    //  ): Promise<AccountOffersResponse[]>
    //  public async requestAll(req: AccountTxRequest): Promise<AccountTxResponse[]>
    //  public async requestAll(req: BookOffersRequest): Promise<BookOffersResponse[]>
    //  public async requestAll(req: LedgerDataRequest): Promise<LedgerDataResponse[]>
    //  /**
    //   * Makes multiple paged requests to the client to return a given number of
    //   * resources. Multiple paged requests will be made until the `limit`
    //   * number of resources is reached (if no `limit` is provided, a single request
    //   * will be made).
    //   *
    //   * If the command is unknown, an additional `collect` property is required to
    //   * know which response key contains the array of resources.
    //   *
    //   * NOTE: This command is used by existing methods and is not recommended for
    //   * general use. Instead, use rippled"s built-in pagination and make multiple
    //   * requests as needed.
    //   *
    //   * @param request - The initial request to send to the server.
    //   * @param collect - (Optional) the param to use to collect the array of resources (only needed if command is unknown).
    //   * @returns The array of all responses.
    //   * @throws ValidationError if there is no collection key (either from a known command or for the unknown command).
    //   */
    //  public async requestAll<T extends MarkerRequest, U extends MarkerResponse>(
    //    request: T,
    //    collect?: string,
    //  ): Promise<U[]> {
    //    /*
    //     * The data under collection is keyed based on the command. Fail if command
    //     * not recognized and collection key not provided.
    //     */
    //    const collectKey = collect ?? getCollectKeyFromCommand(request.command)
    //    if (!collectKey) {
    //      throw new ValidationError(`no collect key for command ${request.command}`)
    //    }
    //    /*
    //     * If limit is not provided, fetches all data over multiple requests.
    //     * NOTE: This may return much more than needed. Set limit when possible.
    //     */
    //    const countTo: number = request.limit == null ? Infinity : request.limit
    //    let count = 0
    //    let marker: unknown = request.marker
    //    let lastBatchLength: number
    //    const results: U[] = []
    //    do {
    //      const countRemaining = clamp(countTo - count, MIN_LIMIT, MAX_LIMIT)
    //      const repeatProps = {
    //        ...request,
    //        limit: countRemaining,
    //        marker,
    //      }
    //      // eslint-disable-next-line no-await-in-loop -- Necessary for this, it really has to wait
    //      const singleResponse = await this.connection.request(repeatProps)
    //      // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Should be true
    //      const singleResult = (singleResponse as U).result
    //      if (!(collectKey in singleResult)) {
    //        throw new XrplError(`${collectKey} not in result`)
    //      }
    //      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment -- Should be true
    //      const collectedData = singleResult[collectKey]
    //      marker = singleResult.marker
    //      // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Should be true
    //      results.push(singleResponse as U)
    //      // Make sure we handle when no data (not even an empty array) is returned.
    //      if (Array.isArray(collectedData)) {
    //        count += collectedData.length
    //        lastBatchLength = collectedData.length
    //      } else {
    //        lastBatchLength = 0
    //      }
    //    } while (Boolean(marker) && count < countTo && lastBatchLength !== 0)
    //    return results
    //  }

    /**
     * Tells the Client instance to connect to its rippled server.
     *
     * @returns A promise that resolves with a void value when a connection is established.
     * @category Network
     */
    public func connect() async throws -> EventLoopFuture<Any> {
        return try await self.connection.connect()
    }

    /**
     * Tells the Client instance to disconnect from it"s rippled server.
     *
     * @returns A promise that resolves with a void value when a connection is destroyed.
     * @category Network
     */
    public func disconnect() async -> EventLoopFuture<Any?> {
        /*
         * backwards compatibility: connection.disconnect() can return a number, but
         * this method returns nothing. SO we await but don"t return any result.
         */
        await self.connection.disconnect()
    }

    /**
     * Checks if the Client instance is connected to its rippled server.
     *
     * @returns Whether the client instance is connected.
     * @category Network
     */
    public func isConnected() -> Bool {
        return self.connection.isConnected()
    }

    //    /**
    //     * @category Core
    //     */
    //    public autofill = autofill
    //
    //    /**
    //     * @category Core
    //     */
    public func submit(transaction: Transaction, opts: SubmitOptions?) async throws -> EventLoopFuture<Any> {
        return try await XRPLSwift.submit(
            this: self,
            transaction: transaction,
            autofill: opts?.autofill,
            failHard: opts?.failHard,
            wallet: opts?.wallet
        )
    }
    //    /**
    //     * @category Core
    //     */
    //    public submitAndWait = submitAndWait
    //
    //    /**
    //     * @deprecated Use autofill instead, provided for users familiar with v1
    //     */
//    public func autofill() async throws -> Int {
//        return try await XRPLSwift.autofill(client: self)
//    }
    //    /**
    //     * @category Abstraction
    //     */
    public func getXrpBalance(address: String) async throws -> String {
        return try await XRPLSwift.getXrpBalance(this: self, address: address)
    }
    //    /**
    //     * @category Abstraction
    //     */
    //    public getBalances = getBalances
    //
    //    /**
    //     * @category Abstraction
    //     */
    //    public getOrderbook = getOrderbook
    //
    //    /**
    //     * @category Abstraction
    //     */
    public func getLedgerIndex() async throws -> Int {
        return try await XRPLSwift.getLedgerIndex(client: self)
    }
    //
    //    /**
    //     * @category Faucet
    //     */
    //    public fundWallet = fundWallet
}

extension String {
    var isValidWss: Bool {
        return range(of: "^[wW]{3}+.[a-zA-Z]{3,}+.[a-z]{2,}", options: .regularExpression) != nil
    }
}
