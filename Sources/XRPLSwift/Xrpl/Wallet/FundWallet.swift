////
////  File.swift
////
////
////  Created by Denis Angell on 8/6/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/Wallet/fundWallet.ts
//
// import Foundation
//
// public struct FaucetAccount: Codable {
//    let xAddress: String
//    let classicAddress: String?
//    let secret: String
// }
//
// public struct FaucetWallet: Codable {
//    let account: FaucetAccount
//    let amount: Double
//    let balance: Double
// }
//
// public struct Funded {
//    let wallet: Wallet
//    let balance: Double
// }
//
// enum FaucetNetwork: String {
//    case testnet = "faucet.altnet.rippletest.net"
//    case devnet = "faucet.devnet.rippletest.net"
//    case nftDevnet = "faucet-nft.ripple.com"
// }
//
//
// public class FundWallet {
//
//    // Interval to check an account balance
//    // swiftlint:disable:next identifier_name
//    let INTERVAL_SECONDS: Int = 1
//    // Maximum attempts to retrieve a balance
//    // swiftlint:disable:next identifier_name
//    let MAX_ATTEMPTS: Int = 20
//
//    var timer: Timer? = nil
//
//    /**
//     * Generates a random wallet with some amount of XRP (usually 1000 XRP).
//     *
//     * @example
//     * ```typescript
//     * const api = new xrpl.Client("wss://s.altnet.rippletest.net:51233")
//     * await api.connect()
//     * const { wallet, balance } = await api.fundWallet()
//     * ```
//     *
//     * @param this - Client.
//     * @param wallet - An existing XRPL Wallet to fund. If undefined or null, a new Wallet will be created.
//     * @param options - See below.
//     * @param options.faucetHost - A custom host for a faucet server. On devnet and
//     * testnet, `fundWallet` will attempt to determine the correct server
//     * automatically. In other environments, or if you would like to customize the
//     * faucet host in devnet or testnet, you should provide the host using this
//     * option.
//     * @returns A Wallet on the Testnet or Devnet that contains some amount of XRP,
//     * and that wallet"s balance in XRP.
//     * @throws When either Client isn"t connected or unable to fund wallet address.
//     */
//    func fundWallet(
//        this: XrplClient,
//        wallet: Wallet? = nil,
//        faucetHost: String
//    ) async throws -> Future<Funded> {
//        if !this.isConnected() {
//            throw ValidationError.validation("Client not connected, cannot call faucet")
//        }
//
//        // Generate a new Wallet if no existing Wallet is provided or its address is invalid to fund
//        let walletToFund = wallet != nil && XrplCodec.isValidClassicAddress(classicAddress: wallet!.classicAddress) ? wallet : Wallet.generate()
//
//        // Create the POST request body
//        let params = [
//            "destination": walletToFund!.classicAddress
//        ] as [String : Any]
//        let postBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
//
//        var startingBalance: Double = 0.0
//        do {
//            startingBalance = Double(try await this.getXrpBalance(address: walletToFund!.classicAddress))!
//        } catch {
//            /* startingBalance remains "0" */
//        }
//
//        // Options to pass to https.request
//        let httpOptions: URLRequest = getHTTPOptions(client: this, postBody: postBody.bytes, hostname: faucetHost)
//
//        return returnPromise(
//            options: httpOptions,
//            client: this,
//            startingBalance: startingBalance,
//            walletToFund: walletToFund!,
//            postBody: postBody
//        )
//    }
//
//    // eslint-disable-next-line max-params -- Helper function created for organizational purposes
//    func returnPromise(
//        options: URLRequest,
//        client: XrplClient,
//        startingBalance: Double,
//        walletToFund: Wallet,
//        postBody: Data
//    ) -> Future<Funded> {
//        return Future() { promise in
//            // Load user from server.
//            promise(.success(user))  // or promise(.failure(error))
//            // Handle Address to String Better
//
//            let session = URLSession.shared
//            session.dataTask(with: options, completionHandler: { data, response, error in
//                guard error == nil else {
//                    DispatchQueue.main.async {
//                        print(error!.localizedDescription)
//                        promise(.failure(error))
//                    }
//                    return
//                }
//                guard let data = data else {
//                    promise(.failure(nil))
//                    return
//                }
//                if let httpResponse = response as? HTTPURLResponse {
//                    if httpResponse.statusCode == 200 {
//                        do {
//                            DispatchQueue.main.async {
//                                print("ON END")
//    //                            onEnd(
//    //                                response: response!,
//    //                                chunks: data,
//    //                                client: client,
//    //                                startingBalance: startingBalance,
//    //                                walletToFund: walletToFund
//    //                            )
//                            }
//                        } catch let error {
//                            DispatchQueue.main.async {
//                                promise(.failure(error))
//                            }
//                        }
//                    } else {
//                        do {
//                            let response = try JSONDecoder().decode(FaucetWallet.self, from: data)
//    //                        DispatchQueue.main.async {
//    //                            let error: NSError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: response.statusText])
//    //                            completion(nil, error)
//    //                        }
//                        } catch let error {
//                            DispatchQueue.main.async {
//                                promise(.failure(error))
//                            }
//                        }
//                    }
//                }
//            }).resume()
//        }
//    }
//
//    func getHTTPOptions(
//        client: XrplClient,
//        postBody: [UInt8],
//        hostname: String? = nil
//    ) -> URLRequest {
//
//        let url = try! URL(string: hostname != nil ? hostname! : getFaucetHost(client)!.rawValue)
//        var request = URLRequest(url: url!)
//        request.httpMethod = "POST"
//        request.httpBody = Data(postBody)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        return request
//    }
//
//    // eslint-disable-next-line max-params -- Helper function created for organizational purposes
//    func onEnd(
//        response: HTTPURLResponse,
//        chunks: Data,
//        client: XrplClient,
//        startingBalance: Double,
//        walletToFund: Wallet
//    //    resolve: (response: { wallet: Wallet; balance: number }) => void,
//    //    reject: (err: ErrorConstructor | Error | unknown) => void,
//    ) async -> Void {
//        let body = try! JSONDecoder().decode(FaucetWallet.self, from: chunks)
//        print(body)
//        if let headers = response.allHeaderFields as? [String: AnyObject], let contentType = headers["content-type"] as? String, contentType.starts(with: "application/json") {
//            await processSuccessfulResponse(
//                client: client,
//                body: body,
//                startingBalance: startingBalance,
//                walletToFund: walletToFund
//    //            resolve,
//    //            reject,
//            )
//        } else {
//            print("Content type is not")
//    //        reject(
//    //            new XRPLFaucetError("Content type is not \`application/json\`: ${JSON.stringify({
//    //                statusCode: response.statusCode,
//    //                contentType: response.headers["content-type"],
//    //                    body,
//    //                })}`,
//    //            )
//    //        )
//        }
//    }
//
//    // eslint-disable-next-line max-params, max-lines-per-function -- Only used as a helper function, lines inc due to added balance.
//    func processSuccessfulResponse(
//        client: XrplClient,
//        body: FaucetWallet,
//        startingBalance: Double,
//        walletToFund: Wallet
//    //    resolve: (response: { wallet: Wallet; balance: number }) => void,
//    //    reject: (err: ErrorConstructor | Error | unknown) => void,
//    ) async -> Void {
//        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment -- We know this is safe and correct
//        let faucetWallet = body
//        let classicAddress = faucetWallet.account.classicAddress
//
//        if classicAddress == nil {
//            print("The faucet account is undefined")
//    //        reject(XRPLFaucetError("The faucet account is undefined"))
//            return
//        }
//        do {
//            // Check at regular interval if the address is enabled on the XRPL and funded
//            let updatedBalance = await getUpdatedBalance(
//                client: client,
//                address: classicAddress!,
//                originalBalance: startingBalance
//            )
//
//            if (updatedBalance > startingBalance) {
//                print("updatedBalance > startingBalance")
//    //            resolve({
//    //                wallet: walletToFund,
//    //                balance: await getUpdatedBalance(
//    //                    client,
//    //                    walletToFund.classicAddress,
//    //                    startingBalance,
//    //                ),
//    //            })
//            } else {
//                print("REJECT")
//    //            reject(new XRPLFaucetError("Unable to fund address with faucet after waiting ${INTERVAL_SECONDS * MAX_ATTEMPTS} seconds"))
//            }
//        } catch {
//            print(error)
//    //        if (err instanceof Error) {
//    //            reject(new XRPLFaucetError(err.message))
//    //        }
//    //        reject(err)
//        }
//    }
//
//    /**
//     * Check at regular interval if the address is enabled on the XRPL and funded.
//     *
//     * @param client - Client.
//     * @param address - The account address to check.
//     * @param originalBalance - The initial balance before the funding.
//     * @returns A Promise boolean.
//     */
//
//    // Timer expects @objc selector
//    @objc func eventWith(timer: Timer!) {
//        let info = timer.userInfo as Any
//        print(info)
//    }
//    func getUpdatedBalance(
//        client: XrplClient,
//        address: String,
//        originalBalance: Double
//    ) async -> Double {
//        timer = Timer.scheduledTimer(
//            timeInterval: 5.0,
//            target: self,
//            selector: #selector(eventWith(timer:)),
//            userInfo: [ "foo" : "bar" ],
//            repeats: true
//        )
//    //    return new Promise((resolve, reject) => {
//    //        let attempts = MAX_ATTEMPTS
//    //        // eslint-disable-next-line @typescript-eslint/no-misused-promises -- Not actually misused here, different resolve
//    //        const interval = setInterval(async () => {
//    //            if (attempts < 0) {
//    //                clearInterval(interval)
//    //                resolve(originalBalance)
//    //            } else {
//    //                attempts -= 1
//    //            }
//    //
//    //            try {
//    //                let newBalance
//    //                try {
//    //                    newBalance = Number(await client.getXrpBalance(address))
//    //                } catch {
//    //                    /* newBalance remains undefined */
//    //                }
//    //
//    //                if (newBalance > originalBalance) {
//    //                    print("CLEAR INTERVAL")
//    //                    print("RESOLVE")
//    ////                    clearInterval(interval)
//    ////                    resolve(newBalance)
//    //                }
//    //            } catch (err) {
//    //                print("CLEAR INTERVAL")
//    //                print("RESOLVE")
//    ////                clearInterval(interval)
//    ////                if (err instanceof Error) {
//    ////                    reject(throw XRPLFaucetError("Unable to check if the address \(address) balance has increased. Error: \(err.message)"))
//    ////                }
//    ////                reject(err)
//    //            }
//    //        }, INTERVAL_SECONDS * 1000)
//    //    })
//    }
//
//    /**
//     * Get the faucet host based on the Client connection.
//     *
//     * @param client - Client.
//     * @returns A {@link FaucetNetwork}.
//     * @throws When the client url is not on altnet or devnet.
//     */
//    func getFaucetHost(_ client: XrplClient) throws -> FaucetNetwork? {
//        let connectionUrl: String = client.url()
//        connectionUrl.contains(where: { String($0) == "altnet" })
//        // "altnet" for Ripple Testnet server and "testnet" for XRPL Labs Testnet server
//        if connectionUrl.contains(where: { String($0) == "altnet" }) || connectionUrl.contains(where: { String($0) == "testnet" }) {
//            return FaucetNetwork.testnet
//        }
//
//        if connectionUrl.contains(where: { String($0) == "devnet" }) {
//            return FaucetNetwork.devnet
//        }
//
//        if connectionUrl.contains(where: { String($0) == "xls20-sandbox" }) {
//            return FaucetNetwork.nftDevnet
//        }
//
//        throw XRPLFaucetError.unknown("Faucet URL is not defined or inferrable.")
//    }
// }
