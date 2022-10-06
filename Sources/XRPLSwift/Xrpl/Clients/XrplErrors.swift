//
//  XrplError.swift
//
//
//  Created by Denis Angell on 11/21/20.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/errors.ts

import Foundation

public struct XrplError: Error {
    //    var name: String?
    var message: String?
    var data: Data?
    //    var timeout: Timer?

    init(_ message: String?, _ data: Data? = nil) {
        //        self.name = self.name ?? "Error"
        if let message = message {
            self.message = message
        }
        self.data = data
        //        if Error.captureStackTrace != nil {
        //            Error.captureStackTrace(self, self.constructor)
        //        }
    }
}

/**
 * Error thrown when rippled responds with an error.
 *
 * @category Errors
 */
typealias RippledError = XrplError

/**
 * Error thrown when xrpl.js cannot specify error type.
 *
 * @category Errors
 */
typealias UnexpectedError = XrplError

/**
 * Error thrown when xrpl.js has an error with connection to rippled.
 *
 * @category Errors
 */
typealias ConnectionError = XrplError

/**
 * Error thrown when xrpl.js is not connected to rippled server.
 *
 * @category Errors
 */
typealias NotConnectedError = ConnectionError

/**
 * Error thrown when xrpl.js has disconnected from rippled server.
 *
 * @category Errors
 */
typealias DisconnectedError = ConnectionError

/**
 * Error thrown when rippled is not initialized.
 *
 * @category Errors
 */
typealias RippledNotInitializedError = ConnectionError

/**
 * Error thrown when xrpl.js times out.
 *
 * @category Errors
 */
typealias TimeoutError = ConnectionError

/**
 * Error thrown when xrpl.js sees a response in the wrong format.
 *
 * @category Errors
 */
typealias ResponseFormatError = ConnectionError

/**
 * Error thrown when xrpl.js sees a malformed transaction.
 *
 * @category Errors
 */
typealias ValidationError = XrplError

/**
 * Error thrown when a client cannot generate a wallet from the testnet/devnet
 * faucets, or when the client cannot infer the faucet URL (i.e. when the Client
 * is connected to mainnet).
 *
 * @category Errors
 */
typealias XRPLFaucetError = XrplError

/// **
// * Error thrown when xrpl.js cannot retrieve a transaction, ledger, account, etc.
// * From rippled.
// *
// * @category Errors
// */
// typealias NotFoundError = XrplError {
//    /**
//     * Construct an XrplError.
//     *
//     * @param message - The error message. Defaults to "Not found".
//     */
//    public init(_ message: String = "Not found") {
//        self.message = message
//    }
// }
