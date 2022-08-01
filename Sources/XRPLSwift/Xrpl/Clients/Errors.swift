//
//  Errors.swift
//  
//
//  Created by Denis Angell on 11/21/20.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/errors.ts

import Foundation

public enum XrplError: Error {
    case validation(_ desc: String)
    case connection(_ desc: String)
    case noPromise(_ desc: String = "")
    case timeout(_ desc: String = "The request has timed out")
    case unknown(_ desc: String = "Unknown Error")
    case invalidFormat(_ desc: String)
    case responseError(_ desc: String)
    
    public var localizedDescription: String {
        switch self {
        case .validation(let desc):
            return desc
        case .connection(let desc):
            return desc
        case .noPromise(let desc):
            return desc
        case .timeout(let desc):
            return desc
        case .unknown(let desc):
            return desc
        case .invalidFormat(let desc):
            return desc
        case .responseError(let desc):
            return desc
        }
    }
}


///**
// * Error thrown when rippled responds with an error.
// *
// * @category Errors
// */
//class RippledError: rXrplError {}
//
///**
// * Error thrown when xrpl.js cannot specify error type.
// *
// * @category Errors
// */
//class UnexpectedError: rXrplError {}
//
///**
// * Error thrown when xrpl.js has an error with connection to rippled.
// *
// * @category Errors
// */
//class ConnectionError: rXrplError {}
//
///**
// * Error thrown when xrpl.js is not connected to rippled server.
// *
// * @category Errors
// */
//class NotConnectedError: ConnectionError {}
//
///**
// * Error thrown when xrpl.js has disconnected from rippled server.
// *
// * @category Errors
// */
//class DisconnectedError: ConnectionError {}
//
///**
// * Error thrown when rippled is not initialized.
// *
// * @category Errors
// */
//class RippledNotInitializedError: ConnectionError {}
//
///**
// * Error thrown when xrpl.js times out.
// *
// * @category Errors
// */
//class TimeoutError: ConnectionError {}
//
///**
// * Error thrown when xrpl.js sees a response in the wrong format.
// *
// * @category Errors
// */
//class ResponseFormatError: ConnectionError {}
//
///**
// * Error thrown when xrpl.js sees a malformed transaction.
// *
// * @category Errors
// */
//class ValidationError: rXrplError {}
//
///**
// * Error thrown when a client cannot generate a wallet from the testnet/devnet
// * faucets, or when the client cannot infer the faucet URL (i.e. when the Client
// * is connected to mainnet).
// *
// * @category Errors
// */
//class XRPLFaucetError: rXrplError {}
//
///**
// * Error thrown when xrpl.js cannot retrieve a transaction, ledger, account, etc.
// * From rippled.
// *
// * @category Errors
// */
//class NotFoundError: rXrplError {
//    /**
//     * Construct an XrplError.
//     *
//     * @param message - The error message. Defaults to "Not found".
//     */
//    public init(message: String = "Not found") {
//        self.message = message
//    }
//}
