//
//  File.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/manifest.ts

import Foundation

/**
 * The `manifest` method reports the current "manifest" information for a given
 * validator public key. The "manifest" is the public portion of that
 * validator's configured token. Expects a response in the form of a {@link
 * ManifestResponse}.
 *
 * @example
 * ```swift
 * let manifest: ManifestRequest(
 *  publicKey: "nHUFE9prPXPrHcG3SkwP1UzAQbSphqyQkQK9ATXLZsfkezhhda3p"
 * )
 * ```
 *
 * @category Requests
 */
public class ManifestRequest: BaseRequest {
    //    let command: String = "manifest"
    /**
     * The base58-encoded public key of the validator to look up. This can be the
     * master public key or ephemeral public key.
     */
    public let publicKey: String

    enum CodingKeys: String, CodingKey {
        case publicKey = "public_key"
    }

    public init(
        // Required
        publicKey: String,
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil
    ) {
        // Required
        self.publicKey = publicKey
        super.init(id: id, command: "manifest", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(ManifestRequest.self, from: data)
        // Required
        self.publicKey = decoded.publicKey
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicKey = try values.decode(String.self, forKey: .publicKey)
        try super.init(from: decoder)
    }
}

public class ManifestDetails: Codable {
    public let domain: String
    public let ephemeralKey: String
    public let masterKey: String
    public let seq: Int

    enum CodingKeys: String, CodingKey {
        case domain = "domain"
        case ephemeralKey = "ephemeral_key"
        case masterKey = "master_key"
        case seq = "seq"
    }
}

/**
 * Response expected from a {@link ManifestRequest}.
 *
 * @category Responses
 */
public class ManifestResponse: Codable {
    /** The public_key from the request. */
    public let requested: String
    /**
     * The data contained in this manifest. Omitted if the server does not have
     *  A manifest for the public_key from the request.
     */
    public let details: ManifestDetails?
    /**
     * The full manifest data in base64 format. This data is serialized to
     * binary before being base64-encoded. Omitted if the server does not have a
     * manifest for the public_key from the request.
     */
    public let manifest: String?

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        requested = try values.decode(String.self, forKey: .requested)
        details = try values.decodeIfPresent(ManifestDetails.self, forKey: .details)
        manifest = try values.decodeIfPresent(String.self, forKey: .manifest)
        //        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
