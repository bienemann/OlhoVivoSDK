//
//  PositionInteractorTests.swift
//  BusTrackerTests
//
//  Created by Allan Martins on 14/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import OlhoVivoSDK

class PositionInteractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testWithLineID() {
        
        let line = OVLine(testingID: 1273)
        
        BTStubs.stubPosition(line: line)
        let searchExpectation = expectation(description: "expectation for positions response")
        PositionInteractor.list(for: line) { (positions, error) in
            searchExpectation.fulfill()
            XCTAssertNil(error, "Error not nil")
            XCTAssertNotNil(positions, "No errors but [BusPosition] is nil")
            XCTAssertFalse(positions!.isEmpty, "BusPosition list is empty")
            XCTAssert(positions!.first!.prefix == "11391", "Not the expected bus prefix")
        }
        
        wait(for: [searchExpectation], timeout: 1.0)
    }
    
}
