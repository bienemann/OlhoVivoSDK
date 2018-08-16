//
//  OVStop.swift
//  BusTracker
//
//  Created by Allan Martins on 10/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import CoreLocation

public struct OVStop: Decodable {

    public var stopID: Int
    public var name: String
    public var address: String?
    public var coords: CLLocationCoordinate2D
    public var lines: [LineSummary]?
    public var arrivals: [OVPosition]?
    
    private enum CodingKeys: String, CodingKey {
        case stopID = "cp"
        case name = "np"
        case address = "ed"
        case lat = "py"
        case lon = "px"
        case lines = "l"
        case arrivals = "vs"
    }
    
    public init(from decoder: Decoder) throws {
        
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
        
        if values.contains(.arrivals) {
            arrivals = try values.decode([OVPosition].self, forKey: .arrivals)
        }
        
    }
    
    init(testingID: Int) {
        stopID = testingID
        name = ""
        coords = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
    
}
