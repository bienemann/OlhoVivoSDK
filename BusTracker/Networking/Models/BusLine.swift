//
//  BusLine.swift
//  BusTracker
//
//  Created by Allan Martins on 07/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation


struct BusLine: Decodable {
    
    var lineID: Int
    var loops: Bool
    var lineNumber: String
    var lineNumberModifier: Int
    var direction: Direction
    var outboundName: String
    var inboundName: String
    
    private enum CodingKeys: String, CodingKey {
        case lineID = "cl"
        case loops = "lc"
        case lineNumber = "lt"
        case lineNumberModifier = "tl"
        case direction = "sl"
        case outboundName = "tp"
        case inboundName = "ts"
    }
    
    enum Direction: Int {
        case outbound = 1
        case inbound = 2
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        lineID = try values.decode(Int.self, forKey: .lineID)
        loops = try values.decode(Bool.self, forKey: .loops)
        lineNumber = try values.decode(String.self, forKey: .lineNumber)
        lineNumberModifier = try values.decode(Int.self, forKey: .lineNumberModifier)
        outboundName = try values.decode(String.self, forKey: .outboundName)
        inboundName = try values.decode(String.self, forKey: .inboundName)
        
        guard let preDirection = Direction(rawValue: try values.decode(Int.self, forKey: .direction)) else {
            let errorContext = DecodingError.Context(codingPath: [CodingKeys.direction],
                                                     debugDescription: "Direction value should be 1 or 2, found neither")
            throw DecodingError.dataCorrupted(errorContext)
        }
        direction = preDirection
        
    }
    
}
