//
//  Entropy.swift
//  XRPLSwift
//
//  Created by Mitch Lang on 5/23/19.
//

import Foundation

enum EntropyError: Error {
    case invalidBufferSize
}

public class Entropy {
    private(set) var bytes: [UInt8]!

    init() {
        var copyBytes = [UInt8](repeating: 0, count: 16)
        copyBytes = try! URandom().bytes(count: 16)
        self.bytes = copyBytes
    }

    init(bytes: [UInt8]) {
        self.bytes = bytes
    }
}
