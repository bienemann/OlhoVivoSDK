//
//  BusPositionTests.swift
//  BusTrackerTests
//
//  Created by Allan Martins on 15/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import XCTest
@testable import OlhoVivoSDK

class BusPositionTests: XCTestCase {
    
    var referenceDate: Date!
    
    override func setUp() {
        super.setUp()
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: -3*60*60)!
        calendar.locale = Locale.current
        CustomFormatter.shared.calendar = calendar
        
        referenceDate = CustomFormatter.shared.calendar.date(
            bySettingHour: 4, minute: 30, second: 0, of: Date()
        )!
    }
    
    func testInvalidArrivalTime() {
        
        var testPosition = BusPosition(testingID: 0)
        testPosition.arrival = "dgshja"
        let interval = testPosition.formattedNextArrival(referenceDate)
        
        XCTAssertNil(interval)
        
    }
    
    func testFormattedInterval() {
        
        CustomFormatter.shared.calendar.locale = Locale(identifier: "pt_BR")
        referenceDate = CustomFormatter.shared.calendar.date(
            bySettingHour: 4, minute: 30, second: 0, of: Date()
        )!
        
        let testPosition = BusPosition(testingID: 0)
        let interval = testPosition.formattedNextArrival(referenceDate)
        
        XCTAssert(interval == "5 horas e 0 minuto")
    }
    
    func testSameDayArrival() {
        
        let testPosition = BusPosition(testingID: 0)
        let interval = testPosition.timeIntervalToNextArrival(since: referenceDate)
        XCTAssertNotNil(interval)
        XCTAssert(interval! == 18000.0)
    }
    
    func testNextDayArrival() {
        
        let referenceDate = CustomFormatter.shared.calendar.date(
            bySettingHour: 11, minute: 30, second: 0, of: Date()
        )!
        let testPosition = BusPosition(testingID: 0)
        let interval = testPosition.timeIntervalToNextArrival(since: referenceDate)
        XCTAssertNotNil(interval)
        XCTAssert(interval! == 79200.0)
    }
    
}
