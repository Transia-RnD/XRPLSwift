//
//  ChannelClaim.swift
//  
//
//  Created by Denis Angell on 5/25/22.
//

import Foundation

public struct ChannelClaim: Codable {
    public var amount: Int64
    public var channel: String

    public init(amount: Int64, channel: String) {
        self.amount = amount
        self.channel = channel
    }
}

public struct ChannelSignature: Codable {
    public var dataHex: String
    public var dataBytes: [UInt8] = []
    public var sigHex: String
    public var sigBytes: [UInt8] = []
    public var pubKey: String

    public init(
        pubKey: String,
        sigHex: String,
        dataHex: String
    ) {
        self.pubKey = pubKey
        self.sigHex = sigHex
        self.sigBytes = sigHex.hexToBytes
        self.dataHex = dataHex
        self.dataBytes = dataHex.hexToBytes
    }
}
