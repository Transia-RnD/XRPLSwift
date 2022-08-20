//
//  Keypair.swift
//
//
//  Created by Denis Angell on 7/24/22.
//

import Foundation

public enum KeypairsErrors: Error {
    case unknownError(error: String)
    case algorithm(_ desc: String)
    case validation(_ desc: String)
    case invalidPrivateKey
    case unknown

    public var localizedDescription: String {
        switch self {
        case .unknownError(let desc):
            return desc
        case .algorithm(let desc):
            return desc
        case .validation(let desc):
            return desc
        case .invalidPrivateKey:
            return "invalidPrivateKey"
        case .unknown:
            return "Unkown Error Occured"
        }
    }
}
