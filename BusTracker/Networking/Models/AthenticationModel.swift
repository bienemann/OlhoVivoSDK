//
//  AthenticationModel.swift
//  BusTracker
//
//  Created by Allan Martins on 06/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
struct AuthenticationResponse: Hashable {
    public let raw: Bool
    public init(_ raw: Bool) {
        self.raw = raw
    }
    
    public var hashValue: Int {
        return raw.hashValue
    }
    
    public static func ==(lhs: AuthenticationResponse, rhs: AuthenticationResponse) -> Bool {
        return lhs.raw == rhs.raw
    }
}

extension AuthenticationResponse: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(Bool.self)
        self.init(raw)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(raw)
    }

}
