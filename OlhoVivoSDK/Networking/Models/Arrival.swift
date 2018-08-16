//
//  Arrival.swift
//  BusTracker
//
//  Created by Allan Martins on 15/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

internal struct ArrivalWrapper_Specific: Decodable {
    
    var stop: OVStop
    
    private enum CodingKeys: String, CodingKey {
        case stop = "p"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stop = try values.decode(OVStop.self, forKey: .stop)
    }
}

internal struct ArrivalWrapper_Line: Decodable {
    
    var stops: [OVStop]
    
    private enum CodingKeys: String, CodingKey {
        case stops = "ps"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stops = try values.decode([OVStop].self, forKey: .stops)
    }
}

internal struct ArrivalWrapper_Stop: Decodable {
    
    var lines: [LineSummary]
    
    private enum CodingKeys: String, CodingKey {
        case stops = "p"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let stop = try values.decode(OVStop.self, forKey: .stops)
        lines = stop.lines ?? [LineSummary]()
    }
}

