//
//  BinaryExceptions.swift
//  
//
//  Created by Denis Angell on 7/24/22.
//

import Foundation

public enum BinaryCodecExceptions: Error {
    case invalidAddress
    case valueError
    case unsupportedAddress
    case checksumFails
    case unknownError(error: String)
}
