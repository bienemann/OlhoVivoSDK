//
//  Formatters.swift
//  BusTracker
//
//  Created by Allan Martins on 15/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

class CustomFormatter {
    
    public static let shared = CustomFormatter()
    public var calendar: Calendar
    
    public lazy var arrivalDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    public lazy var arrivalTime: DateComponentsFormatter = {
        let componentsFormatter = DateComponentsFormatter()
        componentsFormatter.calendar = calendar
        componentsFormatter.unitsStyle = .full
        componentsFormatter.allowedUnits = [ .hour, .minute ]
        componentsFormatter.zeroFormattingBehavior = [ .pad ]
        return componentsFormatter
    }()
    
    public required init(calendar: Calendar) {
        self.calendar = calendar
    }
    
    private init() {
        self.calendar = Calendar.current
    }
    
}
