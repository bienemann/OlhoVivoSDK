//
//  BTStubs.swift
//  BusTrackerTests
//
//  Created by Allan Martins on 07/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import XCTest
import Foundation
import OHHTTPStubs
@testable import BusTracker

struct BTStubs {
    
    static let jsonBaseName = "linha_buscar_termosBusca_"
    static func stubSearch(_ query: String) {
        stub(condition: { testRequest -> Bool in
            
            do {
                let searchRequest = try BTRequest.searchLine(query: query).asURLRequest()
                return testRequest == searchRequest
            } catch {
                return false
            }
            
            
        }) { _ in
            
            guard
                let testBundle = Bundle(identifier: "com.aya.BusTrackerTests"),
                let filePath = testBundle.path(forResource: (BTStubs.jsonBaseName + "8000"), ofType: "json")
                else {
                    let error = NSError(domain: NSURLErrorDomain,
                                        code: NSURLErrorFileDoesNotExist,
                                        userInfo: nil)
                    return OHHTTPStubsResponse(error: error)
            }
            
            return OHHTTPStubsResponse(
                fileAtPath: filePath,
                statusCode: 200,
                headers: nil)
        }
        
    }
    
}
