//
//  Random.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/random.ts

import Foundation


/**
 * The random command provides a random number to be used as a source of
 * entropy for random number generation by clients. Expects a response in the
 * form of a {@link RandomResponse}.
 *
 * @category Requests
 */
public class RandomRequest: BaseRequest {
//    let command: String = "random"
    public init(
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil
    ) {
        super.init(id: id, command: "random", apiVersion: apiVersion)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}

/**
 * Response expected from a {@link RandomRequest}.
 *
 * @category Responses
 */
public class RandomResponse: Codable {
    public let random: String
    
    enum CodingKeys: String, CodingKey {
        case random = "random"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        random = try values.decode(String.self, forKey: .random)
//        try super.init(from: decoder)
    }
    
}
