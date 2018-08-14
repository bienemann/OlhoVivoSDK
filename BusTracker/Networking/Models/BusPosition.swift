//
//  BusPosition.swift
//  BusTracker
//
//  Created by Allan Martins on 14/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import CoreLocation

struct PositionWrapper: Decodable {
    var positions: [BusPosition]
    
    private enum CodingKeys: String, CodingKey {
        case positions = "vs"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        positions = try values.decode([BusPosition].self, forKey: .positions)
    }
}

struct BusPosition: Decodable {
    
    var prefix: String
    var accessibilityEnabled: Bool
    var date: Date
    var coords: CLLocationCoordinate2D
    
    private enum CodingKeys: String, CodingKey {
        case prefix = "p"
        case handicap = "a"
        case date = "ta"
        case lat = "py"
        case lon = "px"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        prefix = try values.decode(String.self, forKey: .prefix)
        accessibilityEnabled = try values.decode(Bool.self, forKey: .handicap)
        date = try values.decode(Date.self, forKey: .date)
        
        let lat = try values.decode(Double.self, forKey: .lat)
        let lon = try values.decode(Double.self, forKey: .lon)
        coords = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
    }
    
}
