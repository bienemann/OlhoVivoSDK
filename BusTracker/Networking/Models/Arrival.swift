//
//  Arrival.swift
//  BusTracker
//
//  Created by Allan Martins on 15/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

struct ArrivalWrapper_Specific: Decodable {
    
    var stop: BusStop
    
    private enum CodingKeys: String, CodingKey {
        case stop = "p"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stop = try values.decode(BusStop.self, forKey: .stop)
    }
}

struct ArrivalWrapper_Line: Decodable {
    
    var stops: [BusStop]
    
    private enum CodingKeys: String, CodingKey {
        case stops = "ps"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stops = try values.decode([BusStop].self, forKey: .stops)
    }
}
