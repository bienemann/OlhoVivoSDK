//
//  NetworkTests.swift
//  OlhoVivoSDKTests
//
//  Created by Allan Martins on 15/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import OlhoVivoSDK

class NetworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testRetrier() {
        
        BTStubs.stubFailedRequest(id: 0)
        let stop = OVStop(testingID: 0)
        var count = 0
        
        let requestExpectation = expectation(description: "expectation for failed response")
        let counterExpectation = expectation(description: "expectation for counter to reach 3")
        
        let helper: RetryHelperBlock = { (error) -> (Bool, TimeInterval) in
            count += 1
            if count == 3 {
                counterExpectation.fulfill()
                return (false, 0.0)
            }
            return(true, 0.15)
        }
        
        ArrivalInteractor.nextArrivals(at: stop, helper) { (lines, error) in
            requestExpectation.fulfill()
            XCTAssertNotNil(error, "Error should not be nil")
        }
        
        wait(for: [requestExpectation, counterExpectation], timeout: 2.0)
    }
    
    func testParallelRetrier() {
        
        BTStubs.stubFailedRequest(id: 0)
        BTStubs.stubFailedRequest(id: 1)
        
        let firstStop = OVStop(testingID: 0)
        let secondStop = OVStop(testingID: 1)
        var count_01 = 0
        var count_02 = 0
        
        let firstRequestExpectation = expectation(description: "expectation for failed response")
        let secondRequestExpectation = expectation(description: "expectation for second failed response")
        
        let firstHelper: RetryHelperBlock = { (error) -> (Bool, TimeInterval) in
            count_01 += 1
            if count_01 == 2 {
                return (false, 0.0)
            }
            return(true, 0.15)
        }
        
        let secondHelper: RetryHelperBlock = { (error) -> (Bool, TimeInterval) in
            count_02 += 1
            if count_02 == 5 {
                return (false, 0.0)
            }
            return(true, 0.15)
        }
        
        ArrivalInteractor.nextArrivals(at: firstStop, firstHelper) { (lines, error) in
            firstRequestExpectation.fulfill()
            XCTAssertNotNil(error, "Error should not be nil")
        }
        
        ArrivalInteractor.nextArrivals(at: secondStop, secondHelper) { (lines, error) in
            secondRequestExpectation.fulfill()
            XCTAssertNotNil(error, "Error should not be nil")
        }
        
        wait(for: [firstRequestExpectation, secondRequestExpectation], timeout: 2)
        
        XCTAssert(count_01 == 2, "count was \(count_01)")
        XCTAssert(count_02 == 5, "count was \(count_02)")
    }
    
}
