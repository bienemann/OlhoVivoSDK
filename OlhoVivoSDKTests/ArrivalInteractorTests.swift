//
//  ArrivalInteractor.swift
//  BusTrackerTests
//
//  Created by Allan Martins on 15/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import OlhoVivoSDK

class ArrivalInteractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testSpecific() {
        
        let line = OVLine(testingID: 1273)
        let stop = OVStop(testingID: 670010530)
        BTStubs.stubSpecificArrivals(line: line, stop: stop)
        
        let searchExpectation = expectation(description: "expectation for arrival response")
        ArrivalInteractor.nextArrivals(of: line, at: stop) { (positions, error) in
            searchExpectation.fulfill()
            XCTAssertNil(error, "Error not nil")
            XCTAssertNotNil(positions, "No errors but [BusPosition] is nil")
            XCTAssertFalse(positions!.isEmpty, "BusPosition list is empty")
            XCTAssert(positions!.first!.prefix == "11484", "Not the expected bus prefix")
        }
        
        wait(for: [searchExpectation], timeout: 1.0)
        
    }
    
    func testLine() {
        
        let line = OVLine(testingID: 1273)
        BTStubs.stubArrivals(of: line)
        
        let searchExpectation = expectation(description: "expectation for arrivals of line response")
        ArrivalInteractor.nextArrivals(of: line) { (stops, error) in
            searchExpectation.fulfill()
            XCTAssertNil(error, "Error not nil")
            XCTAssertNotNil(stops, "No errors but [BusStop] is nil")
            XCTAssertFalse(stops!.isEmpty, "BusStop list is empty")
            XCTAssert(stops!.first!.stopID == 700016623, "Not the expected stop")
            XCTAssert(stops!.first!.arrivals?.count == 3, "Not the expected number of vehicles")
        }
        
        wait(for: [searchExpectation], timeout: 1.0)
        
    }
    
    func testStop() {
        
        let stop = OVStop(testingID: 700016623)
        BTStubs.stubArrivals(stop: stop)
        
        let searchExpectation = expectation(description: "expectation for arrivals of line response")
        ArrivalInteractor.nextArrivals(at: stop) { (lines, error) in
            searchExpectation.fulfill()
            XCTAssertNil(error, "Error not nil")
            XCTAssertNotNil(lines, "No errors but [LineSummary] is nil")
            XCTAssertFalse(lines!.isEmpty, "LineSummary list is empty")
            XCTAssert(lines!.last!.lineID == 443, "Not the expected bus line")
            XCTAssert(lines!.last!.positionList.first!.prefix == "11578")
        }
        
        wait(for: [searchExpectation], timeout: 1.0)
        
    }
    
}

