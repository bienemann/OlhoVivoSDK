//
//  LineInteractorTests.swift
//  BusTrackerTests
//
//  Created by Allan Martins on 07/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import BusTracker

class LineInteractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testSearchSuccessFourLines() {
        
        BTStubs.stubSearch("8000")
        
        let searchExpectation = expectation(description: "wait for search response")
        LineInteractor.search("8000") { (busLines, error) in
            searchExpectation.fulfill()
            XCTAssertNil(error, "Error not nil")
            XCTAssert(busLines?.count == 4, "Wrong number of lines in response")
        }
        
        wait(for: [searchExpectation], timeout: 1.0)
    }
    
}
