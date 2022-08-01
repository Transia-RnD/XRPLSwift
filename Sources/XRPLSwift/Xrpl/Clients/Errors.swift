//
//  Errors.swift
//  
//
//  Created by Denis Angell on 11/21/20.
//

import Foundation

public enum XrplError: Error {
    case noPromise(_ desc: String)
    public var localizedDescription: String {
        switch self {
        case .noPromise(let desc):
            return desc
        }
    }
}

public enum RippleError: Error {
    case transactionSerializationError
    case connectionError
    case dataError
    case walletError
    case inputError(desc:String)
    case nodeError(desc:String)
    case processingError(desc:String)
    case keystoreError(err: AbstractRippleKeystoreError)
    case generalError(err: Error)
    case unknownError
    
    public var errorDescription: String {
        switch self {
            
        case .transactionSerializationError:
            return "Transaction Serialization Error"
        case .connectionError:
            return "Connection Error"
        case .dataError:
            return "Data Error"
        case .walletError:
            return "Wallet Error"
        case .inputError(let desc):
            return desc
        case .nodeError(let desc):
            return desc
        case .processingError(let desc):
            return desc
        case .keystoreError(let err):
            return err.localizedDescription
        case .generalError(let err):
            return err.localizedDescription
        case .unknownError:
            return "Unknown Error"
        }
    }
}
