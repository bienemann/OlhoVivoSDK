//
//  OVPosition.swift
//  BusTracker
//
//  Created by Allan Martins on 14/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import CoreLocation

internal struct PositionWrapper: Decodable {
    var positions: [OVPosition]
    
    internal enum CodingKeys: String, CodingKey {
        case positions = "vs"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        positions = try values.decode([OVPosition].self, forKey: .positions)
    }
}

public struct OVPosition: Decodable {
    
    public var prefix: String
    public var accessibilityEnabled: Bool
    public var date: Date
    public var coords: CLLocationCoordinate2D
    public var arrival: String?
    
    private enum CodingKeys: String, CodingKey {
        case prefix = "p"
        case handicap = "a"
        case date = "ta"
        case lat = "py"
        case lon = "px"
        case arrival = "t"
    }
    
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        prefix = try values.decode(String.self, forKey: .prefix)
        accessibilityEnabled = try values.decode(Bool.self, forKey: .handicap)
        date = try values.decode(Date.self, forKey: .date)
        
        let lat = try values.decode(Double.self, forKey: .lat)
        let lon = try values.decode(Double.self, forKey: .lon)
        coords = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        if values.contains(.arrival) {
            arrival = try values.decode(String.self, forKey: .arrival)
        }
    }
    
    init(testingID: Int) {
        prefix = "0"
        accessibilityEnabled = false
        date = Date()
        coords = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        arrival = "10:30"
    }
    
}

extension OVPosition { // arrival time
    
    func nextArrivalDateComponents() -> DateComponents? {
        guard
            let arrivalTime = arrival,
            let arrivalDateTime = CustomFormatter.shared.arrivalDate.date(from: arrivalTime)
        else {
            return nil
        }
        
        return DateComponents(
            hour: CustomFormatter.shared.calendar.component(.hour, from: arrivalDateTime),
            minute: CustomFormatter.shared.calendar.component(.minute, from: arrivalDateTime)
        )
    }
    
    public func timeIntervalToNextArrival(since: Date = Date()) -> TimeInterval? {
        
        guard
            let arrivalDateComponents = nextArrivalDateComponents(),
            let arrivalDate = CustomFormatter.shared.calendar.nextDate(
                after: since, matching: arrivalDateComponents,
                matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward
            )
        else {
            return nil
        }
        
        return arrivalDate.timeIntervalSince(since)
        
    }
    
    public func formattedNextArrival(_ referenceDate: Date = Date()) -> String? {
        
        guard
            let interval = timeIntervalToNextArrival(since: referenceDate),
            let formattedInterval = CustomFormatter.shared.arrivalTime.string(from: interval)
        else {
            return nil
        }
        
        return formattedInterval
    }
    
}
