// AngleCodable

// Created by Raymond Shelton on 9/22/24.

// This extension allows the Angle type to conform to Codable, enabling easy encoding and decoding.

import SwiftUI
extension Angle: Codable {
    enum CodingKeys: CodingKey {
        case degrees
    }

    // Initializes an Angle from a decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let degrees = try container.decode(Double.self, forKey: .degrees)
        self.init(degrees: degrees)
    }

    // Encodes an Angle to an encoder
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(degrees, forKey: .degrees)
    }
}
