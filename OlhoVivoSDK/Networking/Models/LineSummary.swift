//
//  LineDetails.swift
//  BusTracker
//
//  Created by Allan Martins on 14/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

public struct LineSummary: Decodable {
    
    public var lineID: Int
    public var direction: OVLine.Direction
    public var lineNumber: String
    public var nameDestination: String
    public var nameOrigin: String
    public var busQuantity: Int
    public var positionList: [OVPosition]
    
    private enum CodingKeys: String, CodingKey {
        case lineID = "cl"
        case direction = "sl"
        case lineNumber = "c"
        case nameDestination = "lt0"
        case nameOrigin = "lt1"
        case busQuantity = "qv"
        case positionList = "vs"
    }
    
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let preDirection = OVLine.Direction(rawValue: try values.decode(Int.self, forKey: .direction))
            else {
                let errorContext = DecodingError
                    .Context(codingPath: [CodingKeys.direction],
                             debugDescription: "Direction value should be 1 or 2, found neither"
                )
                throw DecodingError.dataCorrupted(errorContext)
        }
        
        direction = preDirection
        lineID = try values.decode(Int.self, forKey: .lineID)
        lineNumber = try values.decode(String.self, forKey: .lineNumber)
        nameDestination = try values.decode(String.self, forKey: .nameDestination)
        nameOrigin = try values.decode(String.self, forKey: .nameOrigin)
        busQuantity = try values.decode(Int.self, forKey: .busQuantity)
        positionList = try values.decode([OVPosition].self, forKey: .positionList)
        
    }
    
}
