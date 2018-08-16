//
//  Corridor.swift
//  BusTracker
//
//  Created by Allan Martins on 14/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

public struct OVCorridor: Decodable {
    
    public var corridorID: Int
    public var name: String
    
    private enum CodingKeys: String, CodingKey {
        case corridorID = "cc"
        case name = "nc"
    }
    
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        corridorID = try values.decode(Int.self, forKey: .corridorID)
        name = try values.decode(String.self, forKey: .name)
        
    }
    
}
