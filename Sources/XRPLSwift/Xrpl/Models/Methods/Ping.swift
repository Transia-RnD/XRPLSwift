//
//  Ping.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/ping.ts

import Foundation

/**
 The ping command returns an acknowledgement, so that clients can test the
 connection status and latency. Expects a response in the form of a {@link
 PingResponse}.
 */
public class PingRequest: BaseRequest {
    public init(
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil
    ) {
        super.init(id: id, command: "ping", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}

/**
 Response expected from a {@link PingRequest}.
 */
public class PingResponse: Codable {
    public var role: String?
    public var unlimited: Bool?

    enum CodingKeys: String, CodingKey {
        case role
        case unlimited
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        role = try values.decode(String.self, forKey: .role)
        unlimited = try values.decode(Bool.self, forKey: .unlimited)
        //        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as? [String: AnyObject] ?? [:]
    }
}
