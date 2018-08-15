//
//  ArrivalInteractor.swift
//  BusTrackerTests
//
//  Created by Allan Martins on 15/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import BusTracker

class ArrivalInteractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testSpecific() {
        
        let line = BusLine(testingID: 1273)
        let stop = BusStop(testingID: 670010530)
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
    
}

