//
//  BinaryCodecErrors.swift
//
//
//  Created by Denis Angell on 7/24/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/exceptions.py

import Foundation

public enum BinaryCodecErrors: Error {
    case invalidAddress
    case valueError
    case unsupportedAddress
    case checksumFails
    case unknownError(_ error: String)
}
