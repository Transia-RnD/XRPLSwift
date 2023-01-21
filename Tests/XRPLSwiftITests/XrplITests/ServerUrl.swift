//
//  File.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/serverUrl.test.ts

import Foundation

public struct ServerUrl {
    public static let HOST: String  = ProcessInfo.processInfo.environment["HOST"] ?? "0.0.0.0"
    public static let PORT: String = ProcessInfo.processInfo.environment["PORT"] ?? "6006"
    public static let serverUrl: String = "ws://\(ServerUrl.HOST):\(ServerUrl.PORT)"
}
