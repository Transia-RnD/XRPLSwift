//
//  AddressCodecErrors.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

import Foundation

/// Throws the  AddressCodecError
public enum AddressCodecError: Error {
    /// Invalid Address.
    case invalidAddress
    /// Value Error.
    case valueError
    /// Unsupported Address.
    case unsupportedAddress
    /// Invalid Payload Length.
    /// - Parameter error: String error message
    case invalidLength(error: String)
    /// /Unexpected Payload Length.
    /// - Parameter error: String error message
    case unexpectedPayloadLength(error: String)
    /// Invalid Type.
    /// - Parameter error: String error message
    case invalidType(error: String)
    /// Invalid Prefix.
    /// - Parameter error: String error message
    case invalidPrefix(error: String = "Provided prefix is incorrect")
    /// Invalid Checksum.
    /// - Parameter error: String error message
    case invalidCheckSum(error: String = "Calculated checksum was invalid")
    /// Invalid Seed Encoding Algorithm.
    /// - Parameter error: String error message
    case seedError(error: String = "Invalid seed; could not determine encoding algorithm")
}
