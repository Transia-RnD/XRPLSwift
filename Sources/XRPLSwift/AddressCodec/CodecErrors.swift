//
//  CodecErrors.swift
//  
//
//  Created by Denis Angell on 7/2/22.
//

import Foundation

public enum XrplCodecError: Error {
    case invalidAddress
    case unsupportedAddress
    case checksumFails
    case unknownError(error: String)
}

public enum AddressCodecError: Error {
    case invalidAddress
    case unsupportedAddress
    case checksumFails
    case unknownError(error: String)
}
