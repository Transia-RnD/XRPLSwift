//
//  File.swift
//  
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/client/index.ts

import Foundation
import NIO

public class ClientOptions: ConnectionUserOptions {
    public var feeCushion: Int?
    public var maxFeeXRP: String?
//    public var proxy: String?
//    public var timeout: Timer?
    
    init(
        feeCushion: Int? = nil,
        maxFeeXRP: String? = nil,
        proxy: String? = nil,
        timeout: Timer? = nil
    ) {
        super.init()
        self.feeCushion = feeCushion
        self.maxFeeXRP = maxFeeXRP
        self.proxy = proxy
        self.timeout = timeout!
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
    switch (command) {
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
    var id: Int?
    var command: String?
    var apiVersion: Int?
    public var limit: Int?
    public var marker: String?
}

struct MarkerResult {
    private var marker: String?
}

class MarkerResponse: BaseResponse {
    public var _result: MarkerResult?
}

private let DEFAULT_FEE_CUSHION: Double = 1.2
private let DEFAULT_MAX_FEE_XRP: String = "2"

private let MIN_LIMIT: Int = 10
private let MAX_LIMIT: Int = 400

private let NORMAL_DISCONNECT_CODE: Int = 1000

class EventEmitter {
    
}

/**
 * Client for interacting with rippled servers.
 *
 * @category Clients
 */
class XrplClient: EventEmitter {
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
    public init(server: String, options: ClientOptions? = nil) {
        //    super()
        //    if (typeof server !== "string" || !/wss?(?:\+unix)?:\/\//u.exec(server)) {
        //      throw new ValidationError(
        //        "server URI must start with `wss://`, `ws://`, `wss+unix://`, or `ws+unix://`.",
        //      )
        //    }
        
        self.feeCushion = options?.feeCushion ?? Int(DEFAULT_FEE_CUSHION)
        self.maxFeeXRP = options?.maxFeeXRP ?? DEFAULT_MAX_FEE_XRP
        
        self.connection = Connection(url: server, options: options)
        
//        self.connection.on("error", (errorCode, errorMessage, data) => {
//            self.emit("error", errorCode, errorMessage, data)
//        })
        
//        self.connection.on("connected", () => {
//            self.emit("connected")
//        })
        
//        self.connection.on("disconnected", (code: Int) => {
//            let finalCode = code
//            /*
//             * 4000: Connection uses a 4000 code internally to indicate a manual disconnect/close
//             * Since 4000 is a normal disconnect reason, we convert this to the standard exit code 1000
//             */
//            if (finalCode === INTENTIONAL_DISCONNECT_CODE) {
//                finalCode = NORMAL_DISCONNECT_CODE
//            }
//            self.emit("disconnected", finalCode)
//        })
//
//        self.connection.on("ledgerClosed", (ledger) => {
//            self.emit("ledgerClosed", ledger)
//        })
//
//        self.connection.on("transaction", (tx) => {
//            // mutates `tx` to add warnings
//            handleStreamPartialPayment(tx, self.connection.trace)
//            self.emit("transaction", tx)
//        })
//
//        self.connection.on("validationReceived", (validation) => {
//            self.emit("validationReceived", validation)
//        })
//
//        self.connection.on("manifestReceived", (manifest) => {
//            self.emit("manifestReceived", manifest)
//        })
//
//        self.connection.on("peerStatusChange", (status) => {
//            self.emit("peerStatusChange", status)
//        })
//
//        self.connection.on("consensusPhase", (consensus) => {
//            self.emit("consensusPhase", consensus)
//        })
//
//        self.connection.on("path_find", (path) => {
//            self.emit("path_find", path)
//        })
    }
    
    /**
     * Get the url that the client is connected to.
     *
     * @returns The URL of the server this client is connected to.
     * @category Network
     */
    public func url() -> String {
        return self.connection.getUrl()
    }
    //
    //  /**
    //   * @category Network
    //   */
    //  public async request(
    //    r: AccountChannelsRequest,
    //  ): Promise<AccountChannelsResponse>
    //  public async request(
    //    r: AccountCurrenciesRequest,
    //  ): Promise<AccountCurrenciesResponse>
    //  public async request(r: AccountInfoRequest): Promise<AccountInfoResponse>
    //  public async request(r: AccountLinesRequest): Promise<AccountLinesResponse>
    //  public async request(r: AccountNFTsRequest): Promise<AccountNFTsResponse>
    //  public async request(
    //    r: AccountObjectsRequest,
    //  ): Promise<AccountObjectsResponse>
    //  public async request(r: AccountOffersRequest): Promise<AccountOffersResponse>
    //  public async request(r: AccountTxRequest): Promise<AccountTxResponse>
    //  public async request(r: BookOffersRequest): Promise<BookOffersResponse>
    //  public async request(r: ChannelVerifyRequest): Promise<ChannelVerifyResponse>
    //  public async request(
    //    r: DepositAuthorizedRequest,
    //  ): Promise<DepositAuthorizedResponse>
    //  public async request(r: FeeRequest): Promise<FeeResponse>
    //  public async request(
    //    r: GatewayBalancesRequest,
    //  ): Promise<GatewayBalancesResponse>
    //  public async request(r: LedgerRequest): Promise<LedgerResponse>
    //  public async request(r: LedgerClosedRequest): Promise<LedgerClosedResponse>
    //  public async request(r: LedgerCurrentRequest): Promise<LedgerCurrentResponse>
    //  public async request(r: LedgerDataRequest): Promise<LedgerDataResponse>
    //  public async request(r: LedgerEntryRequest): Promise<LedgerEntryResponse>
    //  public async request(r: ManifestRequest): Promise<ManifestResponse>
    //  public async request(r: NFTBuyOffersRequest): Promise<NFTBuyOffersResponse>
    //  public async request(r: NFTSellOffersRequest): Promise<NFTSellOffersResponse>
    //  public async request(r: NoRippleCheckRequest): Promise<NoRippleCheckResponse>
    //  public async request(r: PathFindRequest): Promise<PathFindResponse>
    //  public async request(r: PingRequest): Promise<PingResponse>
    //  public async request(r: RandomRequest): Promise<RandomResponse>
    //  public async request(
    //    r: RipplePathFindRequest,
    //  ): Promise<RipplePathFindResponse>
    //  public async request(r: ServerInfoRequest): Promise<ServerInfoResponse>
    //  public async request(r: ServerStateRequest): Promise<ServerStateResponse>
    //  public async request(r: SubmitRequest): Promise<SubmitResponse>
    //  public async request(
    //    r: SubmitMultisignedRequest,
    //  ): Promise<SubmitMultisignedResponse>
    //  public request(r: SubscribeRequest): Promise<SubscribeResponse>
    //  public request(r: UnsubscribeRequest): Promise<UnsubscribeResponse>
    //  public async request(
    //    r: TransactionEntryRequest,
    //  ): Promise<TransactionEntryResponse>
    //  public async request(r: TxRequest): Promise<TxResponse>
    //  public async request<R extends BaseRequest, T extends BaseResponse>(
    //    r: R,
    //  ): Promise<T>
    //  /**
    //   * Makes a request to the client with the given command and
    //   * additional request body parameters.
    //   *
    //   * @param req - Request to send to the server.
    //   * @returns The response from the server.
    //   * @category Network
    //   */
    //  public async request<R extends Request, T extends Response>(
    //    req: R,
    //  ): Promise<T> {
    //    // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Necessary for overloading
    //    const response = (await this.connection.request({
    //      ...req,
    //      account: req.account
    //        ? // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Must be string
    //          ensureClassicAddress(req.account as string)
    //        : undefined,
    //    })) as T
    //
    //    // mutates `response` to add warnings
    //    handlePartialPayment(req.command, response)
    //
    //    return response
    //  }
    //
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
    public func connect() async -> EventLoopPromise<Void> {
        return await self.connection.connect()
    }
    
    /**
     * Tells the Client instance to disconnect from it"s rippled server.
     *
     * @returns A promise that resolves with a void value when a connection is destroyed.
     * @category Network
     */
//    public func disconnect() async -> EventLoopFuture<Void> {
//        /*
//         * backwards compatibility: connection.disconnect() can return a number, but
//         * this method returns nothing. SO we await but don"t return any result.
//         */
//        await self.connection.disconnect()
//    }
    
    /**
     * Checks if the Client instance is connected to its rippled server.
     *
     * @returns Whether the client instance is connected.
     * @category Network
     */
    public func isConnected() -> Bool {
        return self.connection.isConnected()
    }
    
    //  /**
    //   * @category Core
    //   */
    //  public autofill = autofill
    //
    //  /**
    //   * @category Core
    //   */
    //  public submit = submit
    //  /**
    //   * @category Core
    //   */
    //  public submitAndWait = submitAndWait
    //
    //  /**
    //   * @deprecated Use autofill instead, provided for users familiar with v1
    //   */
    //  public prepareTransaction = autofill
    //
    //  /**
    //   * @category Abstraction
    //   */
    //  public getXrpBalance = getXrpBalance
    //
    //  /**
    //   * @category Abstraction
    //   */
    //  public getBalances = getBalances
    //
    //  /**
    //   * @category Abstraction
    //   */
    //  public getOrderbook = getOrderbook
    //
    //  /**
    //   * @category Abstraction
    //   */
    //  public getLedgerIndex = getLedgerIndex
    //
    //  /**
    //   * @category Faucet
    //   */
    //  public fundWallet = fundWallet
}
