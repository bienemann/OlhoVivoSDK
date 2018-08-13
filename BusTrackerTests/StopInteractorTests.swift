//
//  StopInteractorTests.swift
//  BusTrackerTests
//
//  Created by Allan Martins on 13/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import BusTracker

class StopInteractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testStopSearch() {
    
        BTStubs.stubStopsSearch("afonso")
        
        let searchExpectation = expectation(description: "expectation for stops search response")
        BusStopInteractor.search("afonso") { (stops, error) in
            searchExpectation.fulfill()
            XCTAssertNil(error, "Error not nil")
            XCTAssertNotNil(stops, "No errors but [BusStop] is nil")
            XCTAssertFalse(stops!.isEmpty, "Stops list is empty")
            XCTAssert(stops!.first!.stopID == 340015329, "Wrong return value")
            print("#test: \(stops!.first!.name)")
        }
        
        wait(for: [searchExpectation], timeout: 1.0)
    }
    
    func testStopByLine() {
        
        BTStubs.stubSearch("8000")
        var line: BusLine?
        let lineExpectation = expectation(description: "Waiting for lines search")
        LineInteractor.search("8000") { (lines, _) in
            lineExpectation.fulfill()
            XCTAssertNotNil(lines?.first)
            line = lines?.first
        }
        wait(for: [lineExpectation], timeout: 1.0)
        
        line?.lineID = 1273
        BTStubs.stubStops(by: line!)
        let searchExpectation = expectation(description: "expectation for stops search response")
        BusStopInteractor.stops(for: line!) { (stops, error) in
            searchExpectation.fulfill()
            XCTAssertNil(error, "Error not nil")
            XCTAssertNotNil(stops, "No errors but [BusStop] is nil")
            XCTAssertFalse(stops!.isEmpty, "Stops list is empty")
            XCTAssert(stops!.first!.stopID == 7014417, "Wrong return value")
            print("#test: \(stops!.first!.name)")
        }
        
        wait(for: [searchExpectation], timeout: 1.0)
        
    }
    
}
