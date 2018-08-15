//
//  StopInteractorTests.swift
//  BusTrackerTests
//
//  Created by Allan Martins on 13/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import OlhoVivoSDK

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
        
        let line = BusLine(testingID: 1273)
        BTStubs.stubStops(by: line)
        
        let searchExpectation = expectation(description: "expectation for stops search response")
        BusStopInteractor.stops(for: line) { (stops, error) in
            searchExpectation.fulfill()
            XCTAssertNil(error, "Error not nil")
            XCTAssertNotNil(stops, "No errors but [BusStop] is nil")
            XCTAssertFalse(stops!.isEmpty, "Stops list is empty")
            XCTAssert(stops!.first!.stopID == 7014417, "Wrong return value")
            print("#test: \(stops!.first!.name)")
        }
        
        wait(for: [searchExpectation], timeout: 1.0)
        
    }
    
    func testStopsByCorridor() {
        
        guard
            let data = "[{\"cc\":8,\"nc\":\"Campo Limpo\"}]".data(using: .utf8),
            let corridorList = Corridor.listFrom(data),
            let corridor = corridorList.first
        else {
            XCTFail()
            return
        }
        
        BTStubs.stubStops(by: corridor)
        let searchExpectation = expectation(description: "expectation for stops by corridor response")
        
        BusStopInteractor.stops(for: corridor) { (stops, error) in
            searchExpectation.fulfill()
            XCTAssertNil(error, "Error not nil")
            XCTAssertNotNil(stops, "No errors but [BusStop] is nil")
            XCTAssertFalse(stops!.isEmpty, "Stops list is empty")
            XCTAssert(stops!.first!.stopID == 260016859, "Wrong return value")
            print("#test: \(stops!.first!.name)")
        }
        
        wait(for: [searchExpectation], timeout: 1.0)
        
    }
    
}
