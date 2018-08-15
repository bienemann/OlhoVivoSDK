//
//  BusStop.swift
//  BusTracker
//
//  Created by Allan Martins on 10/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import CoreLocation

struct BusStop: Decodable {

    var stopID: Int
    var name: String
    var address: String?
    var coords: CLLocationCoordinate2D
    var lines: [LineSummary]?
    
    private enum CodingKeys: String, CodingKey {
        case stopID = "cp"
        case name = "np"
        case address = "ed"
        case lat = "py"
        case lon = "px"
        case lines = "l"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        stopID = try values.decode(Int.self, forKey: .stopID)
        name = try values.decode(String.self, forKey: .name)
        
        let lat = try values.decode(Double.self, forKey: .lat)
        let lon = try values.decode(Double.self, forKey: .lon)
        coords = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        if values.contains(.address) {
            address = try values.decode(String.self, forKey: .address)
        }
        
        if values.contains(.lines) {
            lines = try values.decode([LineSummary].self, forKey: .lines)
        }
        
    }
    
    init(testingID: Int) {
        stopID = testingID
        name = ""
        coords = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
    
}
